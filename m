Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754105Ab2DRRRd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 13:17:33 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:53750 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752646Ab2DRRRc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 13:17:32 -0400
Message-ID: <1334694212.1909.4.camel@joe2Laptop>
Subject: Re: [PATCH][Trivial] staging: vt6656: Remove some redundant casts
 and parentheses + other style cleanups
From: Joe Perches <joe@perches.com>
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org,
        devel@driverdev.osuosl.org, Xi Wang <xi.wang@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Forest Bond <forest@alittletooquiet.net>
In-Reply-To: <alpine.LNX.2.00.1204162314480.21898@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1204162314480.21898@swampdragon.chaosbits.net>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 17 Apr 2012 14:23:32 -0600
Mime-Version: 1.0
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-04-16 at 23:20 +0200, Jesper Juhl wrote:
> This is just a small/trivial cleanup patch. It makes the following
> changes to drivers/staging/vt6656/ioctl.c:
> 
> 1. Remove some redundant casts.

drivers/staging/vt6656/wcmd.h:BOOL bScheduleCommand(void *hDeviceContext,

so you could remove the casts of the first argument too.

> diff --git a/drivers/staging/vt6656/ioctl.c b/drivers/staging/vt6656/ioctl.c
[]
> @@ -101,7 +101,7 @@ int private_ioctl(PSDevice pDevice, struct ifreq *rq)
>  					 WLAN_CMD_BSSID_SCAN,
>  					 abyScanSSID);
>  		else
> -			bScheduleCommand((void *) pDevice, WLAN_CMD_BSSID_SCAN, NULL);
> +			bScheduleCommand((void *)pDevice, WLAN_CMD_BSSID_SCAN, NULL);

			bScheduleCommand(pDevice, WLAN_CMD_BSSID_SCAN, NULL);
[]
> @@ -190,10 +191,9 @@ int private_ioctl(PSDevice pDevice, struct ifreq *rq)
>  		netif_stop_queue(pDevice->dev);
>  		spin_lock_irq(&pDevice->lock);
>  		pMgmt->eCurrState = WMAC_STATE_IDLE;
> -		bScheduleCommand((void *) pDevice,
> -				 WLAN_CMD_BSSID_SCAN,
> +		bScheduleCommand((void *)pDevice, WLAN_CMD_BSSID_SCAN,
>  				 pMgmt->abyDesireSSID);
		bScheduleCommand(pDevice, WLAN_CMD_BSSID_SCAN,
				 pMgmt->abyDesireSSID);
etc


