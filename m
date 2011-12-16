Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760006Ab1LPBw4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 20:52:56 -0500
Received: from newsmtp5.atmel.com ([204.2.163.5]:34093 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757723Ab1LPBwz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 20:52:55 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] atmel ac97c: using software reset instead hardware reset if not available
Date: Fri, 16 Dec 2011 09:52:50 +0800
Message-ID: <4C79549CB6F772498162A641D92D532803B527CA@penmb01.corp.atmel.com>
In-Reply-To: <4EE9F04C.6080906@atmel.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] atmel ac97c: using software reset instead hardware reset if not available
Thread-Index: Acy7Kg2Gkk2TbgcuTlmQR0hmq3dXBwAaz6VA
References: <1322042701-32100-1-git-send-email-voice.shen@atmel.com> <4EE9F04C.6080906@atmel.com>
From: "Shen, Voice" <Voice.Shen@atmel.com>
To: "Ferre, Nicolas" <Nicolas.FERRE@atmel.com>
Cc: <linux-kernel@vger.kernel.org>, <linux-sound@vger.kernel.org>,
        "Lin, JM" <JM.Lin@atmel.com>, "Xu, Hong" <Hong.Xu@atmel.com>
X-OriginalArrivalTime: 16 Dec 2011 01:52:52.0972 (UTC) FILETIME=[6C6102C0:01CCBB95]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nicolas,
  No one response for this.
  Would you please merge it?
  Thanks

Best Regards,
Voice Shen

-----Original Message-----
From: Nicolas Ferre [mailto:nicolas.ferre@atmel.com] 
Sent: Thursday, December 15, 2011 21:04 voice
To: Shen, Voice
Cc: linux-kernel@vger.kernel.org; linux-sound@vger.kernel.org; Lin, JM;
Xu, Hong
Subject: Re: [PATCH] atmel ac97c: using software reset instead hardware
reset if not available

On 11/23/2011 11:05 AM, voice :
> Using software reset instead hardware reset if not available

Ping?
Can you please tell me what is the status of this fix? Will it go
upstream for 3.3?

> Signed-off-by: Bo Shen <voice.shen@atmel.com>
> ---
>  sound/atmel/ac97c.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/sound/atmel/ac97c.c b/sound/atmel/ac97c.c
> index 6e5adde..73516f6 100644
> --- a/sound/atmel/ac97c.c
> +++ b/sound/atmel/ac97c.c
> @@ -899,6 +899,10 @@ static void atmel_ac97c_reset(struct atmel_ac97c
*chip)
>  		/* AC97 v2.2 specifications says minimum 1 us. */
>  		udelay(2);
>  		gpio_set_value(chip->reset_pin, 1);
> +	} else {
> +		ac97c_writel(chip, MR, AC97C_MR_WRST | AC97C_MR_ENA);
> +		udelay(2);
> +		ac97c_writel(chip, MR, AC97C_MR_ENA);
>  	}
>  }
>  


-- 
Nicolas Ferre
