Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756086Ab0DWGue (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 02:50:34 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:53545 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756021Ab0DWGud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 02:50:33 -0400
Date: Fri, 23 Apr 2010 08:50:16 +0200
From: Borislav Petkov <bp@amd64.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: mingo@elte.hu, tglx@linutronix.de, x86@kernel.org,
       linux-kernel@vger.kernel.org, Frank Arnold <frank.arnold@amd.com>
Subject: Re: [PATCH -v2 0/5] AMD L3 cache index disable fixes for .35
Message-ID: <20100423065016.GA11748@aftab>
References: <1271945222-5283-1-git-send-email-bp@amd64.org>
 <4BD0E869.10402@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BD0E869.10402@zytor.com>
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

From: "H. Peter Anvin" <hpa@zytor.com>
Date: Thu, Apr 22, 2010 at 05:23:05PM -0700

> Hi Borislav,
> 
> I get compilation failures on tip:x86/cpu with this patchset:
> 
> arch/x86/built-in.o: In function `amd_check_l3_disable':
> intel_cacheinfo.c:(.cpuinit.text+0x412): undefined reference to
> `num_k8_northbridges'
> 
> Both i386 and x86-64 "make allnoconfig".

Yeah, this has bitten us already several times in the past. allnoconfig
deselects CONFIG_PCI and num_k8_northbridges is under CONFIG_K8_NB which
depends on CONFIG_PCI so there you go.

I'm thinking the k8.c facility is needed more and more for all the
processor functionality control over the PCI config space so how about
compile it in unconditionally on AMD? All the k8's and F10h's need
it and the older ones will have it there but it won't hurt since the
pci_get_device() won't match any on those.

allnoconfig build failure is fixed this way, albeit non-functional since
CONFIG_PCI is off and pci_get_device() returns NULL but in that case
almost all of the functionality (I guess raw PCI access would still
work) depending on AMD northbridge PCI devices won't work anyway.

I'll prep something in a while.

-- 
Regards/Gruss,
Boris.

--
Advanced Micro Devices, Inc.
Operating Systems Research Center
