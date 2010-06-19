Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756716Ab0FSTGl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jun 2010 15:06:41 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:56303 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756622Ab0FSTGk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jun 2010 15:06:40 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: svaidy@linux.vnet.ibm.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [linux-pm] RFC: /sys/power/policy_preference
Date: Sat, 19 Jun 2010 21:04:47 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.35-rc3-rjw+; KDE/4.4.3; x86_64; ; )
Cc: Victor Lowther <victor.lowther@gmail.com>, Len Brown <lenb@kernel.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       linux-pm@lists.linux-foundation.org
References: <alpine.LFD.2.00.1006161659140.24913@localhost.localdomain> <0F1C0B07-60D6-405B-890B-F9C320820CA5@gmail.com> <20100619151741.GA18201@dirshya.in.ibm.com>
In-Reply-To: <20100619151741.GA18201@dirshya.in.ibm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201006192104.47438.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, June 19, 2010, Vaidyanathan Srinivasan wrote:
> * Victor Lowther <victor.lowther@gmail.com> [2010-06-17 11:14:50]:
> 
> > 
> > 
> > 
> > 
> > On Jun 16, 2010, at 4:05 PM, Len Brown <lenb@kernel.org> wrote:
> > 
> > >Create /sys/power/policy_preference, giving user-space
> > >the ability to express its preference for kernel based
> > >power vs. performance decisions in a single place.
> > >
> > >This gives kernel sub-systems and drivers a central place
> > >to discover this system-wide policy preference.
> > >It also allows user-space to not have to be updated
> > >every time a sub-system or driver adds a new power/perf knob.
> > 
> > I would prefer documenting all the current knobs and adding them to
> > pm-utils so that pm-powersave knows about and can manage them. Once
> > that is done, creating arbitrary powersave levels should be fairly
> > simple.
> 
> Hi Len,
> 
> Reading through this thread, I prefer the above recommendation.

It also reflects my opinion quite well.

> We have three main dimensions of (power savings) control (cpufreq,
> cpuidle and scheduler) and you are combining them into a single policy
> in the kernel.

There's more than that, because we're in the process of adding runtime PM
features to I/O device drivers.

> The challenges are as follows:
> 
> * Number of policies will always limit flexibility
> * More dimensions of control will be added in future and your
>   intention is to transparently include them within these defined
>   polices
> * Even with the current implementations, power savings and performance
>   impact widely vary based on system topology and workload.  There is
>   no easy method to define modes such that one mode will _always_
>   consume less power than the other
> * Each subsystem can override the policy settings and create more
>   combinations anyway
> 
> Your argument is that these modes can serve as a good default and allow
> the user to tune the knobs directly for more sophisticated policies.
> But in that case all kernel subsystem should default to the balanced
> policy and let the user tweak individual subsystems for other modes.
> 
> On the other hand having the policy definitions in user space allows
> us to create more flexible policies by considering higher level
> factors like workload behavior, utilization, platform features,
> power/thermal constraints etc.

The policy_preference levels as proposed are also really arbitrary and they
will usually mean different things on different systems.  If the interpretation
of these values is left to device drivers, then (for example) different network
adapter drivers may interpret "performance" differently and that will lead to
different types of behavior depending on which of them is used.  I think we
should rather use interfaces that unambiguously tell the driver what to do.

Thanks,
Rafael
