Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756121Ab0E2Js7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 May 2010 05:48:59 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:53386 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754108Ab0E2Js5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 May 2010 05:48:57 -0400
Date: Sat, 29 May 2010 11:48:57 +0200
From: Borislav Petkov <bp@amd64.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>
Subject: Re: [PATCH] powernow-k8: Fix section mismatch
Message-ID: <20100529094857.GB24169@aftab>
References: <20100525152858.GA24836@aftab>
 <20100528140908.057f2348.akpm@linux-foundation.org>
 <20100529093119.GA24169@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100529093119.GA24169@aftab>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Einsteinring_24=2C_85609_Dornach_bei_M=FCnchen=2C_Gesc?=
	=?iso-8859-1?Q?h=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuliano_Meroni=2C?=
	=?iso-8859-1?Q?_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_Aschheim=2C_La?=
	=?iso-8859-1?Q?ndkreis_M=FCnchen=2C_Registergericht_M=FCnchen?=
	=?iso-8859-1?Q?=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@amd64.org>
Date: Sat, May 29, 2010 at 05:31:19AM -0400

> But I don't know, I might just as well be missing something else.

And yes, the hotcpu_notifier() thingy is for core code only. Using that
won't allow using powernow-k8 as a module and might cause some ugliness
at module exit time.

Besides, it also screams:

WARNING: vmlinux.o(.text+0x3ba8d): Section mismatch in reference from the function __cpu_notify() to the variable .cpuinit.data:cpu_chain
The function __cpu_notify() references
the variable __cpuinitdata cpu_chain.
This is often because __cpu_notify lacks a __cpuinitdata 
annotation or the annotation of cpu_chain is wrong.

Hmm...

-- 
Regards/Gruss,
Boris.

Operating Systems Research Center
Advanced Micro Devices, Inc.
