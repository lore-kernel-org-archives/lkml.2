Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757702Ab0FIMCy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 08:02:54 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:33377 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757138Ab0FIMCw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 08:02:52 -0400
Date: Wed, 9 Jun 2010 09:02:24 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Subject: Re: [PATCH][RFC] tracing: Use class->reg() for all registering of
 events
Message-ID: <20100609120224.GA8359@ghostprotocols.net>
References: <1276011215.15884.96.camel@gandalf.stny.rr.com>
 <1276012661.2046.120.camel@twins>
 <20100608173559.GE2800@linux.vnet.ibm.com>
 <1276024211.15884.107.camel@gandalf.stny.rr.com>
 <20100609050534.GA5878@linux.vnet.ibm.com>
 <1276065150.2046.1004.camel@twins>
 <20100609114753.GB5878@linux.vnet.ibm.com>
 <1276084414.2046.1335.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1276084414.2046.1335.camel@twins>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Jun 09, 2010 at 01:53:34PM +0200, Peter Zijlstra escreveu:
> On Wed, 2010-06-09 at 17:17 +0530, Srikar Dronamraju wrote:
> > * Peter Zijlstra <peterz@infradead.org> [2010-06-09 08:32:30]:
> > 
> > > On Wed, 2010-06-09 at 10:35 +0530, Srikar Dronamraju wrote:
> > > 
> > > > Peter, can you please point me to the fix for the floating point
> > > > exception patch?
> > > 
> > > Ingo just commited the fix, see tip commit f6ab91add6 (perf: Fix signed
> > > comparison in perf_adjust_period()).
> > 
> > Actually this fix was already checked-in but I still see the problem.
> > 
> > When ran gdb on the core, it showed me that it was dumping in
> > /usr/lib64/libnewt.so.0.52. in newtScaleSet function.
> > My newt lib was of version : newt-0.52.2-15
> > 
> > I am now able to workaround the problem by uninstalling newt-devel.
> 
> Ah, ok, then we're talking about two different issues, the patch I
> referred to solves a possible /0 in the kernel which triggers easily
> with software events because of that unsigned comparison.
> 
> I'll have to defer to Arnaldo on the newt issue.

I'm trying to reproduce this now.
