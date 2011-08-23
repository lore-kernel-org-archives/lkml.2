Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754709Ab1HWAuG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 20:50:06 -0400
Received: from tundra.namei.org ([65.99.196.166]:53762 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754686Ab1HWAuE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 20:50:04 -0400
Date: Tue, 23 Aug 2011 10:49:51 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Stefan Berger <stefanb@linux.vnet.ibm.com>
cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
        Marcel Selhorst <m.selhorst@sirrix.com>
Subject: Re: tpm: suppress durations sysfs output if not set
In-Reply-To: <4E523430.1070003@linux.vnet.ibm.com>
Message-ID: <alpine.LRH.2.00.1108231049170.25301@tundra.namei.org>
References: <4E523430.1070003@linux.vnet.ibm.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Aug 2011, Stefan Berger wrote:

> Suppress the output of durations if they were not read during driver
> initialization.
> This is similar to other sysfs entries that return nothing if for some reason
> sending the commands to the TPM fails.
> 

This patch appears to be tab-damaged.


> Signed-off-by: Stefan Berger <stefanb@linux.vnet.ibm.com>
> 
> ---
>  drivers/char/tpm/tpm.c |    3 +++
>  1 file changed, 3 insertions(+)
> 
> Index: linux-2.6/drivers/char/tpm/tpm.c
> ===================================================================
> --- linux-2.6.orig/drivers/char/tpm/tpm.c
> +++ linux-2.6/drivers/char/tpm/tpm.c
> @@ -963,6 +963,9 @@ ssize_t tpm_show_durations(struct device
>  {
>      struct tpm_chip *chip = dev_get_drvdata(dev);
> 
> +    if (chip->vendor.duration[TPM_LONG] == 0)
> +        return 0;
> +
>      return sprintf(buf, "%d %d %d [%s]\n",
>                 jiffies_to_usecs(chip->vendor.duration[TPM_SHORT]),
>                 jiffies_to_usecs(chip->vendor.duration[TPM_MEDIUM]),
> 

-- 
James Morris
<jmorris@namei.org>
