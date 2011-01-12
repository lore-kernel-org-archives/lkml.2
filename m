Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753020Ab1ALSfe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 13:35:34 -0500
Received: from vms173009pub.verizon.net ([206.46.173.9]:56437 "EHLO
	vms173009pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751404Ab1ALSf3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 13:35:29 -0500
Date: Wed, 12 Jan 2011 13:35:10 -0500 (EST)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@x980
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-acpi@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
        akpm <akpm@linux-foundation.org>, Zhang Rui <rui.zhang@intel.com>,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Zimny Lech <napohybelskurwysynom2010@gmail.com>
Subject: Re: on builds/randconfigs (was: [PATCH -next] thermal: depends on NET)
In-reply-to: <4D2DE97C.2000205@oracle.com>
Message-id: <alpine.LFD.2.02.1101121257580.18873@x980>
References: <20101213163607.0b0a7c3a.sfr@canb.auug.org.au>
 <20101213112033.d0060e6c.randy.dunlap@oracle.com>
 <20110110090059.6f4d739d.randy.dunlap@oracle.com>
 <alpine.LFD.2.02.1101120008590.19140@x980> <4D2DE97C.2000205@oracle.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > While I agree that randconfig build testing
> > is theoretically useful, in recent memory
> > its results do not seem particularly relevant
> > to useful configs.
> 
> Who defines useful?

Simple.

Configs that will be used are useful.

Phantom configs that will NEVER be used are NOT useful.

Phantom configs are HARMFUL, as they squander
finite testing and maintainer resources
that should be applied to code that is actually used.

Rather than celebrating our theoretical flexibility
with every new config option, we should recoil at the
fact that each one may up to double the number of
configs that need to be tested and supported.

When I'm answering your nagging e-mail about a build failure
in a phantom config that nobody would even conceive of using,
I'm not using that time to fix somebody's real problem
on a real machine.

I'd rather see you spend your time making select work
to delete an entire category of Kconfig failures,
or simply adding dependencies making phantom configs impossible.

eg. Look in drivers/acpi/Kconfig:

menuconfig ACPI
        bool "ACPI (Advanced Configuration and Power Interface) Support"
        depends on !IA64_HP_SIM
        depends on IA64 || X86
        depends on PCI
        depends on PM
        select PNP

Does all of ACPI technically depend on PCI?
Does all of ACPI technically depend on PM support?
Does all of ACPI technically depend on configuration and PNP?

Theoretically, no.

Do I care about the phantom configs that would be possible
if these false dependencies were not in place.  No,
not until somebody invents such a system,
and may be not even then.

Is there a user out there on LKML who can dream up
a use for one of these phantom configs and claim that
his life will end if he'd prevented from building it?
Sure.  Does he suffer from a total lack of perspective?
Yes.

-Len Brown, Intel Open Source Technology Center
