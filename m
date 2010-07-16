Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966163Ab0GPTeL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 15:34:11 -0400
Received: from one.firstfloor.org ([213.235.205.2]:59265 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966095Ab0GPTeJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 15:34:09 -0400
Date: Fri, 16 Jul 2010 21:34:06 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Avi Kivity <avi@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
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
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, akpm@osdl.org,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        "Frank Ch. Eigler" <fche@redhat.com>
Subject: Re: [patch 2/2] x86 NMI-safe INT3 and Page Fault
Message-ID: <20100716193406.GF7338@basil.fritz.box>
References: <20100714154923.947138065@efficios.com>
 <20100714155804.252253097@efficios.com>
 <4C405078.20707@redhat.com>
 <20100716144927.GA22516@Krystal>
 <4C408D0C.5050709@redhat.com>
 <20100716165855.GA3836@Krystal>
 <4C409CBA.1050709@redhat.com>
 <4C409F62.6030303@zytor.com>
 <20100716192847.GC7338@basil.fritz.box>
 <4C40B3BD.7030101@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C40B3BD.7030101@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 16, 2010 at 10:32:13PM +0300, Avi Kivity wrote:
> On 07/16/2010 10:28 PM, Andi Kleen wrote:
> >
> >>I really hope noone ever gets the idea of touching user space from an
> >>NMI handler, though, and expecting it to work...
> >It can make sense for a backtrace in a profiler.
> >
> >In fact perf is nearly doing it I believe, but moves
> >it to the self IPI handler in most cases.
> 
> Interesting, is the self IPI guaranteed to execute synchronously
> after the NMI's IRET?  Or can the core IRET faster than the APIC and
> so we get the backtrace at the wrong place?
> 
> (and does it matter? the NMI itself is not always accurate)

self ipi runs after the next STI (or POPF)

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
