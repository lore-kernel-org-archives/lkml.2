Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756681Ab0DAN7k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 09:59:40 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:36470 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756643Ab0DAN7e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 09:59:34 -0400
Date: Thu, 1 Apr 2010 16:00:16 +0200
From: Borislav Petkov <bp@amd64.org>
To: Marvin <marvin24@gmx.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/6] cpufreq: Add APERF/MPERF support for AMD processors
Message-ID: <20100401140015.GC5893@aftab>
References: <1270065406-1814-1-git-send-email-bp@amd64.org>
 <201004011101.04420.marvin24@gmx.de>
 <20100401103659.GB5893@aftab>
 <201004011346.10860.marvin24@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201004011346.10860.marvin24@gmx.de>
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

From: Marvin <marvin24@gmx.de>
Date: Thu, Apr 01, 2010 at 01:46:10PM +0200

Yep, I could reproduce it, thanks for reporting.

> I think compiling powernow_k8 as a module is sufficient.

Almost, you need acpi-cpufreq (CONFIG_X86_ACPI_CPUFREQ) also as module
so that mperf.ko gets compiled as a module too since its being shared
between the two. Otherwise it is statically linked into whichever of the
two (apci-cpufreq or powernow-k8) are built-in.

Fix follows.

-- 
Regards/Gruss,
Boris.

--
Advanced Micro Devices, Inc.
Operating Systems Research Center
