Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751803Ab2BOP51 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 10:57:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:14378 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750862Ab2BOP50 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 10:57:26 -0500
Date: Wed, 15 Feb 2012 10:57:08 -0500
From: Don Zickus <dzickus@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: x86@kernel.org, LKML <linux-kernel@vger.kernel.org>, tony.luck@intel.com,
        seiji.aguchi@hds.com, ak@linux.intel.com, mjg@redhat.com,
        levinsasha928@gmail.com
Subject: Re: [PATCH 2/2] x86, reschedule: check to see if system is shutting
 down
Message-ID: <20120215155708.GK9751@redhat.com>
References: <1329164860-668-1-git-send-email-dzickus@redhat.com>
 <1329164860-668-3-git-send-email-dzickus@redhat.com>
 <1329305197.2293.50.camel@twins>
 <20120215145429.GE9751@redhat.com>
 <1329317835.2293.133.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1329317835.2293.133.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 15, 2012 at 03:57:15PM +0100, Peter Zijlstra wrote:
> On Wed, 2012-02-15 at 09:54 -0500, Don Zickus wrote:
> > On Wed, Feb 15, 2012 at 12:26:37PM +0100, Peter Zijlstra wrote:
> > > 
> > > Right, so this fixes this one particular case, I imagine there's tons of
> > > places that could go splat due to this (but don't quite yet for some
> > > reason).
> > > 
> > > We can't go around annotating everything, nor would we want to simply
> > > shut up all warnings for fear of missing an actual error.
> > > 
> > > Why can't the normal shut-down path use a less crazy approach to going
> > > down?
> > 
> > Well maybe it can, it's been like that way for over three years now.  I'm
> > surprised no one ran into issues before now.
> > 
> > The only thing I can think that would work is stop_machine().  Pass in a
> > halt function and a cpumask of everyone but smp_processor_id().  That
> > would solve the problem, no?
> 
> nope.. same problem, you're not telling anybody you're shooting CPUs
> down -- this telling is usually done through cpu hotplug notifiers that
> fix up state.

Why? If you have successfully sync'd up the cpus, stopped them and then
run a 'stop_cpu' function, you stop all those WARN_ONs I would think.  And
how much do we care that we fix up the state on a shutdown?  We have
already shutdown all the processes and unmounted the disks?  Most of the
drivers have probably been shutdown cleanly.  What is left that we have to
be polite?

> 
> The only way is to unplug all cpus except the one. Problem with that is
> that we cannot (as of yet) unplug the boot cpu.

Yeah, well we can migrate to the boot cpu.  I think powerpc does that for
kdump.

Cheers,
Don
