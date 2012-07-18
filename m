Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752896Ab2GRJxB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 05:53:01 -0400
Received: from protonic.xs4all.nl ([213.84.116.84]:18725 "EHLO
	protonic.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507Ab2GRJww (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 05:52:52 -0400
X-Greylist: delayed 1372 seconds by postgrey-1.27 at vger.kernel.org; Wed, 18 Jul 2012 05:52:52 EDT
Message-ID: <50068216.9020605@protonic.nl>
Date: Wed, 18 Jul 2012 11:29:58 +0200
From: Robin van der Gracht <robin@protonic.nl>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: =?UTF-8?B?TG90aGFyIFdhw59tYW5u?= <LW@KARO-electronics.de>
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [BUGFIX] video/mxsfb: fix crash when unblanking the display
References: <1323174425-24038-1-git-send-email-LW@KARO-electronics.de> <20209.35406.958883.977664@ipc1.ka-ro>
In-Reply-To: <20209.35406.958883.977664@ipc1.ka-ro>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lothar,
> Hi,
>
> Lothar Waßmann writes:
>> The VDCTRL4 register does not provide the MXS SET/CLR/TOGGLE feature.
>> The write in mxsfb_disable_controller() sets the data_cnt for the LCD
>> DMA to 0 which obviously means the max. count for the LCD DMA and
>> leads to overwriting arbitrary memory when the display is unblanked.
>>
>> Signed-off-by: Lothar Waßmann<LW@KARO-electronics.de>
>> ---
>>   drivers/video/mxsfb.c |    3 ++-
>>   1 files changed, 2 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/video/mxsfb.c b/drivers/video/mxsfb.c
>> index d837d63..03cb95a 100644
>> --- a/drivers/video/mxsfb.c
>> +++ b/drivers/video/mxsfb.c
>> @@ -366,7 +366,8 @@ static void mxsfb_disable_controller(struct fb_info *fb_info)
>>   		loop--;
>>   	}
>>
>> -	writel(VDCTRL4_SYNC_SIGNALS_ON, host->base + LCDC_VDCTRL4 + REG_CLR);
>> +	reg = readl(host->base + LCDC_VDCTRL4);
>> +	writel(reg&  ~VDCTRL4_SYNC_SIGNALS_ON, host->base + LCDC_VDCTRL4);
>>
>>   	clk_disable(host->clk);
>>
>> -- 
>> 1.5.6.5
>>
> Ping. Any comments on this?
>
>
> Lothar Waßmann
I've encountered this problem to, and i can confirm your patch fixed it.
The VDCTRL4 register has no CLR feature.

Regards,

-- 
Robin van der Gracht
Protonic Holland.
tel.: +31 (0) 229 212928
fax.: +31 (0) 229 210930
Factorij 36 / 1689 AL Zwaag

