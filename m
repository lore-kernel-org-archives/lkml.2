Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750995Ab2BOO52 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 09:57:28 -0500
Received: from merlin.infradead.org ([205.233.59.134]:44981 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822Ab2BOO51 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 09:57:27 -0500
Message-ID: <1329317835.2293.133.camel@twins>
Subject: Re: [PATCH 2/2] x86, reschedule: check to see if system is shutting
 down
From: Peter Zijlstra <peterz@infradead.org>
To: Don Zickus <dzickus@redhat.com>
Cc: x86@kernel.org, LKML <linux-kernel@vger.kernel.org>, tony.luck@intel.com,
        seiji.aguchi@hds.com, ak@linux.intel.com, mjg@redhat.com,
        levinsasha928@gmail.com
Date: Wed, 15 Feb 2012 15:57:15 +0100
In-Reply-To: <20120215145429.GE9751@redhat.com>
References: <1329164860-668-1-git-send-email-dzickus@redhat.com>
	 <1329164860-668-3-git-send-email-dzickus@redhat.com>
	 <1329305197.2293.50.camel@twins> <20120215145429.GE9751@redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-02-15 at 09:54 -0500, Don Zickus wrote:
> On Wed, Feb 15, 2012 at 12:26:37PM +0100, Peter Zijlstra wrote:
> > 
> > Right, so this fixes this one particular case, I imagine there's tons of
> > places that could go splat due to this (but don't quite yet for some
> > reason).
> > 
> > We can't go around annotating everything, nor would we want to simply
> > shut up all warnings for fear of missing an actual error.
> > 
> > Why can't the normal shut-down path use a less crazy approach to going
> > down?
> 
> Well maybe it can, it's been like that way for over three years now.  I'm
> surprised no one ran into issues before now.
> 
> The only thing I can think that would work is stop_machine().  Pass in a
> halt function and a cpumask of everyone but smp_processor_id().  That
> would solve the problem, no?

nope.. same problem, you're not telling anybody you're shooting CPUs
down -- this telling is usually done through cpu hotplug notifiers that
fix up state.

The only way is to unplug all cpus except the one. Problem with that is
that we cannot (as of yet) unplug the boot cpu.
