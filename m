Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757115Ab0GRSoF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jul 2010 14:44:05 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:50552 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757025Ab0GRSoB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jul 2010 14:44:01 -0400
X-Authority-Analysis: v=1.1 cv=g9Y3NohClm0xo0Au7hiKM/lwvZwqTqjWC8eysRFNA3U= c=1 sm=0 a=ZI5MULQygNwA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=Sq3EUCS3E7k_EMHr108A:9 a=1qQa-TZagDt7Pa8O1sc6oPLk3OsA:4 a=PUjeQqilurYA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [patch 1/2] x86_64 page fault NMI-safe
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Linus Torvalds <torvalds@linux-foundation.org>
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
In-Reply-To: <AANLkTildediWa_vkY76mLWoAjgdaEgIbWP0DsKu3Ujap@mail.gmail.com>
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
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Sun, 18 Jul 2010 14:43:50 -0400
Message-ID: <1279478630.12913.15.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-07-18 at 11:17 -0700, Linus Torvalds wrote:

> Oh, and the non-nested case obviously needs all the regular "make the
> kernel state look right" code. Like the swapgs stuff etc if required.
> My example code was really meant to just document the nesting
> handling, not the existing stuff we already need to do with
> save_paranoid etc.
> 
> And I really think it should work, but I'd again like to stress that
> it's just a RFD code sequence with no testing what-so-ever etc.
> 

Are you sure you don't want to use Mathieu's 2/2 patch? We are fixing
the x86 problem that iret re-enables NMIs, and you don't want to touch
anything else but the NMI code. But it may be saner to just fix the
places that call iret. We can perhaps encapsulate those into a single
macro that we can get right and will be correct everywhere it is used.

The ugliest part of Mathieu's code is dealing with paravirt, but
paravirt is ugly to begin with.

Doing this prevents nested NMIs as well as all the unknowns that will
come with dealing with nested NMIs. Where as, handling all iret's should
be straight forward, although a bit more intrusive than what we would
like.

Just saying,

-- Steve


