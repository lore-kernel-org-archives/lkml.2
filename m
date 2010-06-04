Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757274Ab0FDDip (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 23:38:45 -0400
Received: from vms173017pub.verizon.net ([206.46.173.17]:34327 "EHLO
	vms173017pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757204Ab0FDDio (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 23:38:44 -0400
Date: Thu, 03 Jun 2010 23:38:20 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Cc: Dave Jones <davej@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       H Peter Anvin <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@gmail.com>
Subject: RE: [patch 2/2] x86: Manage ENERGY_PERF_BIAS based on cpufreq governor
 - v2
In-reply-to: <7C53B33EE871F14797C999838AA8B5A914A8317F@orsmsx505.amr.corp.intel.com>
Message-id: <alpine.LFD.2.00.1006032329280.6669@localhost.localdomain>
References: <20100304231454.247805000@intel.com>
 <20100304231547.798303000@intel.com> <20100304232756.GA13895@redhat.com>
 <7C53B33EE871F14797C999838AA8B5A914A8317F@orsmsx505.amr.corp.intel.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >-----Original Message-----
> >From: Dave Jones [mailto:davej@redhat.com] 

> >On Thu, Mar 04, 2010 at 03:14:56PM -0800, Venki Pallipadi wrote:
> > 
> > > +	if (!strncmp(gov->name, "performance", strlen("performance")))
> > > +		epb_val = ENERGY_PERF_BIAS_PERF;
> > > +	else if (!strncmp(gov->name, "powersave", strlen("powersave")))
> > > +		epb_val = ENERGY_PERF_BIAS_POWER;
> > > +	else
> > > +		epb_val = ENERGY_PERF_BIAS_ONDEMAND;
> > > +
> > > +	set_epb_on_cpu(epb_val, cpu);
> > > +	return 0;
> >
> >hardcoding a list of cpufreq governors is kinda icky, but I don't have
> >a better solution.  We'll just have to be mindful of it if we ever
> >get around to finally making performance/powersave personalities
> >of ondemand as was discussed years ago.
> 
> Yes. In that case we will have to find some other way to tie this to
> user preference.

Lets cross that bridge when we come to it.

> >What if the governor is set to 'userspace' ?
> >powernowd/cpufreqd are sort of ondemand-done-in-userspace, but there
> >may also be other userspace governors we don't know about.
> >I suppose it's not catastrophic..
> 
> Userspace/ondemand/conservative can all be at middle ground here as
> they are mostly used where user expects adaptive kind of behaviour.

Frankly, if somebody cares about power or performance,
they shouldn't be running powernowd/cpufreqd, and so
they should be blissfully ignorant and satisfied with the
default, which is 'balanced'.

> I did think about exporting this as a new tunable in /sys and let
> userspace deal with it. But, that doesn't help with having sane default
> values and users (background apps) may shoot themselves in the foot
> with it.

We really do need a central place for userspace to communicate
power/performance bias policy to the kernel -- and for kernel drivers
of all types to pick up that policy.  I think that ideally
the sysfs interface should be generic, and that on systems with
this MSR, the MSR gets plugged into updates to that generic
interface.

I think that this driver exposing the MSR to cpufreq is useful,
but perhaps it is just a stepping stone to the generic I/F
that we really should implement...

Len Brown,
Intel Open Source Technology Center


