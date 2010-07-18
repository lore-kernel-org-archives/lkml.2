Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757185Ab0GRT1j (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jul 2010 15:27:39 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42291 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757153Ab0GRT1g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jul 2010 15:27:36 -0400
MIME-Version: 1.0
In-Reply-To: <1279478630.12913.15.camel@gandalf.stny.rr.com>
References: <20100714154923.947138065@efficios.com>
	<20100714155804.049012415@efficios.com>
	<AANLkTiml2uwYqQayTKjMN2gI3LnjVFpwxXkv8GN3McEE@mail.gmail.com>
	<20100714170617.GB4955@Krystal>
	<AANLkTinLB3gQNKFk9QRfBS8YEfxL3qxZDFw7vWHDOnmL@mail.gmail.com>
	<20100714203940.GC22096@Krystal>
	<AANLkTinM0eFnreNB5l_6f20oSGBchqAtYPb57tM01kUB@mail.gmail.com>
	<20100714222115.GA30122@Krystal>
	<AANLkTikLG4xVYfvuMtbuzsqcnzo1ut4dFAm6piqy2Lh7@mail.gmail.com>
	<AANLkTin21xBD-BFY4ZX2BPRFnT5-LkgGugvWsvTEP4Mr@mail.gmail.com>
	<4C42DF9A.5090908@redhat.com>
	<AANLkTin1noI6IUfuQsbAgVVzj2rSOhm-Cx3WpsMBgdJ6@mail.gmail.com>
	<AANLkTildediWa_vkY76mLWoAjgdaEgIbWP0DsKu3Ujap@mail.gmail.com>
	<1279478630.12913.15.camel@gandalf.stny.rr.com>
Date: Sun, 18 Jul 2010 12:26:59 -0700
Message-ID: <AANLkTimnUopZImJCrrupNfbkk647zu-q93FwQIKVW9w5@mail.gmail.com>
Subject: Re: [patch 1/2] x86_64 page fault NMI-safe
From: Linus Torvalds <torvalds@linux-foundation.org>
To: rostedt@goodmis.org
Cc: Avi Kivity <avi@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
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
        Jeremy Fitzhardinge <jeremy@goop.org>,
        "Frank Ch. Eigler" <fche@redhat.com>, Tejun Heo <htejun@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 18, 2010 at 11:43 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
>
> Are you sure you don't want to use Mathieu's 2/2 patch?

Yeah, I'm pretty sure. Unless somebody can show that it's faster, I
really don't want to muck with regular iret's. Also, as shown during
the discussion, even with Mathieu's 2/2 patch, we'd _still_ need NMI
to also save cr2 etc.

So the sane thing to do is to put all the NMI crap where it belongs.
NMI's need to know about the fact that them taking exceptions is
special. That whole "vmalloc_sync_all()" is simply pure brokenness.

In other words, it is _not_ just about 'iret' fixup. It's a bigger
thing. NMI's are special, and we don't want to spread that specialness
around.

                  Linus
