Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752657Ab1CBOMd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 09:12:33 -0500
Received: from mail-px0-f174.google.com ([209.85.212.174]:40035 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751246Ab1CBOMc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 09:12:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=VzV8C6Gg3Sms516r43ey24BpKHdxHgkwrGFPrESp9x8Q6nzXYZ3muMF3D8eaE+KQcQ
         HAGxZEnB05brp2FQ3tBsyCSZm6ss8H0rSZjeVcEUz6JT785XZ30mKqo/GWAzbTU6G1zY
         I1kawGvdAsduzy4XlyMy8dj7aNnZqw+E4Mq7w=
MIME-Version: 1.0
In-Reply-To: <20110302113448.GH16181@sortiz-mobl>
References: <1298377440-13032-1-git-send-email-daniel.willerud@stericsson.com>
	<20110302113448.GH16181@sortiz-mobl>
Date: Wed, 2 Mar 2011 15:12:31 +0100
X-Google-Sender-Auth: VRdmJy338mRsOs832HrCoSZdgdc
Message-ID: <AANLkTinTP5UKWeu1eGvAA08YKJzz8=iskEPyPVSFzeCM@mail.gmail.com>
Subject: Re: [PATCH] MFD: ab8500: New ab8500_gpadc APIs and reentrance
From: Linus Walleij <linus.walleij@linaro.org>
To: Samuel Ortiz <sameo@linux.intel.com>,
        Daniel Willerud <daniel.willerud@stericsson.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/3/2 Samuel Ortiz <sameo@linux.intel.com>:

>> +/**
>> + * ab8500_gpadc_get() - returns a reference to the primary AB8500 GPADC
>> + * (i.e. the first GPADC in the instance list)
>> + */
>> +struct ab8500_gpadc *ab8500_gpadc_get(void)
>> +{
>> +     struct ab8500_gpadc *gpadc;
>> +     gpadc = list_first_entry(&ab8500_gpadc_list, struct ab8500_gpadc, node);
>> +
>> +     return gpadc;
>> +}

> This seems really arbitrary. We argued with Mattias about it, and giving
> drivers access to your ADCs means they should somehow have a pointer back to
> the right ADC. That's not the case here, and while it will just work fine
> whenever you have one ADC on your board, you'll probably be relying on some
> sort of device probe order otherwise.

I guess the solution is to rewrite that function to take a parameter
then, such as:

struct ab8500_gpadc *ab8500_gpadc_get(char *name)

If name is then just a strcmpm(dev_name(gpadc->dev), name)
the client use will be something like:

struct ab8500_gpadc *gpadc = ab8500_gpadc_get("ab8500-gpadc.0");

For the first GPDC in the system (unless .init_name is specified
by the ab8500-core when creating the device).

Fair enough?

Yours,
Linus Walleij
