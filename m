Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932697Ab0HOQel (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Aug 2010 12:34:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932128Ab0HOQej (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Aug 2010 12:34:39 -0400
Message-ID: <4C6816BD.8060101@redhat.com>
Date: Sun, 15 Aug 2010 19:33:01 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
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
Subject: Re: [patch 1/2] x86_64 page fault NMI-safe
References: <AANLkTinLB3gQNKFk9QRfBS8YEfxL3qxZDFw7vWHDOnmL@mail.gmail.com>	 <20100714184642.GA9728@elte.hu>	 <AANLkTil2r3sUcoCC_ktp3TV2JNTSMxbpke8yJMx_8lmm@mail.gmail.com>	 <20100714193652.GA13630@nowhere>	 <AANLkTilD4aYej_36lOCEvMNCdYc4jBIupi5-77oD9vD2@mail.gmail.com>	 <20100714221418.GA14533@nowhere> <20100714223107.GA2350@Krystal>	 <20100714224853.GC14533@nowhere> <20100714231117.GA22341@Krystal>	 <20100714233843.GD14533@nowhere> <20100715162631.GB30989@Krystal>	 <1280855904.1923.675.camel@laptop>	 <AANLkTinydcsYG6wj06bj0++EfiWUMQnZk=QvLQp=S8YB@mail.gmail.com>	 <1280903273.1923.682.camel@laptop> <1281537273.3058.14.camel@gandalf.stny.rr.com>
In-Reply-To: <1281537273.3058.14.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 08/11/2010 05:34 PM, Steven Rostedt wrote:
>
> So, I want to allocate a 10Meg buffer. I need to make sure the kernel
> has 10megs of memory available. If the memory is quite fragmented, then
> too bad, I lose out.

With memory compaction, the cpu churns for a while, then you have your 
buffer.  Of course there's still no guarantee, just a significantly 
higher probability of success.

> Oh wait, I could also use vmalloc. But then again, now I'm blasting
> valuable TLB entries for a tracing utility, thus making the tracer have
> a even bigger impact on the entire system.

Most trace entries will occupy much less than a page, and are accessed 
sequentially, so I don't think this will have a large impact.

-- 
error compiling committee.c: too many arguments to function

