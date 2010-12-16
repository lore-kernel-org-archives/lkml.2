Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756814Ab0LPUf0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 15:35:26 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:8032 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756186Ab0LPUfW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 15:35:22 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Thu, 16 Dec 2010 12:28:04 -0800
From: Stephen Warren <swarren@nvidia.com>
To: "sameo@linux.intel.com" <sameo@linux.intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "achew@nvidai.com" <achew@nvidai.com>,
        "olofj@chromium.org" <olofj@chromium.org>
Date: Thu, 16 Dec 2010 12:35:17 -0800
Subject: RE: [PATCH] mfd: tps6586x: Remove device ID check
Thread-Topic: [PATCH] mfd: tps6586x: Remove device ID check
Thread-Index: AQIozUHlfHVzZuJH9tDmGROJUtJzLAFK8c+8kt7PCMA=
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF030FD78609@HQMAIL01.nvidia.com>
References: <20101209135857.GK8884@sortiz-mobl>
 <1291915811-17227-1-git-send-email-swarren@nvidia.com>
In-Reply-To: <1291915811-17227-1-git-send-email-swarren@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Stephen Warren [mailto:swarren@nvidia.com]
> Sent: Thursday, December 09, 2010 10:30 AM
> 
> ... and convert it to a dev_info print at probe time.

Samuel,

Sorry to ping you, but does this updated patch look OK and address your
concerns? Thanks.

> There are many variants of this chip with different values of VERSIONCRC.
> The set of values is large, and not useful to enumerate. All are SW
> compatible. The difference lies in default settings of the various power
> rails, and other similar differences. The driver, or clients of the
> driver, shouldn't be affected by this, since all rails should be
> programmed into the desired state in all cases for correct operation.
> 
> Derived-from-code-by: Andrew Chew <achew@nvidia.com>
> Signed-off-by: Stephen Warren <swarren@nvidia.com>
> ---
>  drivers/mfd/tps6586x.c |    8 +-------
>  1 files changed, 1 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/mfd/tps6586x.c b/drivers/mfd/tps6586x.c
> index b4931ab..3575739 100644
> --- a/drivers/mfd/tps6586x.c
> +++ b/drivers/mfd/tps6586x.c
> @@ -46,8 +46,6 @@
> 
>  /* device id */
>  #define TPS6586X_VERSIONCRC	0xcd
> -#define TPS658621A_VERSIONCRC	0x15
> -#define TPS658621C_VERSIONCRC	0x2c
> 
>  struct tps6586x_irq_data {
>  	u8	mask_reg;
> @@ -498,11 +496,7 @@ static int __devinit tps6586x_i2c_probe(struct i2c_client *client,
>  		return -EIO;
>  	}
> 
> -	if ((ret != TPS658621A_VERSIONCRC) &&
> -	    (ret != TPS658621C_VERSIONCRC)) {
> -		dev_err(&client->dev, "Unsupported chip ID: %x\n", ret);
> -		return -ENODEV;
> -	}
> +	dev_info(&client->dev, "VERSIONCRC is %02x\n", ret);
> 
>  	tps6586x = kzalloc(sizeof(struct tps6586x), GFP_KERNEL);
>  	if (tps6586x == NULL)
> --
> 1.7.0.4

-- 
nvpublic

