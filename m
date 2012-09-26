Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752665Ab2IZGuJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 02:50:09 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:50995 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750835Ab2IZGuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 02:50:07 -0400
Date: Wed, 26 Sep 2012 09:49:51 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Ilya gorskin <revent82@gmail.com>
Cc: gregkh@linuxfoundation.org, forest@alittletooquiet.net,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging:vt6656: Fix tabs error in 80211mgr.c
Message-ID: <20120926064950.GB4587@mwanda>
References: <1348639511-19305-1-git-send-email-revent82@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348639511-19305-1-git-send-email-revent82@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 26, 2012 at 12:05:11PM +0600, Ilya gorskin wrote:
> This is a patch to the 80211mgr.c file that fixes up a tabs
> error found by the checkpatch.pl tool
> 
> Signed-off-by: Goirskin Ilya <revent82@gmail.com>
> ---
>  drivers/staging/vt6656/80211mgr.c | 628 +++++++++++++++++++-------------------
>  1 file changed, 310 insertions(+), 318 deletions(-)
> 
> diff --git a/drivers/staging/vt6656/80211mgr.c b/drivers/staging/vt6656/80211mgr.c
> index 39f9842..4241d29 100644
> --- a/drivers/staging/vt6656/80211mgr.c
> +++ b/drivers/staging/vt6656/80211mgr.c
> @@ -98,11 +98,11 @@ vMgrEncodeBeacon(
>  
>      /* Fixed Fields */
>      pFrame->pqwTimestamp = (PQWORD)(WLAN_HDR_A3_DATA_PTR(&(pFrame->pHdr->sA3))
> -                                    + WLAN_BEACON_OFF_TS);
> +							+ WLAN_BEACON_OFF_TS);

This was aligned correctly in the original.  (Although the line is
messy so it explains why you were confused).

>      pFrame->pwBeaconInterval = (PWORD)(WLAN_HDR_A3_DATA_PTR(&(pFrame->pHdr->sA3))
> -                                       + WLAN_BEACON_OFF_BCN_INT);
> +						+ WLAN_BEACON_OFF_BCN_INT);
>      pFrame->pwCapInfo = (PWORD)(WLAN_HDR_A3_DATA_PTR(&(pFrame->pHdr->sA3))
> -                                + WLAN_BEACON_OFF_CAPINFO);
> +						+ WLAN_BEACON_OFF_CAPINFO);
>  
>      pFrame->len = WLAN_HDR_ADDR3_LEN + WLAN_BEACON_OFF_SSID;
>  
> @@ -132,98 +132,90 @@ vMgrDecodeBeacon(
>  
>      /* Fixed Fields */
>      pFrame->pqwTimestamp = (PQWORD)(WLAN_HDR_A3_DATA_PTR(&(pFrame->pHdr->sA3))
> -                                    + WLAN_BEACON_OFF_TS);
> +							+ WLAN_BEACON_OFF_TS);
>      pFrame->pwBeaconInterval = (PWORD)(WLAN_HDR_A3_DATA_PTR(&(pFrame->pHdr->sA3))
> -                                       + WLAN_BEACON_OFF_BCN_INT);
> +						+ WLAN_BEACON_OFF_BCN_INT);
>      pFrame->pwCapInfo = (PWORD)(WLAN_HDR_A3_DATA_PTR(&(pFrame->pHdr->sA3))
> -                                + WLAN_BEACON_OFF_CAPINFO);
> +						+ WLAN_BEACON_OFF_CAPINFO);
>  
>      /* Information elements */
>      pItem = (PWLAN_IE)((PBYTE)(WLAN_HDR_A3_DATA_PTR(&(pFrame->pHdr->sA3)))
> -                       + WLAN_BEACON_OFF_SSID);
> +						+ WLAN_BEACON_OFF_SSID);

Actually all of these were more correct in the original.

Ah.  I see the problem.  The original used spaces.  Still the
alignment was better.  It should be:
[tab] [tab] [tab] [space] [space]

You're allowed to use spaces to get the alignment to work.

Really the '+' should probably be on the line before.  But it's not
worth sending a patch over.

>      pFrame->pwCapInfo = (PWORD)(WLAN_HDR_A3_DATA_PTR(&(pFrame->pHdr->sA3))
> -                                + WLAN_REASSOCREQ_OFF_CAP_INFO);
> +											+ WLAN_REASSOCREQ_OFF_CAP_INFO);
>      pFrame->pwListenInterval = (PWORD)(WLAN_HDR_A3_DATA_PTR(&(pFrame->pHdr->sA3))
> -                                      + WLAN_REASSOCREQ_OFF_LISTEN_INT);
> +											+ WLAN_REASSOCREQ_OFF_LISTEN_INT);

Really???  I'm not a huge fan of the 80 character line limit, but at
least the left side of the line should be within the 80 characters.

Yeah.  This patch is going nowhere.

regards,
dan carpenter
