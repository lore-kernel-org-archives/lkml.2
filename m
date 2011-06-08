Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754649Ab1FHKUO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 06:20:14 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:59565 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753866Ab1FHKUN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 06:20:13 -0400
Date: Wed, 8 Jun 2011 12:19:57 +0200
From: Borislav Petkov <bp@amd64.org>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Borislav Petkov <bp@amd64.org>, Tony Luck <tony.luck@gmail.com>
Subject: Re: [PATCH 00/12] x86: minor cleanups/fixes for MCE codes (v2)
Message-ID: <20110608101957.GA11337@aftab>
References: <4DEED509.1040504@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DEED509.1040504@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 07, 2011 at 09:48:57PM -0400, Hidetoshi Seto wrote:
> This is a set of minor changes for MCE codes.
> 
> Though I know there are many people expecting new RAS architecture
> such as one that integrates RAS/EDAC with MCE, I hope these small
> steps will be a help for future works.
> 
> v2:
>  reflect comments, update patch 3,4,5,7,10,12.
>  rebased on 3.0-rc2.
> 
> Thanks,
> H.Seto
> 
>  arch/x86/include/asm/entry_arch.h         |    4 -
>  arch/x86/include/asm/hw_irq.h             |    1 -
>  arch/x86/include/asm/irq_vectors.h        |    5 -
>  arch/x86/include/asm/mce.h                |   19 ++-
>  arch/x86/kernel/cpu/mcheck/mce-severity.c |  152 ++++++++++------
>  arch/x86/kernel/cpu/mcheck/mce.c          |  288 ++++++++++++++---------------
>  arch/x86/kernel/cpu/mcheck/mce_amd.c      |   10 +-
>  arch/x86/kernel/entry_64.S                |    5 -
>  arch/x86/kernel/irqinit.c                 |    3 -
>  9 files changed, 251 insertions(+), 236 deletions(-)
> 
> Hidetoshi Seto (11):
>       mce-severity: cleanup severity table, prep
>       mce-severity: cleanup severity table
>       mce-severity: trivial cleanups
>       x86, mce: replace MCE_SELF_VECTOR by irq_work
>       x86, mce: replace MCM_ to MCI_MISC_
>       x86, mce: introduce mce_gather_info()
>       x86, mce: check the result of ancient_init()
>       x86, mce: cleanup mce_create/remove_device
>       x86, mce: cleanup mce_read
>       x86, mce: use prefix mce_chrdev_ to group functions
>       x86, mce: use prefix mce_sysdev_ to group functions
> 
> Tony Luck (1):
>       mce-severity: fixes for mce severity table

Well, I can't say I'm crazy about the severities mechanism but I guess
this is fine for a cleanup patchset. Btw, the problem of making the
severities readable will come up again when we implement this into perf
filters and the complexity will be moved into the filter function...

Other than that,

Reviewed-by: Borislav Petkov <bp@amd64.org>

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
