Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754881Ab0KAVRU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 17:17:20 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:35097 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753430Ab0KAVRR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 17:17:17 -0400
Date: Mon, 1 Nov 2010 22:16:53 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Pekka Enberg <penberg@kernel.org>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] w35und: Kill struct hwdata ->NullPacketCount
Message-ID: <20101101211653.GF22934@elf.ucw.cz>
References: <1288643371-10310-1-git-send-email-penberg@kernel.org>
 <1288643371-10310-2-git-send-email-penberg@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1288643371-10310-2-git-send-email-penberg@kernel.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2010-11-01 22:29:29, Pekka Enberg wrote:
> This patch kills the NullPacketCount member of struct hwdata. It's not used for
> anything so it's safe to remove it.
> 
> Cc: Pavel Machek <pavel@ucw.cz>
> Signed-off-by: Pekka Enberg <penberg@kernel.org>

ACK.

> ---
>  drivers/staging/winbond/wbhal.h |    6 ------
>  drivers/staging/winbond/wbusb.c |    9 ---------
>  2 files changed, 0 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/staging/winbond/wbhal.h b/drivers/staging/winbond/wbhal.h
> index 821a1b3..6f4cd76 100644
> --- a/drivers/staging/winbond/wbhal.h
> +++ b/drivers/staging/winbond/wbhal.h
> @@ -342,9 +342,6 @@ struct wb35_descriptor { /* Skip length = 8 DWORD */
>  	void	*buffer_address[MAX_DESCRIPTOR_BUFFER_INDEX];
>  };
>  
> -
> -#define DEFAULT_NULL_PACKET_COUNT	180000	/* 180 seconds */
> -
>  #define MAX_TXVGA_EEPROM		9	/* How many word(u16) of EEPROM will be used for TxVGA */
>  #define MAX_RF_PARAMETER		32
>  
> @@ -517,9 +514,6 @@ struct hw_data {
>  
>  	/* For error recover */
>  	u32		HwStop;
> -
> -	/* For avoid AP disconnect */
> -	u32		NullPacketCount;
>  };
>  
>  #endif
> diff --git a/drivers/staging/winbond/wbusb.c b/drivers/staging/winbond/wbusb.c
> index 82040f4..dcb6d5b 100644
> --- a/drivers/staging/winbond/wbusb.c
> +++ b/drivers/staging/winbond/wbusb.c
> @@ -611,15 +611,6 @@ static void hal_led_control(unsigned long data)
>  			}
>  			break;
>  		}
> -
> -		/* Active send null packet to avoid AP disconnect */
> -		if (pHwData->LED_LinkOn) {
> -			pHwData->NullPacketCount += TimeInterval;
> -			if (pHwData->NullPacketCount >=
> -			    DEFAULT_NULL_PACKET_COUNT) {
> -				pHwData->NullPacketCount = 0;
> -			}
> -		}
>  	}
>  
>  	pHwData->time_count += TimeInterval;

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
