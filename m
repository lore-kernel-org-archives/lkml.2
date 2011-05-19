Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755449Ab1ESBrr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 21:47:47 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:61657 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751188Ab1ESBrq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 21:47:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:from:date:message-id
         :subject:to:cc:content-type:content-transfer-encoding;
        b=tS+yCgsmA9kOKywXSN0Sb8wSKz0NppYAh8zOj3GLcyYjElLUERe4kOplGOXcU8ahhI
         WJY8K1rYKGo41OXchfaeL8AdPCrOPSPT70RTozQ+Xk7eGQRmLX11krWFkhRKIKUJ2Tv9
         AiIYeFn5Ki2HqFcxVviVvh1gRHMjsR9mzI7qk=
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <20110518163205.GC16414@opensource.wolfsonmicro.com>
References: <1305723718.6172.6.camel@phoenix> <20110518163205.GC16414@opensource.wolfsonmicro.com>
From: Axel Lin <axel.lin@gmail.com>
Date: Thu, 19 May 2011 09:47:25 +0800
Message-ID: <BANLkTimU7FyuTuVw1ezOo381a798Ec+uCw@mail.gmail.com>
Subject: Re: [RFC][PATCH] regulator: Fix _regulator_get_voltage if get_voltage
 callback is NULL
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@slimlogic.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/5/19 Mark Brown <broonie@opensource.wolfsonmicro.com>:
> On Wed, May 18, 2011 at 09:01:58PM +0800, Axel Lin wrote:
>
>> @@ -1886,13 +1886,15 @@ static int _regulator_get_voltage(struct regulator_dev *rdev)
>>               if (sel < 0)
>>                       return sel;
>>               ret = rdev->desc->ops->list_voltage(rdev, sel);
>> +             goto out;
>>       }
>
> Why are you adding this goto?  It's not going to change anything...
>
no matter what ret value returns from rdev->desc->ops->list_voltage(rdev, sel);

In the case of rdev->desc->ops->get_voltage is NULL,
current implementation will always return -EINVAL;

Regards,
Axel
