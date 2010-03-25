Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752572Ab0CYWQN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 18:16:13 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:38562 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751481Ab0CYWQK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 18:16:10 -0400
Date: Thu, 25 Mar 2010 23:16:38 +0100
From: Borislav Petkov <bp@amd64.org>
To: Thomas Renninger <trenn@suse.de>
Cc: Valdis.Kletnieks@vt.edu, akpm@linux-foundation.org, davej@redhat.com,
       linux@dominikbrodowski.net, mingo@elte.hu, hpa@zytor.com,
       tglx@linutronix.de, cpufreq@vger.kernel.org, x86@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] cpufreq: Add APERF/MPERF support for AMD processors
Message-ID: <20100325221638.GA19269@aftab>
References: <1269452783-966-1-git-send-email-bp@amd64.org>
 <201003251043.04867.trenn@suse.de>
 <13218.1269546919@localhost>
 <201003252159.31883.trenn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201003252159.31883.trenn@suse.de>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_A?=
	=?iso-8859-1?Q?schheim=2C_Landkreis_M=FCnchen=2C_Registergericht_M=FCnche?=
	=?iso-8859-1?Q?n=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Renninger <trenn@suse.de>
Date: Thu, Mar 25, 2010 at 09:59:31PM +0100

> On Thursday 25 March 2010 08:55:19 pm Valdis.Kletnieks@vt.edu wrote:
> > On Thu, 25 Mar 2010 10:43:04 BST, Thomas Renninger said:
> > > > +	if (c->cpuid_level >= 6) {
> > >
> > > and remove this (arch/x86/kernel/cpu/intel.c):
> > >         if (c->cpuid_level > 6) {
> >
> > So is > or >= the correct comparator here?
> 
> This one: >= is correct (for both).
> I double checked, there is one Intel CPU type
> having a cpuid_level of 6, but this would not support aperf/mperf, thus
> above is still fine.

Agreed. ">" won't work on machines which have base cpuidlevel == 6 (like
AMD, f.e.)

> The remaining question is what Borislav said:
> are there other x86 CPU vendors who could use this differently.
> I very much expect there are not.
> 
> IMO you should resubmit this one or the whole series with this change

Ok, will do tomorrow.

> and Dave should just push this in his tree and queue it up, there was enough
> time to object.

The problem here is that the patches touch both cpufreq and x86 code.
Hmmm...

-- 
Regards/Gruss,
Boris.

--
Advanced Micro Devices, Inc.
Operating Systems Research Center
