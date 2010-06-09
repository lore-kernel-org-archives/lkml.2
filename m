Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757656Ab0FILyF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 07:54:05 -0400
Received: from casper.infradead.org ([85.118.1.10]:58661 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754760Ab0FILyE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 07:54:04 -0400
Subject: Re: [PATCH][RFC] tracing: Use class->reg() for all registering of
 events
From: Peter Zijlstra <peterz@infradead.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
In-Reply-To: <20100609114753.GB5878@linux.vnet.ibm.com>
References: <1276011215.15884.96.camel@gandalf.stny.rr.com>
	 <1276012661.2046.120.camel@twins>
	 <20100608173559.GE2800@linux.vnet.ibm.com>
	 <1276024211.15884.107.camel@gandalf.stny.rr.com>
	 <20100609050534.GA5878@linux.vnet.ibm.com>
	 <1276065150.2046.1004.camel@twins>
	 <20100609114753.GB5878@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 09 Jun 2010 13:53:34 +0200
Message-ID: <1276084414.2046.1335.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-06-09 at 17:17 +0530, Srikar Dronamraju wrote:
> * Peter Zijlstra <peterz@infradead.org> [2010-06-09 08:32:30]:
> 
> > On Wed, 2010-06-09 at 10:35 +0530, Srikar Dronamraju wrote:
> > 
> > > Peter, can you please point me to the fix for the floating point
> > > exception patch?
> > 
> > Ingo just commited the fix, see tip commit f6ab91add6 (perf: Fix signed
> > comparison in perf_adjust_period()).
> 
> Actually this fix was already checked-in but I still see the problem.
> 
> When ran gdb on the core, it showed me that it was dumping in
> /usr/lib64/libnewt.so.0.52. in newtScaleSet function.
> My newt lib was of version : newt-0.52.2-15
> 
> I am now able to workaround the problem by uninstalling newt-devel.

Ah, ok, then we're talking about two different issues, the patch I
referred to solves a possible /0 in the kernel which triggers easily
with software events because of that unsigned comparison.

I'll have to defer to Arnaldo on the newt issue.
