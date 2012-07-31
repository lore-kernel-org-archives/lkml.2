Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754675Ab2GaJVG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 05:21:06 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:36062 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753999Ab2GaJVD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 05:21:03 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Feng Tang <feng.tang@intel.com>
Subject: Re: [PATCH v2] ACPI processor: Fix a typo error in commit 99b725084
Date: Tue, 31 Jul 2012 11:26:53 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0+; KDE/4.6.0; x86_64; ; )
Cc: len.brown@intel.com, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com,
        Thomas Renninger <trenn@suse.de>,
        Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
References: <1343709883-16801-1-git-send-email-feng.tang@intel.com>
In-Reply-To: <1343709883-16801-1-git-send-email-feng.tang@intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201207311126.53468.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, July 31, 2012, Feng Tang wrote:
> In commit 99b725084 "ACPI processor hotplug: Delay acpi_processor_start()
> call for hotplugged cores", acpi_processor_hotplug(pr) was wrongly replaced
> by acpi_processor_cst_has_changed() inside the acpi_cpu_soft_notify(). This
> patch will restore it back, which also fixes a tick_broadcast_mask regression:
> 	https://lkml.org/lkml/2012/7/30/169
> 
> [Resend to ACPI mail list and Cc stable kernel]
> 
> Signed-off-by: Feng Tang <feng.tang@intel.com>
> Cc: Thomas Renninger <trenn@suse.de>
> Cc: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
> Cc: <stable@vger.kernel.org> # 3.3+

Reviewed-by: Rafael J. Wysocki <rjw@sisk.pl>

> ---
>  drivers/acpi/processor_driver.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/acpi/processor_driver.c b/drivers/acpi/processor_driver.c
> index ff8e04f..bfc31cb 100644
> --- a/drivers/acpi/processor_driver.c
> +++ b/drivers/acpi/processor_driver.c
> @@ -437,7 +437,7 @@ static int acpi_cpu_soft_notify(struct notifier_block *nfb,
>  		/* Normal CPU soft online event */
>  		} else {
>  			acpi_processor_ppc_has_changed(pr, 0);
> -			acpi_processor_cst_has_changed(pr);
> +			acpi_processor_hotplug(pr);
>  			acpi_processor_reevaluate_tstate(pr, action);
>  			acpi_processor_tstate_has_changed(pr);
>  		}
> 

