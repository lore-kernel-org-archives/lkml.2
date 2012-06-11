Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753297Ab2FKKqR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 06:46:17 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:51589 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752192Ab2FKKqQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 06:46:16 -0400
MIME-Version: 1.0
In-Reply-To: <20120611095102.GD11168@n2100.arm.linux.org.uk>
References: <1339376810-8247-1-git-send-email-Ying.Liu@freescale.com>
	<20120611095102.GD11168@n2100.arm.linux.org.uk>
Date: Mon, 11 Jun 2012 18:46:14 +0800
Message-ID: <CA+8Hj81L9-NC=08_dvV2u_eM0NdssJsjduAgTbH37nusu56Avw@mail.gmail.com>
Subject: Re: [PATCH 1/3] mx3fb: do not support panning with fb blanked
From: Liu Ying <liu.y.victor@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Liu Ying <Ying.Liu@freescale.com>, g.liakhovetski@gmx.de,
        linux-fbdev@vger.kernel.org, FlorianSchandinat@gmx.de,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/6/11, Russell King - ARM Linux <linux@arm.linux.org.uk>:
> On Mon, Jun 11, 2012 at 09:06:48AM +0800, Liu Ying wrote:
>> This patch checks if framebuffer is unblanked before
>> we actually trigger panning in custom pan display
>> function.
>>
>> Signed-off-by: Liu Ying <Ying.Liu@freescale.com>
>> ---
>>  drivers/video/mx3fb.c |    5 +++++
>>  1 files changed, 5 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/video/mx3fb.c b/drivers/video/mx3fb.c
>> index e3406ab..d53db60 100644
>> --- a/drivers/video/mx3fb.c
>> +++ b/drivers/video/mx3fb.c
>> @@ -1063,6 +1063,11 @@ static int mx3fb_pan_display(struct
>> fb_var_screeninfo *var,
>>  	dev_dbg(fbi->device, "%s [%c]\n", __func__,
>>  		list_empty(&mx3_fbi->idmac_channel->queue) ? '-' : '+');
>>
>> +	if (mx3_fbi->blank != FB_BLANK_UNBLANK) {
>> +		dev_dbg(fbi->device, "panning with fb blanked not supported\n");
>> +		return -EFAULT;
>> +	}
>
> Why is this an error, and why return -EFAULT?  What userspace access
> failed?
>
Hi, Russell,

IMHO, panning with framebuffer blanked is meaningless, at least, it is
not a common usecase. Most users use pan display to swap front buffer
and back buffer when framebuffer is unblanked/active. So, I choose to
take the in question case as an error. Pan display may let user select
a buffer address to be active on display  and I saw the head file
'errno-base.h' comments EFAULT macro to be 'Bad address', so I use
this return value. Perhaps, this return value is not good enough.
Maybe, EIO is better? Would you please help to give some advice on
this?

Thanks.

-- 
Best Regards,
Liu Ying
