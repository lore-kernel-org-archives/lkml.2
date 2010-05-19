Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755031Ab0ESIXf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 04:23:35 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:59590 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752611Ab0ESIXc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 04:23:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=pFnw+LskoEjyRYtTN0Cfhcm5O5XyvNw0N+kLqbOaNPgj3GR3OryyUbW0gPmgPX7Lyd
         xauhbF2bMnr0qkY2mdkFLhZDCvSncryIJkNqMY9OXIeIl2L4x3jyMmr3OUYEbblZodNc
         KcLTZrg8QHxmEXOyDal+8WgHJ7PePru1yBR1U=
Date: Wed, 19 May 2010 10:23:36 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, efault@gmx.de, rostedt@goodmis.org,
       tglx@linutronix.de, mingo@elte.hu, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/core] perf/ftrace: Optimize perf/tracepoint
	interaction for single events
Message-ID: <20100519082335.GG5704@nowhere>
References: <tip-4f41c013f553957765902fb01475972f0af3e8e7@git.kernel.org> <20100519075804.GF5704@nowhere> <1274257123.5605.10260.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1274257123.5605.10260.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 19, 2010 at 10:18:43AM +0200, Peter Zijlstra wrote:
> On Wed, 2010-05-19 at 09:58 +0200, Frederic Weisbecker wrote:
> > On Tue, May 18, 2010 at 05:15:42PM +0000, tip-bot for Peter Zijlstra wrote:
> > > Commit-ID:  4f41c013f553957765902fb01475972f0af3e8e7
> > > Gitweb:     http://git.kernel.org/tip/4f41c013f553957765902fb01475972f0af3e8e7
> > > Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
> > > AuthorDate: Tue, 18 May 2010 18:08:32 +0200
> > > Committer:  Ingo Molnar <mingo@elte.hu>
> > > CommitDate: Tue, 18 May 2010 18:35:46 +0200
> > > 
> > > perf/ftrace: Optimize perf/tracepoint interaction for single events
> > > 
> > > When we've got but a single event per tracepoint
> > > there is no reason to try and multiplex it so don't.
> > > 
> 
> > I haven't seen this patch going.
> > 
> > But yeah that's a nice optimization for UP machines.
> 
> Uhm, doesn't have anything to do with UP machines... it works quite well
> on SMP as well.
> 
> Its about tracepoints with a single event attached.


Yeah, then if you launch perf sched for example, you'll have NR_CPU perf events
attached to each lock trace events, since we create one event per cpu.

Or may be I'm somewhat confused...

