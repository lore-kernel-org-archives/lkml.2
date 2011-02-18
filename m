Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758505Ab1BRXnA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 18:43:00 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:56354 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751319Ab1BRXm6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 18:42:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=f/+V8rfLuIGYb5/0Nmb4F818gL4LZANrY2zJbRrc0BLIKZJmSCCPqYKjdst+Pp8SH1
         m3937dY2RtwF84/8PmPTwZ2S+GXCCzOapNckTwoVhzHY+4ZQTUhBlR7Dli+0Jjei7Xn3
         Mxhi4FuGQiYKo/xLsMt/1lFsTt25r6LXVb8yM=
MIME-Version: 1.0
In-Reply-To: <1297896277.3011.5.camel@macbook.infradead.org>
References: <20110216222820.487AE9D401C@zog.reactivated.net>
	<1297896277.3011.5.camel@macbook.infradead.org>
Date: Fri, 18 Feb 2011 23:42:57 +0000
X-Google-Sender-Auth: Swkcp3hEvseX1N7n985XPxJ4rYs
Message-ID: <AANLkTikAF2X1A5jfoNfCPRhZkZ7qPdZ57c8B5b9z4+qr@mail.gmail.com>
Subject: Re: [PATCH v3] olpc_battery: convert to platform device
From: Daniel Drake <dsd@laptop.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: cbou@mail.ru, linux-kernel@vger.kernel.org, x86@kernel.org,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        dilinger@queued.net, dmitry.torokhov@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16 February 2011 22:44, David Woodhouse <dwmw2@infradead.org> wrote:
> On Wed, 2011-02-16 at 22:28 +0000, Daniel Drake wrote:
>>
>> +static int __init add_common_platform_devices(void)
>> +{
>> +       struct platform_device *pdev;
>> +
>> +       pdev = platform_device_register_simple("olpc-battery", -1, NULL, 0);
>> +       if (IS_ERR(pdev))
>> +               return PTR_ERR(pdev);
>> +
>> +       return 0;
>> +}
>> +
>
> Still kind of sucks that you have to do this, and can't bind to
> something in the device-tree.

OK, feel free to put this patch on hold for now. I started looking at
the device tree approach today. It looks doable but first we have to
fix a DT bug/inconsistency that is preventing us from correctly
binding to the tree's devices.

Daniel
