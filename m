Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755634Ab0DALq2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 07:46:28 -0400
Received: from merkurneu.hrz.uni-giessen.de ([134.176.2.3]:62229 "EHLO
	merkurneu.hrz.uni-giessen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755520Ab0DALqW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 07:46:22 -0400
From: Marvin <marvin24@gmx.de>
To: Borislav Petkov <bp@amd64.org>
Subject: Re: [PATCH 4/6] cpufreq: Add APERF/MPERF support for AMD processors
Date: Thu, 1 Apr 2010 13:46:10 +0200
User-Agent: KMail/1.13.2 (Linux/2.6.34-rc3; KDE/4.4.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <1270065406-1814-1-git-send-email-bp@amd64.org> <201004011101.04420.marvin24@gmx.de> <20100401103659.GB5893@aftab>
In-Reply-To: <20100401103659.GB5893@aftab>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201004011346.10860.marvin24@gmx.de>
X-HRZ-JLUG-MailScanner-Information: Passed JLUG virus check
X-HRZ-JLUG-MailScanner: No virus found
X-Envelope-From: marvin24@gmx.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> From: Marvin <marvin24@gmx.de>
> Date: Thu, Apr 01, 2010 at 11:01:04AM +0200
> 
> > > From: Mark Langsdorf <mark.langsdorf@amd.com>
> > > 
> > > Starting with model 10 of Family 0x10, AMD processors may have
> > > support for APERF/MPERF.  Add support for identifying it and using
> > > it within cpufreq.  Move the APERF/MPERF functions out of the
> > > acpi-cpufreq code and into their own file so they can easily be
> > > shared.
> > 
> > just out of interest: what are the realnames of these processors (>=
> > Mangy-Core) ?
> 
> Well, you're going to have to wait and see. Or search the net :)

ok - I take this as "not yet".

> 
> > > Signed-off-by: Mark Langsdorf <mark.langsdorf@amd.com>
> > > Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
> > > Reviewed-by: Thomas Renninger <trenn@suse.de>
> > > ---
> > > 
> > >  arch/x86/kernel/cpu/cpufreq/Makefile       |    4 +-
> > >  arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c |   44
> > >  +----------------------- arch/x86/kernel/cpu/cpufreq/mperf.c        |
> > >    50
> > > 
> > > ++++++++++++++++++++++++++++ arch/x86/kernel/cpu/cpufreq/mperf.h       
> > > |
> > > 
> > >   9 +++++
> > >  
> > >  arch/x86/kernel/cpu/cpufreq/powernow-k8.c  |    8 ++++
> > >  5 files changed, 71 insertions(+), 44 deletions(-)
> > >  create mode 100644 arch/x86/kernel/cpu/cpufreq/mperf.c
> > 
> > this file has no copyright or module license, thus tainting my kernel...
> 
> This is not a standalone module but only an auxiliary. How does that
> taint your kernel? dmesg, .config please.

I think compiling powernow_k8 as a module is sufficient. 

# lsmod | grep powernow
powernow_k8            16595  1 
mperf                   1379  1 powernow_k8
processor              39129  1 powernow_k8

# dmesg | grep -B5 powernow
[   11.676876] ip6_tables: (C) 2000-2006 Netfilter Core Team
[   12.005031] ip_tables: (C) 2000-2006 Netfilter Core Team
[   12.051995] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[   12.096556] mperf: module license 'unspecified' taints kernel.
[   12.097906] Disabling lock debugging due to kernel taint
[   12.117403] powernow-k8: Found 1 AMD Phenom(tm) II X4 B55 Processor (4 cpu cores) 
(version 2.20.00)
[   12.118714] powernow-k8:    0 : pstate 0 (3200 MHz)
[   12.120063] powernow-k8:    1 : pstate 1 (2500 MHz)
[   12.121389] powernow-k8:    2 : pstate 2 (2100 MHz)
[   12.122713] powernow-k8:    3 : pstate 3 (800 MHz)

Marvin
