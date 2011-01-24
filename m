Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752017Ab1AXV7u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 16:59:50 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:61644 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751432Ab1AXV7o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 16:59:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=RGiFfix01a9A5n/mhGyVQA59yEv/ksokyVFGgVwOYj054D55b87+yJr1gjLSJARzWk
         eTMIIf2ooKccxyW2262SaakpBd/7rwjauIKPEgjtaQZ8HjU5+p7TopQSp5E9laArwys0
         6sJLVHqSkRh+S+mxOKOK7s+iI+z6CB5/C2l6c=
Date: Mon, 24 Jan 2011 22:59:38 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Renninger <trenn@suse.de>, tardyp@gmail.com,
        jean.pihet@newoldbits.com, acme@ghostprotocols.net,
        linux-perf-users@vger.kernel.org, mathieu.desnoyers@efficios.com,
        linux-trace-users@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Perf ABI versioning
Message-ID: <20110124215935.GE2318@nowhere>
References: <201101241704.01021.trenn@suse.de>
 <20110124203449.GC2318@nowhere>
 <20110124212838.GB13724@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110124212838.GB13724@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 24, 2011 at 10:28:38PM +0100, Ingo Molnar wrote:
> 
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > This may be generally useful to help dealing with tracepoint ABI changes.
> > 
> > But instead of a global tracing ABI number, I would rather suggest one number per 
> > tracepoint subsystem (sched, power, etc...).
> 
> Nooooooooooo ... !!! :-)
> 
> Please lets stop this madness before it gets too serious: we dont do ABI version 
> numbering in Linux, full stop.
> 
> We use 'natural' ABIs where the lack of an ABI component triggers some sort of 
> clean, finegrained error. Like a -EINVAL on a not-yet-implemented ABI component, a 
> non-existent file entry, or -ENOSYS on a non-existent syscall.
> 
> Such a design is arbitrarily backportable or forward portable, it's extensible and 
> it is actually maintainable.
> 
> In the ABI version numbering direction lies Windows madness ...
> 
> Thanks,
> 
> 	Ingo

Yeah. But the tracepoint case looked to me quite special as sometimes
the ABI doesn't evolved smoothly like in the scheme you describe (see
the power events case).

OTOH, checking the format file if we have lost or gained fields must be enough
already to, indeed, avoid a versioning madness :)
