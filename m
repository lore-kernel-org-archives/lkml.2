Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760164Ab1LPIkE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 03:40:04 -0500
Received: from newsmtp5.atmel.com ([204.2.163.5]:31254 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751180Ab1LPIkB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 03:40:01 -0500
Message-ID: <4EEB03DB.4070201@atmel.com>
Date: Fri, 16 Dec 2011 09:39:55 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111124 Thunderbird/8.0
MIME-Version: 1.0
To: "Shen, Voice" <Voice.Shen@atmel.com>
CC: linux-kernel@vger.kernel.org, linux-sound@vger.kernel.org,
        "Lin, JM" <JM.Lin@atmel.com>, "Xu, Hong" <Hong.Xu@atmel.com>
Subject: Re: [PATCH] atmel ac97c: using software reset instead hardware reset
 if not available
References: <1322042701-32100-1-git-send-email-voice.shen@atmel.com> <4EE9F04C.6080906@atmel.com> <4C79549CB6F772498162A641D92D532803B527CA@penmb01.corp.atmel.com>
In-Reply-To: <4C79549CB6F772498162A641D92D532803B527CA@penmb01.corp.atmel.com>
X-Enigmail-Version: 1.4a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/16/2011 02:52 AM, Shen, Voice :
> Hi Nicolas,
>   No one response for this.
>   Would you please merge it?

Unfortunately I cannot.

You will have to make sure that the *sound* maintainer is taking your
patch into account. It can take several iterations but you must be sure
that your work is included into maintainer's git tree.

Good luck... Bye,

> -----Original Message-----
> From: Nicolas Ferre [mailto:nicolas.ferre@atmel.com] 
> Sent: Thursday, December 15, 2011 21:04 voice
> To: Shen, Voice
> Cc: linux-kernel@vger.kernel.org; linux-sound@vger.kernel.org; Lin, JM;
> Xu, Hong
> Subject: Re: [PATCH] atmel ac97c: using software reset instead hardware
> reset if not available
> 
> On 11/23/2011 11:05 AM, voice :
>> Using software reset instead hardware reset if not available
> 
> Ping?
> Can you please tell me what is the status of this fix? Will it go
> upstream for 3.3?
> 
>> Signed-off-by: Bo Shen <voice.shen@atmel.com>
>> ---
>>  sound/atmel/ac97c.c |    4 ++++
>>  1 files changed, 4 insertions(+), 0 deletions(-)
>>
>> diff --git a/sound/atmel/ac97c.c b/sound/atmel/ac97c.c
>> index 6e5adde..73516f6 100644
>> --- a/sound/atmel/ac97c.c
>> +++ b/sound/atmel/ac97c.c
>> @@ -899,6 +899,10 @@ static void atmel_ac97c_reset(struct atmel_ac97c
> *chip)
>>  		/* AC97 v2.2 specifications says minimum 1 us. */
>>  		udelay(2);
>>  		gpio_set_value(chip->reset_pin, 1);
>> +	} else {
>> +		ac97c_writel(chip, MR, AC97C_MR_WRST | AC97C_MR_ENA);
>> +		udelay(2);
>> +		ac97c_writel(chip, MR, AC97C_MR_ENA);
>>  	}
>>  }
>>  
> 
> 


-- 
Nicolas Ferre
