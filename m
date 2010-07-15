Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932714Ab0GOPrK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 11:47:10 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51064 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932457Ab0GOPrF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 11:47:05 -0400
MIME-Version: 1.0
In-Reply-To: <AANLkTing-_-Oyq5EBT4miTPJf4zDuwIqLi6pT7CaE6EP@mail.gmail.com>
References: <AANLkTiml2uwYqQayTKjMN2gI3LnjVFpwxXkv8GN3McEE@mail.gmail.com>
	<20100714170617.GB4955@Krystal>
	<AANLkTinLB3gQNKFk9QRfBS8YEfxL3qxZDFw7vWHDOnmL@mail.gmail.com>
	<20100714184642.GA9728@elte.hu>
	<AANLkTil2r3sUcoCC_ktp3TV2JNTSMxbpke8yJMx_8lmm@mail.gmail.com>
	<AANLkTinfmoKvi1SauDA5_RiTmu6bztTDk8b_ycS-lr8S@mail.gmail.com>
	<20100714195617.GC22373@basil.fritz.box>
	<20100714200552.GA22096@Krystal>
	<20100714223116.GB14533@nowhere>
	<AANLkTik-sJL_pAJg38Hzpl_jpn2v90t7tppYqOGmu6p-@mail.gmail.com>
	<20100715141118.GA6417@nowhere>
	<AANLkTing-_-Oyq5EBT4miTPJf4zDuwIqLi6pT7CaE6EP@mail.gmail.com>
Date: Thu, 15 Jul 2010 08:38:51 -0700
Message-ID: <AANLkTin8JxUJkltswhmkMMThZmc6HceURCyMXnqlhbT0@mail.gmail.com>
Subject: Re: [patch 1/2] x86_64 page fault NMI-safe
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Steven Rostedt <rostedt@rostedt.homelinux.com>,
        Thomas Gleixner <tglx@linutronix.de>, Christoph Hellwig <hch@lst.de>,
        Li Zefan <lizf@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Tom Zanussi <tzanussi@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        "Frank Ch. Eigler" <fche@redhat.com>, Tejun Heo <htejun@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 15, 2010 at 7:51 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> So it's not the lazy page table fill that is the problem. Never has
> been. We've been doing the lazy fill for a long time, and it was
> simple and useful way back when.

Btw, this is true to the degree that I would _much_ rather just get
rid of the crazy "vmalloc_sync_all()" crap entirely, and make it clear
that non-lazy vmalloc page table fill is a bug.

Because quite frankly, it _is_ a bug to depend on non-lazy vmalloc.
The whole function is only implemented on 32-bit x86, so any code that
thinks it needs it is either just wrong, or will only work on 32-bit
x86 anyway (and on other architectures by pure chance, likely because
their VM fill granularity is so big that they never saw the problem).

So getting rid of vmalloc_sync_all() entirely would be a good thing.
Then we wouldn't have that silly and pointless interface, and we
wouldn't have that crazy "this only does something on x86-32,
everywhere else it's a placebo".

                      Linus
