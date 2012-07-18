Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755845Ab2GRTpP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 15:45:15 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:46795 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753290Ab2GRTpM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 15:45:12 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Borislav Petkov <bp@amd64.org>
Subject: Re: [PATCH] powernow-k8: Fixup missing _PSS objects message
Date: Wed, 18 Jul 2012 21:50:51 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0-rc5+; KDE/4.6.0; x86_64; ; )
Cc: cpufreq@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
References: <1342624043-29763-1-git-send-email-bp@amd64.org>
In-Reply-To: <1342624043-29763-1-git-send-email-bp@amd64.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201207182150.51441.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, July 18, 2012, Borislav Petkov wrote:
> From: Borislav Petkov <borislav.petkov@amd.com>
> 
> _PSS objects can also be missing if Cool'N'Quiet is disabled in the
> BIOS. Add that to the FW_BUG message for the user to try before updating
> her BIOS. Fix formatting while at it.
> 
> Acked-by: Mark Langsdorf <mark.langsdorf@amd.com>
> Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>

I will take this, but it's kind of too late for v3.6.

Thanks,
Rafael


> ---
>  drivers/cpufreq/powernow-k8.c | 11 +++++++----
>  1 file changed, 7 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/cpufreq/powernow-k8.c b/drivers/cpufreq/powernow-k8.c
> index c0e816468e30..33f17c4a1342 100644
> --- a/drivers/cpufreq/powernow-k8.c
> +++ b/drivers/cpufreq/powernow-k8.c
> @@ -1265,12 +1265,15 @@ static void __cpuinit powernowk8_cpu_init_on_cpu(void *_init_on_cpu)
>  	init_on_cpu->rc = 0;
>  }
>  
> +static const char missing_pss_msg[] =
> +	KERN_ERR
> +	FW_BUG PFX "No compatible ACPI _PSS objects found.\n"
> +	FW_BUG PFX "First, make sure Cool'N'Quiet is enabled in the BIOS.\n"
> +	FW_BUG PFX "If that doesn't help, try upgrading your BIOS.\n";
> +
>  /* per CPU init entry point to the driver */
>  static int __cpuinit powernowk8_cpu_init(struct cpufreq_policy *pol)
>  {
> -	static const char ACPI_PSS_BIOS_BUG_MSG[] =
> -		KERN_ERR FW_BUG PFX "No compatible ACPI _PSS objects found.\n"
> -		FW_BUG PFX "Try again with latest BIOS.\n";
>  	struct powernow_k8_data *data;
>  	struct init_on_cpu init_on_cpu;
>  	int rc;
> @@ -1298,7 +1301,7 @@ static int __cpuinit powernowk8_cpu_init(struct cpufreq_policy *pol)
>  		 * an UP version, and is deprecated by AMD.
>  		 */
>  		if (num_online_cpus() != 1) {
> -			printk_once(ACPI_PSS_BIOS_BUG_MSG);
> +			printk_once(missing_pss_msg);
>  			goto err_out;
>  		}
>  		if (pol->cpu != 0) {
> 

