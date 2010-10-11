Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756082Ab0JKTsy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 15:48:54 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:58333 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755925Ab0JKTsx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 15:48:53 -0400
Date: Mon, 11 Oct 2010 14:52:00 -0500
From: Sonny Rao <sonnyrao@us.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Nishanth Aravamudan <nacc@us.ibm.com>, miltonm@bga.com,
        Thomas Gleixner <tglx@linutronix.de>,
        Ian Campbell <ian.campbell@citrix.com>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        linux-kernel@vger.kernel.org, sonnyrao@linux.vnet.ibm.com
Subject: Re: [RESEND PATCH 1/2] IRQ: use cpu_possible_mask rather than
 online_mask in setup_affinity
Message-ID: <20101011195200.GA13726@us.ibm.com>
References: <1285968378-12805-1-git-send-email-nacc@us.ibm.com>
 <1285968378-12805-2-git-send-email-nacc@us.ibm.com>
 <1286017262.2144.90.camel@laptop>
 <20101006210236.GQ13726@us.ibm.com>
 <1286822905.1998.96.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1286822905.1998.96.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 11, 2010 at 08:48:25PM +0200, Peter Zijlstra wrote:
> On Wed, 2010-10-06 at 16:02 -0500, Sonny Rao wrote:
> > > > With user-driven dynamic SMT,
> > > 
> > > What's that?
> > 
> > Well, that is basically a feature where we can use CPU hotplug to
> > force a particular mode on an SMT (hardware multithreaded) processor 
> > 
> > The point here was really that on such multi-threaded processors -- which are
> > becoming more common -- cpu hotplug can potentially be used fairly
> > often. 
> 
> I guess you're talking about the trainwreck called power7? Where you
> want to force the thing into SMT1/2 mode instead of letting it degrade
> into SMT4 mode?

This is not really Power7 specific, People could do this on *any*
multi-threaded processor just to ensure all core resources get
dedicated to one thread.  I've seen HPC users in particular do this
before.

> Why would you want to change that often? Do realize that cpu-hotplug is
> a very heavy, very expensive operation, doing it more than a few times
> an hour counts as excessive in my book.
>
> For RT I've been thinking of extending cpusets with a feature that
> allows you to disable things like SMT and MC on a set, ensuring you get
> no pipeline/cache interference.
> 
> But this is something you setup once and then run your workload, its not
> something you'll change often (in fact, hotplugging cpus will utterly
> wreck your RT workload).

This is exactly what I'm talking about -- there are people who have
multi-threaded processors who want to run long-running batch jobs
and sometimes will want to change the SMT mode of the processor
without rebooting.  CPU hotplug has been used in this manner for some
time.  So it's not something that happens often, but it does happen.
 
> Also, I don't see why you would want to have interrupts with affinity to
> offline cpus only, that sounds plain wrong, an offline'd cpu is not able
> to deal with interrupts.
> 
> I wish people would stop abusing hotplug as:
>   - resource management
>   - power management
>   - other crazy ass things
> 
> Its not suitable for those..

"resource management" is a rather broad term -- I think one of the
major use cases of cpu hotplug is in fact "resource management"
in the sense of a partition or guest VM needs more or less compute
resources.  Multi-threaded processors are also doing a form of
resource management in that they're dividing (or not dividing) the
resources available to a core -- cache, pipelines, functional units,
etc.

If it's not suitable for "resource management" then why does it exist?

Sonny
