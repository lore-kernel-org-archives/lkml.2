Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755982Ab1AaPL2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 10:11:28 -0500
Received: from smtp-out.google.com ([216.239.44.51]:34465 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751576Ab1AaPL1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 10:11:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=IyhGRmcH65/LFXnD195aPwFmlx0vyM49p6SCdbv4LCa9oj2lspIQ5Lu0vjCOMY1rez
         P/82m3N2P+vQYS3Uyf9A==
MIME-Version: 1.0
In-Reply-To: <20110130233743.GE2565@sortiz-mobl>
References: <1295448729-22821-1-git-send-email-vpalatin@chromium.org> <20110130233743.GE2565@sortiz-mobl>
From: Vincent Palatin <vpalatin@chromium.org>
Date: Mon, 31 Jan 2011 10:11:03 -0500
X-Google-Sender-Auth: lHNNS8ualLw76FQAJ8SvhXq_V2k
Message-ID: <AANLkTikxfvHMHWjy=y14wwj3f+V-NfcjtUnQ=6QOh_2R@mail.gmail.com>
Subject: Re: [PATCH] mfd: tps6586x: Invert GPIO and subdevices initialization
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Olof Johansson <olofj@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Samuel,

On Sun, Jan 30, 2011 at 18:37, Samuel Ortiz <sameo@linux.intel.com> wrote:
[...]
>> diff --git a/drivers/mfd/tps6586x.c b/drivers/mfd/tps6586x.c
>> index 627cf57..fdb16ed 100644
>> --- a/drivers/mfd/tps6586x.c
>> +++ b/drivers/mfd/tps6586x.c
>> @@ -517,19 +517,25 @@ static int __devinit tps6586x_i2c_probe(struct i2c_client *client,
>>               }
>>       }
>>
>> +     tps6586x_gpio_init(tps6586x, pdata->gpio_base);
>> +
> Wouldn't it make sense to have tps6586x_gpio_init() return an int and check it
> before adding the subdevs then ?

Yes, probably. I will do a v2 which checks the result of the GPIO registration.
By the way, when "gpio_base" is not set, I will consider that the
developer doesn't want the TPS gpio support and gracefully continue
without the GPIO registration in order to keep the current behaviour.

Regards,
-- 
Vincent
