Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753956Ab2HCUih (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 16:38:37 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:43322 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753852Ab2HCUie (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 16:38:34 -0400
Date: Fri, 3 Aug 2012 15:38:36 -0500
From: Kent Yoder <key@linux.vnet.ibm.com>
To: Peter Huewe <peter.huewe@infineon.com>
Cc: James Morris <jmorris@namei.org>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        tpmdd-devel@lists.sourceforge.net, Bryan Freed <bfreed@chromium.org>,
        David Safford <safford@linux.vnet.ibm.com>, hpa@linux.intel.com
Subject: Re: [PATCH] char/tpm: Fix compile error if CONFIG_PM is not set in
 tpm_i2c_infineon
Message-ID: <20120803203836.GA11918@linux.vnet.ibm.com>
References: <alpine.LRH.2.02.1208031444100.25196@tundra.namei.org>
 <1344005476-8004-1-git-send-email-peter.huewe@infineon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344005476-8004-1-git-send-email-peter.huewe@infineon.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12080320-5806-0000-0000-000018010A76
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

On Fri, Aug 03, 2012 at 04:51:16PM +0200, Peter Huewe wrote:
> If CONFIG_PM was not set the compiler aborted with the following message:
> tpm_i2c_infineon.c:740:12: error: lvalue required as unary '&' operand
> 
> This patch fixes this error by not defining tpm_tis_i2c_ops as NULL if
> CONFIG_PM is not set, but only setting the suspend and resume function
> pointer as NULL

  Lets try to sync up with the work Rafael Wysocki is doing for PM.
Please take a look at these commits:

035e2ce8eb7412dbcb8522c19676a1dd52f3c024
8324be05380be044df8b70cb4bfb0c0b50eec3e5

Thanks,
Kent

> Signed-off-by: Peter Huewe <peter.huewe@infineon.com>
> ---
> Sorry for the inconvenience - now tested with and without CONFIG_PM. Sorry.
> 
>  drivers/char/tpm/tpm_i2c_infineon.c |    9 ++++-----
>  1 files changed, 4 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/char/tpm/tpm_i2c_infineon.c b/drivers/char/tpm/tpm_i2c_infineon.c
> index 1794a09..114e1a1 100644
> --- a/drivers/char/tpm/tpm_i2c_infineon.c
> +++ b/drivers/char/tpm/tpm_i2c_infineon.c
> @@ -674,16 +674,15 @@ static int tpm_tis_i2c_resume(struct device *dev)
>  {
>  	return tpm_pm_resume(dev);
>  }
> +#else
> +#define tpm_tis_i2c_suspend NULL
> +#define tpm_tis_i2c_resume NULL
> +#endif
> 
>  static const struct dev_pm_ops tpm_tis_i2c_ops = {
>  	.suspend = tpm_tis_i2c_suspend,
>  	.resume = tpm_tis_i2c_resume,
>  };
> -#else
> -#define tpm_tis_i2c_suspend NULL
> -#define tpm_tis_i2c_resume NULL
> -#define tpm_tis_i2c_ops NULL
> -#endif
> 
>  static int __devinit tpm_tis_i2c_probe(struct i2c_client *client,
>  			     const struct i2c_device_id *id)
> -- 
> 1.7.6.msysgit.0
> 

