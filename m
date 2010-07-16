Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965467Ab0GPMzH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 08:55:07 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:63437 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965280Ab0GPMzF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 08:55:05 -0400
X-Authority-Analysis: v=1.1 cv=Wd4F0Mu8V05kqqt67pyjJbbzQCzSsR+BbLtAgo88TiY= c=1 sm=0 a=ZI5MULQygNwA:10 a=ood2b7iyd8MA:10 a=IkcTkHD0fZMA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=C8wtieY37JN1cNuiyTUA:9 a=Kz5WqQLA3YsJU56H078A:7 a=QoIsEb3dWOhRzQwELjc2B6VCgI0A:4 a=QEXdDO2ut3YA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
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
In-Reply-To: <20100716120012.GC5377@nowhere>
References: <AANLkTinLB3gQNKFk9QRfBS8YEfxL3qxZDFw7vWHDOnmL@mail.gmail.com>
	 <20100714184642.GA9728@elte.hu>
	 <AANLkTil2r3sUcoCC_ktp3TV2JNTSMxbpke8yJMx_8lmm@mail.gmail.com>
	 <AANLkTinfmoKvi1SauDA5_RiTmu6bztTDk8b_ycS-lr8S@mail.gmail.com>
	 <20100714195617.GC22373@basil.fritz.box> <20100714200552.GA22096@Krystal>
	 <20100714223116.GB14533@nowhere>
	 <AANLkTik-sJL_pAJg38Hzpl_jpn2v90t7tppYqOGmu6p-@mail.gmail.com>
	 <20100715141118.GA6417@nowhere>
	 <AANLkTing-_-Oyq5EBT4miTPJf4zDuwIqLi6pT7CaE6EP@mail.gmail.com>
	 <20100716120012.GC5377@nowhere>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 16 Jul 2010 08:54:58 -0400
Message-ID: <1279284898.23610.36.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-07-16 at 14:00 +0200, Frederic Weisbecker wrote:
> On Thu, Jul 15, 2010 at 07:51:55AM -0700, Linus Torvalds wrote:

> 
> Such new page table created that might race is only about top level page
> right? Otherwise it wouldn't race since the top level entries are shared
> and then updates inside lower level pages are naturally propagated, if
> I understood you well.
> 
> So, if only top level pages that gets added can generate such lazily
> mapping update, I wonder why I experienced this fault everytime with
> my patches.
> 
> I allocated 8192 bytes per cpu in a x86-32 system that has only 2 GB.
> I doubt there is a top level page table update there at this time with
> such a small amount of available memory. But still it faults once on
> access.
> 
> I have troubles to visualize the race and the problem here.
> 

A few trace_printks and a tracing_off() on fault would probably show
exactly what was happening ;-)

-- Steve


