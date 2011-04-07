Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756423Ab1DGRO6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 13:14:58 -0400
Received: from mother.ludd.ltu.se ([130.240.16.3]:40834 "EHLO
	mother.ludd.ltu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756329Ab1DGRO4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 13:14:56 -0400
X-Greylist: delayed 2124 seconds by postgrey-1.27 at vger.kernel.org; Thu, 07 Apr 2011 13:14:56 EDT
Cc: mchehab@redhat.com, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-Id: <9DD52527-797E-4581-B879-A18F9084DC27@ludd.ltu.se>
From: Nils Carlson <nils.carlson@ludd.ltu.se>
To: Samuel Gabrielsson <samuel.gabrielsson@gmail.com>
In-Reply-To: <1301491283-14128-1-git-send-email-samuel.gabrielsson@gmail.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v936)
Subject: Re: [PATCH 1/2] i7core_edac: Add xeon 5600 generic non core registers
Date: Thu, 7 Apr 2011 18:39:18 +0200
References: <1301491283-14128-1-git-send-email-samuel.gabrielsson@gmail.com>
X-Mailer: Apple Mail (2.936)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mar 30, 2011, at 3:21 PM, Samuel Gabrielsson wrote:

> This enables writing to registers in device 0 function 0 such as
> MC_CFG_CONTROL. This also fixes a bug for intel xeon 5600 series
> when writing to inject_enable where we would get an Oops because
> pvt->pci_noncore was not set.
>
> Signed-off-by: Samuel Gabrielsson <samuel.gabrielsson@gmail.com>
Acked-by: Nils Carlson <nils.carlson@ludd.ltu.se>
> ---
> drivers/edac/i7core_edac.c |    3 +++
> 1 files changed, 3 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/edac/i7core_edac.c b/drivers/edac/i7core_edac.c
> index 81154ab..1db6092 100644
> --- a/drivers/edac/i7core_edac.c
> +++ b/drivers/edac/i7core_edac.c
> @@ -322,6 +322,9 @@ static const struct pci_id_descr  
> pci_dev_descr_lynnfield[] = {
> };
>
> static const struct pci_id_descr pci_dev_descr_i7core_westmere[] = {
> +		/* Generic Non-core registers */
> +	{ PCI_DESCR(0, 0, PCI_DEVICE_ID_INTEL_LYNNFIELD_NONCORE_REV2) },
> +
> 		/* Memory controller */
> 	{ PCI_DESCR(3, 0, PCI_DEVICE_ID_INTEL_LYNNFIELD_MCR_REV2)     },
> 	{ PCI_DESCR(3, 1, PCI_DEVICE_ID_INTEL_LYNNFIELD_MC_TAD_REV2)  },
> -- 
> 1.7.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux- 
> edac" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

