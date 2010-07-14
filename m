Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757574Ab0GNXyL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 19:54:11 -0400
Received: from claw.goop.org ([74.207.240.146]:56137 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757100Ab0GNXyK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 19:54:10 -0400
Message-ID: <4C3E4E1F.1060303@goop.org>
Date: Wed, 14 Jul 2010 16:54:07 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Lightning/1.0b2pre Thunderbird/3.0.5
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Steven Rostedt <rostedt@rostedt.homelinux.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Christoph Hellwig <hch@lst.de>,
        Li Zefan <lizf@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Tom Zanussi <tzanussi@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andi Kleen <andi@firstfloor.org>, "H. Peter Anvin" <hpa@zytor.com>,
        "Frank Ch. Eigler" <fche@redhat.com>, Tejun Heo <htejun@gmail.com>
Subject: Re: [patch 1/2] x86_64 page fault NMI-safe
References: <20100714154923.947138065@efficios.com>	<20100714155804.049012415@efficios.com>	<AANLkTiml2uwYqQayTKjMN2gI3LnjVFpwxXkv8GN3McEE@mail.gmail.com>	<20100714170617.GB4955@Krystal>	<AANLkTinLB3gQNKFk9QRfBS8YEfxL3qxZDFw7vWHDOnmL@mail.gmail.com>	<20100714203940.GC22096@Krystal>	<AANLkTinM0eFnreNB5l_6f20oSGBchqAtYPb57tM01kUB@mail.gmail.com>	<20100714222115.GA30122@Krystal>	<AANLkTikLG4xVYfvuMtbuzsqcnzo1ut4dFAm6piqy2Lh7@mail.gmail.com>	<4C3E3F77.1090109@goop.org> <AANLkTinIJGHYtxWXGEN_pBxoIy0lhl_eRW0QSbuSuMQQ@mail.gmail.com>
In-Reply-To: <AANLkTinIJGHYtxWXGEN_pBxoIy0lhl_eRW0QSbuSuMQQ@mail.gmail.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/14/2010 04:02 PM, Linus Torvalds wrote:
> Umm, I know. It's what this whole discussion (non-paravirtualized) is
> all about. And I have a suggestion that should fix the
> non-paravirtualized case _without_ actually touching anything but the
> NMI code itself.
>
> What I tried to say is that the paravirtualized people should take a
> look at my suggestion, and see if they can apply the logic to their
> NMI handling too.

My point is that it's moot (for now) because there is no NMI handing.

>  And in the process totally remove the need for
> paravirtualizing iret, exactly because the approach handles the magic
> NMI lock logic entirely in the NMI handler itself.
>   

Nothing in this thread is ringing any alarm bells from that perspective,
so I don't much mind either way.  When I get around to dealing with
paravirtualized NMI, I'll look at the state of things and see how to go
from there.  (Xen's iret hypercall takes a flag to say whether to unmask
NMIs, which will probably come in handy.)

I don't think any of the other pure PV implementations have NMI either,
so I don't think it affects them.

> Wouldn't it be nice to be able to remove the need to paravirtualize iret?
>   

Of course.  But we also need to do an iret in a hypercall to handle ring
switching in some cases, so we still need it aside from the interrupt issue.

    J

