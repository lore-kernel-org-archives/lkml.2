Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932798Ab0FQIzZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 04:55:25 -0400
Received: from one.firstfloor.org ([213.235.205.2]:43021 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932663Ab0FQIzX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 04:55:23 -0400
To: Zachary Amsden <zamsden@redhat.com>
Cc: avi@redhat.com, mtosatti@redhat.com, glommer@redhat.com,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 17/17] Add timekeeping documentation
From: Andi Kleen <andi@firstfloor.org>
References: <1276587259-32319-1-git-send-email-zamsden@redhat.com>
	<1276587259-32319-18-git-send-email-zamsden@redhat.com>
Date: Thu, 17 Jun 2010 10:55:21 +0200
In-Reply-To: <1276587259-32319-18-git-send-email-zamsden@redhat.com> (Zachary Amsden's message of "Mon\, 14 Jun 2010 21\:34\:19 -1000")
Message-ID: <87mxuuujgm.fsf@basil.nowhere.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zachary Amsden <zamsden@redhat.com> writes:

I think listing all the obscure bits in the PIT was an attempt to 
weed out the weak and weary readers early, right?

> +this as well.  Several hardware limitations make the problem worse - if it is
> +not possible to write the full 32-bits of the TSC, it may be impossible to
> +match the TSC in newly arriving CPUs to that of the rest of the system,
> +resulting in unsynchronized TSCs.  This may be done by BIOS or system software,
> +but in practice, getting a perfectly synchronized TSC will not be possible
> +unless all values are read from the same clock, which generally only is
> +possible on single socket systems or those with special hardware
> +support.

That's not true, single crystal for all sockets is very common
as long as you only have a single motherboard.

Of course there might be other reasons why the TSC is unsynchronized
(e.g. stop count in C-states), but the single clock is not the problem.

> +3.4) TSC and C-states
> +
> +C-states, or idling states of the processor, especially C1E and deeper sleep
> +states may be problematic for TSC as well.  The TSC may stop advancing in such
> +a state, resulting in a TSC which is behind that of other CPUs when execution
> +is resumed.  Such CPUs must be detected and flagged by the operating system
> +based on CPU and chipset identifications.
> +
> +The TSC in such a case may be corrected by catching it up to a known external
> +clocksource.

... This is fixed in recent CPUs ...

> +
> +3.5) TSC frequency change / P-states
> +
> +To make things slightly more interesting, some CPUs may change requency.  They
> +may or may not run the TSC at the same rate, and because the frequency change
> +may be staggered or slewed, at some points in time, the TSC rate may not be
> +known other than falling within a range of values.  In this case, the TSC will
> +not be a stable time source, and must be calibrated against a known, stable,
> +external clock to be a usable source of time.
> +
> +Whether the TSC runs at a constant rate or scales with the P-state is model
> +dependent and must be determined by inspecting CPUID, chipset or various MSR
> +fields.

... In general newer CPUs should not have problems with this anymore

> +
> +4) Virtualization Problems
> +
> +Timekeeping is especially problematic for virtualization because a number of
> +challenges arise.  The most obvious problem is that time is now shared between
> +the host and, potentially, a number of virtual machines.  This happens
> +naturally on X86 systems when SMM mode is used by the BIOS, but not to such a
> +degree nor with such frequency.  However, the fact that SMM mode may cause

The SMM reference here seems at best odd. 

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
