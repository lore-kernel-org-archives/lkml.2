Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934315Ab0EYWDS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 18:03:18 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:53836 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933004Ab0EYWDQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 18:03:16 -0400
Date: Wed, 26 May 2010 00:04:33 +0200
From: Borislav Petkov <bp@amd64.org>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: powernow-k8: section mismatch
Message-ID: <20100525220433.GB28552@aftab>
References: <tkrat.97946ecfb316e3af@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tkrat.97946ecfb316e3af@s5r6.in-berlin.de>
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

From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date: Tue, May 25, 2010 at 04:10:03PM -0400

> Hi,
> 
> I got the following with current git:
> 
>     WARNING: arch/x86/kernel/cpu/cpufreq/powernow-k8.o(.exit.text+0x1c): Section mismatch in reference from the function cleanup_module() to the variable .cpuinit.data:cpb_nb                      
>     The function __exit cleanup_module() references                                                 
>     a variable __cpuinitdata cpb_nb.                                                                
>     This is often seen when error handling in the exit function                                     
>     uses functionality in the init path.                                                            
>     The fix is often to remove the __cpuinitdata annotation of                                      
>     cpb_nb so it may be used outside an init section.                                               
> 
> Looks like it was introduced by
> "powernow-k8: Add core performance boost support".

Oh yeah, Peter pointed it out to me earlier, we have a fix already:
https://patchwork.kernel.org/patch/102225/

Thanks.

-- 
Regards/Gruss,
Boris.

Operating Systems Research Center
Advanced Micro Devices, Inc.
