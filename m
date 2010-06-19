Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756234Ab0FSPRv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jun 2010 11:17:51 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:36622 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756157Ab0FSPRt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jun 2010 11:17:49 -0400
Date: Sat, 19 Jun 2010 20:47:41 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
To: Victor Lowther <victor.lowther@gmail.com>
Cc: Len Brown <lenb@kernel.org>,
       Linux Power Management List <linux-pm@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Subject: Re: [linux-pm] RFC: /sys/power/policy_preference
Message-ID: <20100619151741.GA18201@dirshya.in.ibm.com>
Reply-To: svaidy@linux.vnet.ibm.com
References: <alpine.LFD.2.00.1006161659140.24913@localhost.localdomain>
 <0F1C0B07-60D6-405B-890B-F9C320820CA5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <0F1C0B07-60D6-405B-890B-F9C320820CA5@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Victor Lowther <victor.lowther@gmail.com> [2010-06-17 11:14:50]:

> 
> 
> 
> 
> On Jun 16, 2010, at 4:05 PM, Len Brown <lenb@kernel.org> wrote:
> 
> >Create /sys/power/policy_preference, giving user-space
> >the ability to express its preference for kernel based
> >power vs. performance decisions in a single place.
> >
> >This gives kernel sub-systems and drivers a central place
> >to discover this system-wide policy preference.
> >It also allows user-space to not have to be updated
> >every time a sub-system or driver adds a new power/perf knob.
> 
> I would prefer documenting all the current knobs and adding them to
> pm-utils so that pm-powersave knows about and can manage them. Once
> that is done, creating arbitrary powersave levels should be fairly
> simple.

Hi Len,

Reading through this thread, I prefer the above recommendation.  We
have three main dimensions of (power savings) control (cpufreq,
cpuidle and scheduler) and you are combining them into a single policy
in the kernel.  The challenges are as follows:

* Number of policies will always limit flexibility
* More dimensions of control will be added in future and your
  intention is to transparently include them within these defined
  polices
* Even with the current implementations, power savings and performance
  impact widely vary based on system topology and workload.  There is
  no easy method to define modes such that one mode will _always_
  consume less power than the other
* Each subsystem can override the policy settings and create more
  combinations anyway

Your argument is that these modes can serve as a good default and allow
the user to tune the knobs directly for more sophisticated policies.
But in that case all kernel subsystem should default to the balanced
policy and let the user tweak individual subsystems for other modes.

On the other hand having the policy definitions in user space allows
us to create more flexible policies by considering higher level
factors like workload behavior, utilization, platform features,
power/thermal constraints etc.

--Vaidy

[snip]

