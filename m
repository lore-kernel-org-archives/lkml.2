Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754439Ab2KVSiL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 13:38:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:17244 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754396Ab2KVSiI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:38:08 -0500
Date: Thu, 22 Nov 2012 09:08:13 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Arvind R <arvino55@gmail.com>
Cc: linux-edac@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3.6.6 0/3] i82975x_edac: fatal bug fixed
Message-ID: <20121122090813.603edd55@redhat.com>
In-Reply-To: <CAA_L+UPNOLg=ZuZofc-uhybXKuBO37XBSGa2vDLYZ7wLkgAb=A@mail.gmail.com>
References: <CAA_L+UPNOLg=ZuZofc-uhybXKuBO37XBSGa2vDLYZ7wLkgAb=A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arvind,

Em Thu, 22 Nov 2012 14:52:35 +0530
Arvind R <arvino55@gmail.com> escreveu:

> Subject: [PATCH 3.6.6 0/3] i82975x_edac: fatal bug fixed
> 
> This patchset fixes fatal crash caused by i82975x_edac driver.
> It consists of 3 parts:
> 1. Move the debug code to conform to the edac_core standard
>    instead of using hardcoded ifdefs. Also add some more dram
>    info outputs in the debug output.
> 2. Cleanup the long lines and other format errors found. Use
>    defines for numeric constants used repeatedly in code.
> 3. Fix the crash caused by wrong memory_layer initialisation
>    and dimm_label initialisation. Almost total, but cleaner
>    rewrite of csrow_info initialisation. And a terser error
>    reporting function.
> The patch has been applied to linux-3.6.6 and tested on
> on Asus P5WDG2 WS Pro mobo with 7 memory configurations,
> 3 symmetric and 4 assymmetric:
> Symmetric:
>  1. 2 ECC DIMMS, one on slot A1 and other on slot B1
>  2. 2 ECC DIMMS, one on slot A2 and other on slot B2
>  3. 4 ECC DIMMS, mobo fully populated.
> Assymmetric:
>  1. 1 ECC DIMM on A1
>  2. 1 ECC DIMM on B1
>  3. 2 ECC DIMMS on A1 and B2
>  4. 3 ECC DIMMS on A1, B2, B2
> Size, label values in /sys/devices/system/edac/mc/mc0 found
> consistent.

This patch series conflict with the one I did fixing the same issues:

http://git.kernel.org/?p=linux/kernel/git/mchehab/linux-edac.git;a=shortlog;h=refs/heads/linux_next

Could you please rebase it on the top of it?

Thanks,
Mauro

> 
> Tested-by: Arvind R. <arvino55@gmail.com>
> Signed-off-by: Arvind R. <arvino55@gmail.com>
> ---
>  drivers/edac/i82975x_edac.c |  361 +++++++++++++++++-----------------
>  1 file changed, 185 insertions(+), 176 deletions(-)


-- 
Regards,
Mauro
