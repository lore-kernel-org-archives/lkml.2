Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756551Ab1ALWZ2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 17:25:28 -0500
Received: from vms173009pub.verizon.net ([206.46.173.9]:38435 "EHLO
	vms173009pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753686Ab1ALWZZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 17:25:25 -0500
Date: Wed, 12 Jan 2011 17:25:12 -0500 (EST)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@x980
To: Thomas Renninger <trenn@suse.de>
Cc: linux-perf-users@vger.kernel.org, mingo@elte.hu, arjan@linux.intel.com,
        j-pihet@ti.com, linux-acpi@vger.kernel.org,
        linux-pm@lists.linux-foundation.org,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org
Subject: Re: [PATCH 4/9] cpuidle: Introduce .abbr (abbrevation) for cpuidle
 states
In-reply-to: <201101121437.51122.trenn@suse.de>
Message-id: <alpine.LFD.2.02.1101121705130.19754@x980>
References: <1294396190-23031-1-git-send-email-trenn@suse.de>
 <1294396190-23031-5-git-send-email-trenn@suse.de>
 <alpine.LFD.2.02.1101120150570.19140@x980> <201101121437.51122.trenn@suse.de>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > If the display tools can only handle 3 characters,
> > then why not have them simply use the 1st 3 characters
> > of the existing name field?

> You mean use:
> C3 NHM
> instead of
> NHM-C3
> for intel_idle?

Yes.
is there a reason that would be a problem?

If only 3 characters are useful,
then I'd rather see you simly do this:

#define CPUIDLE_NAME_LEN 3

> Then userspace has to parse the two informations glued
> together, get rid of the whitespace, etc.

what "two informations"?
why is kernel bloat the instrument of choice
to avoid the expense of string truncation
in user-space tools?

> But by sysfs convention a separate file must be used
> if two data are passed to userspace which is the case here.

what two data?

It is fine for a string to include space characters.

> > If that is not unique,
> > then re-arrange the strings so that it is unique...

> See above, it would unnecessarily make life hard for
> userspace.
> Afaik sysfs entries do not consume resources as long as
> they do not get accessed.

they clutter the source code,
they create  an additional name for something
that arguably already has 3 names --
the state #, the name, and the description.
I'd rather delete a few of the fields than add a 4th...

> >Of course the ACPI part of this patch will not apply,
> > as it depends on patch 1 in this series, which was erroneous.
> > For ACPI, the existing name field is already fine,
> > as C%d fits into 3 characters.

> For acpi_idle only it would work, but this is (nearly) the only
> one.
> For example for sh arch:
> name: SuperH
> "SH SuperH" contains two data and should get split up into:
> name: SuperH
> abbr: SH

acpi/arch/sh/kernel/cpu/shmobile/cpuidle.c
already uses state->name = "C0", "C1", "C2".

Just use them and be done.

> By convention the first characters of "description" could be
> used, but you would again end up in userspace parsing and
> double info in one sysfs file.
> 
> I hope that's enough for convincing, I'd really like to go
> the .abbr way. Do you give me an acked-by for that one?

No.

We should not invent an additional abbreviation field.
The tools should use the existing name field.
If the existing name field is not sufficient, then
the states should simply be enumerated and numbers
be shown in the GUI.

thanks,
Len Brown, Intel Open Source Technology Center



