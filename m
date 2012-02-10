Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759889Ab2BJSdF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 13:33:05 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:46038 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759874Ab2BJSdB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 13:33:01 -0500
Message-ID: <4F3562AC.5090701@linux.vnet.ibm.com>
Date: Fri, 10 Feb 2012 13:32:12 -0500
From: Stefan Berger <stefanb@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110928 Fedora/3.1.15-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.15
MIME-Version: 1.0
To: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
CC: linux-kernel@vger.kernel.org, Dan.Morav@nuvoton.com, KC@nuvoton.com,
        Dan Morav <dmorav@nuvoton.com>
Subject: Re: [PATCH 1/2] TPM: Nuvoton I2C driver
References: <y> <1328620014-9369-2-git-send-email-srajiv@linux.vnet.ibm.com>
In-Reply-To: <1328620014-9369-2-git-send-email-srajiv@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12021018-2398-0000-0000-0000041E24E3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/07/2012 08:06 AM, Rajiv Andrade wrote:
> From: Dan.Morav@nuvoton.com<Dan.Morav@nuvoton.com>
>
> Below are the additions for WPCT301/NPCT501 Nuvoton Technology
> TPM with I2C interface device driver. This driver uses Linux I2C
> bus driver to interface with the I2C bus and Linux TPM driver (tpm.ko),
> to export the standard Linux TPM interface. This driver requires an
> I2C bus driver and TPM driver (tpm.ko) to be loaded prior to its loading.
> This driver tested on Linux kernel version 3.3 on an x86 based platform.
>
> Signed-off-by: Dan Morav<dmorav@nuvoton.com>
> Signed-off-by: Rajiv Andrade<srajiv@linux.vnet.ibm.com>
[...]
> +
>   endif # TCG_TPM
> diff --git a/drivers/char/tpm/Makefile b/drivers/char/tpm/Makefile
> index ea3a1e0..064669a 100644
> --- a/drivers/char/tpm/Makefile
> +++ b/drivers/char/tpm/Makefile
> @@ -9,3 +9,4 @@ obj-$(CONFIG_TCG_TIS) += tpm_tis.o
>   obj-$(CONFIG_TCG_NSC) += tpm_nsc.o
>   obj-$(CONFIG_TCG_ATMEL) += tpm_atmel.o
>   obj-$(CONFIG_TCG_INFINEON) += tpm_infineon.o
> +obj-$(CONFIG_TCG_NUVOTON_I2C) += tpm_nuvoton_i2c.o
> diff --git a/drivers/char/tpm/tpm_nuvoton_i2c.c b/drivers/char/tpm/tpm_nuvoton_i2c.c
> new file mode 100644
> index 0000000..daf0d49
> --- /dev/null
> +++ b/drivers/char/tpm/tpm_nuvoton_i2c.c
> @@ -0,0 +1,718 @@
> +/******************************************************************************
> + * Nuvoton TPM I2C Device Driver Interface for WPCT301/NPCT501,
> + * based on the TCG TPM Interface Spec version 1.2.
> + * Specifications at www.trustedcomputinggroup.org

Since it's implemented following non-proprietary specs, would this 
driver qualify as the generic tpm_i2c driver or is there anything 
besides the device-id,vendor-id + firmware work-around in the driver 
specific to this particular device implementation.

Regards,
    Stefan

