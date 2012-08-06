Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932528Ab2HFTaj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 15:30:39 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:53073 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932494Ab2HFTah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 15:30:37 -0400
Date: Mon, 6 Aug 2012 14:29:57 -0500
From: Kent Yoder <key@linux.vnet.ibm.com>
To: Peter Huewe <peter.huewe@infineon.com>
Cc: jmorris@namei.org, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        tpmdd-devel@lists.sourceforge.net, Bryan Freed <bfreed@chromium.org>,
        David Safford <safford@linux.vnet.ibm.com>, hpa@linux.intel.com
Subject: Re: [PATCH] char/tpm: Use struct dev_pm_ops for power management.
Message-ID: <20120806192957.GB6821@linux.vnet.ibm.com>
References: <20120803203836.GA11918@linux.vnet.ibm.com>
 <1344239939-5752-1-git-send-email-peter.huewe@infineon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344239939-5752-1-git-send-email-peter.huewe@infineon.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12080619-7606-0000-0000-000002974810
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 06, 2012 at 09:58:59AM +0200, Peter Huewe wrote:
> Make the tpm_i2c_infineon driver define its PM callbacks trough a
> struct dev_pm_ops by using SIMPLE_DEV_PM_OPS instead of coding it
> explicitly.
> 
> This simplifies the code and allows the driver to use tpm_pm_suspend()
> and tpm_pm_resume() as its PM callbacks directly, without defining its
> own PM callback routines.

  Thanks Peter. One more request - can you roll this fix into the driver
patch itself and just add a note in the change log?  Sorry I didn't
mention this before.

Thanks,
Kent

> Signed-off-by: Peter Huewe <peter.huewe@infineon.com>
> ---
> Thanks Kent and Rafael - much better this way ;)
> 
>  drivers/char/tpm/tpm_i2c_infineon.c |   30 +-----------------------------
>  1 files changed, 1 insertions(+), 29 deletions(-)
> 
> diff --git a/drivers/char/tpm/tpm_i2c_infineon.c b/drivers/char/tpm/tpm_i2c_infineon.c
> index 1794a09..65761b6 100644
> --- a/drivers/char/tpm/tpm_i2c_infineon.c
> +++ b/drivers/char/tpm/tpm_i2c_infineon.c
> @@ -655,35 +655,7 @@ static const struct i2c_device_id tpm_tis_i2c_table[] = {
>  };
> 
>  MODULE_DEVICE_TABLE(i2c, tpm_tis_i2c_table);
> -
> -#ifdef CONFIG_PM
> -/* NOTE:
> - * Suspend does currently not work Nvidias Tegra2 Platform
> - * but works fine on Beagleboard (arm omap).
> - *
> - * This function will block System Suspend if TPM is not initialized,
> - * however the TPM is usually initialized by BIOS/u-boot or by sending
> - * a TPM_Startup command.
> - */
> -static int tpm_tis_i2c_suspend(struct device *dev)
> -{
> -	return tpm_pm_suspend(dev, dev->power.power_state);
> -}
> -
> -static int tpm_tis_i2c_resume(struct device *dev)
> -{
> -	return tpm_pm_resume(dev);
> -}
> -
> -static const struct dev_pm_ops tpm_tis_i2c_ops = {
> -	.suspend = tpm_tis_i2c_suspend,
> -	.resume = tpm_tis_i2c_resume,
> -};
> -#else
> -#define tpm_tis_i2c_suspend NULL
> -#define tpm_tis_i2c_resume NULL
> -#define tpm_tis_i2c_ops NULL
> -#endif
> +static SIMPLE_DEV_PM_OPS(tpm_tis_i2c_ops, tpm_pm_suspend, tpm_pm_resume);
> 
>  static int __devinit tpm_tis_i2c_probe(struct i2c_client *client,
>  			     const struct i2c_device_id *id)
> -- 
> 1.7.6.msysgit.0
> 

