Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965207Ab0GPLnr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 07:43:47 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:48928 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965166Ab0GPLnq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 07:43:46 -0400
X-Authority-Analysis: v=1.1 cv=yYDk9wvF9yILP8+WUBprz5rv2pbX1YDh8tMrnOgRP/g= c=1 sm=0 a=ZI5MULQygNwA:10 a=ood2b7iyd8MA:10 a=IkcTkHD0fZMA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=zd2uoN0lAAAA:8 a=G-ukndj-ycTV-QG9btsA:9 a=3abtujCnGTzuwEAcerQkF6ESpVAA:4 a=QEXdDO2ut3YA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [patch 1/2] x86_64 page fault NMI-safe
From: Steven Rostedt <rostedt@goodmis.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
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
In-Reply-To: <20100716104716.GA5377@nowhere>
References: <AANLkTinLB3gQNKFk9QRfBS8YEfxL3qxZDFw7vWHDOnmL@mail.gmail.com>
	 <20100714184642.GA9728@elte.hu>
	 <AANLkTil2r3sUcoCC_ktp3TV2JNTSMxbpke8yJMx_8lmm@mail.gmail.com>
	 <AANLkTinfmoKvi1SauDA5_RiTmu6bztTDk8b_ycS-lr8S@mail.gmail.com>
	 <20100714195617.GC22373@basil.fritz.box> <20100714200552.GA22096@Krystal>
	 <20100714223116.GB14533@nowhere>
	 <AANLkTik-sJL_pAJg38Hzpl_jpn2v90t7tppYqOGmu6p-@mail.gmail.com>
	 <20100715141118.GA6417@nowhere> <1279205173.4190.53.camel@localhost>
	 <20100716104716.GA5377@nowhere>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 16 Jul 2010 07:43:37 -0400
Message-ID: <1279280617.23610.34.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-07-16 at 12:47 +0200, Frederic Weisbecker wrote:
> > Thus the kernel maps the physical memory with the fewest TLB entries as
> > needed (large pages and large TLB entries). If we can map 64K pages, we
> > do that. Then kmalloc just allocates within this range, it does not need
> > to map any pages. They are already mapped.
> > 
> > Does this make a bit more sense?
> 
> 
> 
> Totally! You've made it very clear to me.
> Moreover I did not know we can have such variable page size. I mean I thought
> we can have variable page size but that would apply to every pages.

In x86_64, if bit 7 in the PDE (Page Directory Entry) is set then it
points to a 2 Meg page. Otherwise it points to a page table which will
have 512 PTE's pointing to 4K pages.

Download:

http://support.amd.com/us/Processor_TechDocs/24593.pdf

It has nice diagrams that explains this. Check out page 207 (fig 5-17)
and 210 (fig 5-22).

The phys_pmd_init() in arch/x86/mm/init_64.c will try to map memory
using 2M pages if it can, otherwise it falls back to 4K pages.

-- Steve

