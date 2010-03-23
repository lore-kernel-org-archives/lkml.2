Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752787Ab0CWL6h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 07:58:37 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:55255 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752252Ab0CWL6f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 07:58:35 -0400
Date: Tue, 23 Mar 2010 12:58:58 +0100
From: Borislav Petkov <bp@amd64.org>
To: Thomas Renninger <trenn@suse.de>
Cc: akpm@linux-foundation.org, davej@redhat.com, cpufreq@vger.kernel.org,
       x86@kernel.org, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 2/5] powernow-k8: Add core performance boost support
Message-ID: <20100323115858.GC16493@aftab>
References: <1269283121-11894-1-git-send-email-bp@amd64.org>
 <1269283121-11894-3-git-send-email-bp@amd64.org>
 <201003231217.16451.trenn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201003231217.16451.trenn@suse.de>
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

(Adding hpa to Cc)

From: Thomas Renninger <trenn@suse.de>
Date: Tue, Mar 23, 2010 at 12:17:16PM +0100

> > +/* core performance boost */
> > +static bool cpb_capable, cpb_disabled;
> Whatabout using a cpufeature (arch/x86/include/asm/cpufeature.h)
> instead of cpb_capable. Then people could see this feature in 
> /proc/cpuinfo and other code parts could check for it easily if
> needed later.

I don't have a problem with that per se. It's just that /proc/cpuinfo
is a widely used interface and, AFAIR, changing it is not taken that
lightly.

Peter, what do you think?

> It could already be set in arch/x86/kernel/cpu/amd.c and
> powernow-k8 could use cpu_has(cpu, X86_FEATURE_CPB);

I'd still like to cache the cpb_capable value locally instead of getting
x86_cpuinfo percpu var and querying it. Especially if this happens often
and not only at driver init.

> Instead of cpb_disabled, I'd use cpb_enabled. Checking for
> !cpb_disabled whether it's enabled, is ugly to read.

Fair enough, cpb_disabled reflects the bit semantics in the MSR but why
not, don't matter which to me.

[..]

> > +		_cpb_toggle_msrs(t);
> > +		printk(KERN_INFO PFX "Core Boosting enabled.\n");
> Always printk on every toggle?
> That should not happen often and a user might want to get noticed if
> an app does this behind his back -> should be fine w/ or w/o, just not 
> sure whether it's intended.

Well, actually, this should be on by default and the user or an app
shouldn't be fidgeting with it all the time. It's there only for
benchmarking purposes so that you can disable it when you really have
to. But I guess it actually is going to get used if its there so maybe
we should have to rethink our approach. Hmm...

-- 
Regards/Gruss,
Boris.

--
Advanced Micro Devices, Inc.
Operating Systems Research Center
