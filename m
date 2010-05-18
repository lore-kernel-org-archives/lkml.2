Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754458Ab0ERC2K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 22:28:10 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:59859 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754272Ab0ERC2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 22:28:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=nrfagL+r9Ia9C7NPXUljbgMfPeYO8MU1ZDUO859NOLyOzPdhkaQSkp0n1abldPAtsR
         CcX6oKXlEcBLm+3BT6BMq6L/Ep74/vqIfsl7dgbnNbUK+FrUmg1NJ0QI80HpT4yeNLbU
         ekmLF0FSFlJqXTWBRnNFDdk4tcZwGGKemVZbk=
Date: Tue, 18 May 2010 04:28:12 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
       Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: Conflict between tip/tracing/core and tip/perf/core
Message-ID: <20100518022809.GC5359@nowhere>
References: <1274122242.26328.375.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1274122242.26328.375.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 17, 2010 at 02:50:42PM -0400, Steven Rostedt wrote:
> Hi,
> 
> Ingo asked me to resolve a conflict between tip/tracing/core and
> perf/core, and I came up with the below solution.
> 
> The conflict stems from the shrinking of TRACE_EVENT(), which affects
> both ftrace and perf (saves size on both too). It conflicts with:
> 
> 6cc8a7c1d8560c042f486b23318a6291569ab96b
> Author: Frederic Weisbecker <fweisbec@gmail.com>
> Date:   Fri Mar 19 01:23:53 2010 +0100
> perf: Fetch hot regs from the template caller
> 
> 
> The shrinking code removed the per event caller to the template
> (TRACE_CLASS). This was done because the shrinking code allows the trace
> event to be passed to the tracepoint probe, and removed the need to have
> a separate function for every event because the class can now have the
> event passed to it.
> 
> The conflicting code added the regs to the per event probe, which no
> longer exists.
> 
> Masami,
> 
> It also conflicted with the kprobe code, which is also in the fix up.
> 
> 
> Here's my conflict resolution:
> 
> is everyone fine with it?
> 
> -- Steve



Yep, no problem with it,

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>


Nothing related to this conflict resolution, but we have these
per cpu regs that are racy against NMI, I'll need to solve that
soon.

Thanks.

