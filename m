Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422778Ab2JXWIU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 18:08:20 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:35716 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422655Ab2JXWIR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 18:08:17 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Yuanhan Liu <yuanhan.liu@linux.intel.com>
Cc: lenb@kernel.org, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        fengguang.wu@intel.com
Subject: Re: [PATCH v2] ACPI: move acpi_no_s4_hw_signature() declaration into #ifdef CONFIG_HIBERNATION
Date: Thu, 25 Oct 2012 00:12:14 +0200
Message-ID: <3347827.kTploBzWyH@vostro.rjw.lan>
User-Agent: KMail/4.8.5 (Linux/3.6.2-6-desktop; KDE/4.8.5; x86_64; ; )
In-Reply-To: <1350365052-27304-1-git-send-email-yuanhan.liu@linux.intel.com>
References: <1350365052-27304-1-git-send-email-yuanhan.liu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 16 of October 2012 13:24:12 Yuanhan Liu wrote:
> acpi_no_s4_hw_signature is defined in #ifdef CONFIG_HIBERNATION block,
> but the current code put the declaration in #ifdef CONFIG_PM_SLEEP block.
> 
> I happened to meet this issue when I turned off PM_SLEEP config manually:
> arch/x86/kernel/acpi/sleep.c:100:4: error: implicit declaration of function ‘acpi_no_s4_hw_signature’ [-Werror=implicit-function-declaration]
> 
> v2: take better title and add build error message suggested by Fengguang
> 
> Signed-off-by: Yuanhan Liu <yuanhan.liu@linux.intel.com>
> Reviewed-by: Fengguang Wu <fengguang.wu@intel.com>

Applied to linux-pm.git/acpi-next as v3.8 material.

Thanks,
Rafael


> ---
>  include/linux/acpi.h |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/acpi.h b/include/linux/acpi.h
> index 90be989..a468429 100644
> --- a/include/linux/acpi.h
> +++ b/include/linux/acpi.h
> @@ -257,8 +257,11 @@ int acpi_check_region(resource_size_t start, resource_size_t n,
>  
>  int acpi_resources_are_enforced(void);
>  
> -#ifdef CONFIG_PM_SLEEP
> +#ifdef CONFIG_HIBERNATION
>  void __init acpi_no_s4_hw_signature(void);
> +#endif
> +
> +#ifdef CONFIG_PM_SLEEP
>  void __init acpi_old_suspend_ordering(void);
>  void __init acpi_nvs_nosave(void);
>  #endif /* CONFIG_PM_SLEEP */
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
