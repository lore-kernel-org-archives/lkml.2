Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752652Ab0HRBFG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 21:05:06 -0400
Received: from mail.openrapids.net ([64.15.138.104]:44616 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752489Ab0HRBFD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 21:05:03 -0400
Date: Tue, 17 Aug 2010 21:05:00 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Imre Deak <imre.deak@nokia.com>,
        Alexander Shishkin <virtuoso@slind.org>,
        Andi Kleen <andi@firstfloor.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Christoph Hellwig <hch@lst.de>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Tom Zanussi <tzanussi@gmail.com>, ltt-dev@lists.casi.polymtl.ca,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Ingo Molnar <mingo@elte.hu>, Alexey Dobriyan <adobriyan@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Jamie Lokier <jamie@shareable.org>, Li Zefan <lizf@cn.fujitsu.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC PATCH 01/20] Create generic alignment API (v8)
Message-ID: <20100818010500.GA2116@Krystal>
References: <20100817231619.277457797@efficios.com> <20100817232150.251244768@efficios.com> <20100818000056.GA5874@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100818000056.GA5874@shutemov.name>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 21:03:25 up 207 days,  3:40,  3 users,  load average: 0.12, 0.08,
	0.01
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Kirill A. Shutemov (kirill@shutemov.name) wrote:
> > Index: linux.trees.git/include/linux/align.h
> > ===================================================================
> > --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> > +++ linux.trees.git/include/linux/align.h	2010-08-17 16:31:50.000000000 -0400
> > @@ -0,0 +1,56 @@
> > +#ifndef _LINUX_ALIGN_H
> > +#define _LINUX_ALIGN_H
> > +
> > +#define __ALIGN_KERNEL(x, a)	__ALIGN_KERNEL_MASK((x), (typeof(x))(a) - 1)
>                                                     ^^^
> Unnecessary braces. And many below.

Good catch, thanks !

I also found some in:

Ring buffer backend
Ring buffer frontend

patches. I fixed them already, they should be OK in the next round.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
