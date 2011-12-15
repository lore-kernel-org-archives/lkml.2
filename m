Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932656Ab1LOQrc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 11:47:32 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38538 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932640Ab1LOQra (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 11:47:30 -0500
From: Thomas Renninger <trenn@suse.de>
Organization: SUSE Products GmbH
To: Masanari Iida <standby24x7@gmail.com>
Subject: Re: [PATCH] ACPI: kernel-parameters.txt : Add intel_idle.max_cstate
Date: Thu, 15 Dec 2011 17:47:28 +0100
User-Agent: KMail/1.13.6 (Linux/2.6.37.6-0.7-desktop; KDE/4.6.0; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        rdunlap@xenotime.net, lenb@kernel.org
References: <1323879532-10490-1-git-send-email-standby24x7@gmail.com>
In-Reply-To: <1323879532-10490-1-git-send-email-standby24x7@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: 7bit
Message-Id: <201112151747.28366.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, December 14, 2011 05:18:52 PM Masanari Iida wrote:
> Add missing intel_idle.max_cstate in kernel-parameters.txt
I wonder whether this one should get documented at all.

Better would be to work towards a general cpuidle.max_state=
param which deprecates processor.max_cstate= (acpi_idle driver) and
intel_idle.max_cstate= and enables this functionality for all
other cpuidle drivers out there as well.

Something to turn off intel_idle driver and favor the acpi_idle
driver for debugging would still be needed then.

   Thomas

> 
> Signed-off-by Masanari Iida <standby24x7@gmail.com>
> cc:Len Brown <lenb@kernel.org>
> cc:Randy Dunlap <rdunlap@xenotime.net>
> ---
>  Documentation/kernel-parameters.txt |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-
parameters.txt
> index 81c287f..c6a56d8 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -1035,6 +1035,11 @@ bytes respectively. Such letter suffixes can also 
be entirely omitted.
>  			By default, super page will be supported if Intel IOMMU
>  			has the capability. With this option, super page will
>  			not be supported.
> +
> +	intel_idle.max_cstate=	[KNL,HW,ACPI,X86]
> +			0	disables intel_idle and fall back on acpi_idle.
> +			1 to 6	specify maximum depth of C-state.
> +
>  	intremap=	[X86-64, Intel-IOMMU]
>  			on	enable Interrupt Remapping (default)
>  			off	disable Interrupt Remapping
> -- 
> 1.7.6.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

