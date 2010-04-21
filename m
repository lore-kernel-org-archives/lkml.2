Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756541Ab0DUUoA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 16:44:00 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:57757 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754923Ab0DUUn6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 16:43:58 -0400
Date: Wed, 21 Apr 2010 22:43:54 +0200
From: Borislav Petkov <bp@amd64.org>
To: hpa@zytor.com
Cc: mingo@elte.hu, tglx@linutronix.de, x86@kernel.org,
       linux-kernel@vger.kernel.org, Frank Arnold <frank.arnold@amd.com>
Subject: Re: [PATCH 0/5] AMD L3 cache index disable fixes for .35
Message-ID: <20100421204354.GA30770@aftab>
References: <1271349663-16670-1-git-send-email-bp@amd64.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1271349663-16670-1-git-send-email-bp@amd64.org>
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

From: Borislav Petkov <bp@amd64.org>
Date: Thu, Apr 15, 2010 at 06:40:58PM +0200

Ping.

It would be cool if we could sort out objections soon (in case there are
any, of course) so that the patches can have some -tip time before the
.35 merge window.

Thanks.

> From: Borislav Petkov <borislav.petkov@amd.com>
> 
> Hi,
> 
> this is a small patchset of fixes for L3 CID which have accumulated over
> the last couple of weeks. They serve as a preparation for disabling L3
> cache indices whenever an L3 MCE triggers, has been evaluated and the
> offending index thresholded and, if error rate is excessively high,
> disabled. Those patches will be coming up later though.
> 
> Patches 1,3,4 are cleanups and unifications which save us a little bit
> of percpu memory in favor of dynamic allocation. Also, we have an L3
> cache descriptor per node now instead of having this information per
> CPU.
> 
> I triggered a lockdep warning in lockdep_trace_alloc() during testing
> due to the fact that we may run with disabled interrupts that early
> in the boot process. Therefore, I have a GFP_ATOMIC in patch 3 there
> allocating the cache descriptors. I'm open for suggestions in case this
> is undesired.
> 
> Patch 2 is a fix which triggers when we run as a guest on Xen due to Xen
> not exporting CPU PCI config space to the guests.
> 
> And finally #5 is a required fix.
> 
> The patchset is also available at
> git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git l3-for-35
> 
> Please queue for .35,
> thanks.
> 

-- 
Regards/Gruss,
Boris.

--
Advanced Micro Devices, Inc.
Operating Systems Research Center
