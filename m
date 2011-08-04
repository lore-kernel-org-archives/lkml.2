Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753336Ab1HDUcJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 16:32:09 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:39219 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134Ab1HDUb7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 16:31:59 -0400
MIME-Version: 1.0
In-Reply-To: <20110803090223.GM4587@distanz.ch>
References: <1312301372.2629.10.camel@localhost.localdomain>
	<20110803090223.GM4587@distanz.ch>
Date: Thu, 4 Aug 2011 21:31:58 +0100
Message-ID: <CAAVPGOPbspuvS_745bPwAPuWY6_N5VQX-mUhxo=RZhZDNSn0QA@mail.gmail.com>
Subject: Re: [PATCH] net/usb: Use kzalloc
From: Julie Sullivan <kernelmail.jms@gmail.com>
To: Tobias Klauser <tklauser@distanz.ch>
Cc: Thomas Meyer <thomas@m3y3r.de>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On 2011-08-02 at 18:09:28 +0200, Thomas Meyer <thomas@m3y3r.de> wrote:
>> --- a/drivers/net/usb/cdc_ncm.c 2011-07-26 00:46:08.126846923 +0200
>> +++ b/drivers/net/usb/cdc_ncm.c 2011-08-01 20:20:43.396390040 +0200
>> @@ -479,12 +479,10 @@ static int cdc_ncm_bind(struct usbnet *d
>>       int temp;
>>       u8 iface_no;
>>
>> -     ctx = kmalloc(sizeof(*ctx), GFP_KERNEL);
>> +     ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
>>       if (ctx == NULL)
>>               return -ENODEV;
>>
>> -     memset(ctx, 0, sizeof(*ctx));
>> -
>>       init_timer(&ctx->tx_timer);
>>       spin_lock_init(&ctx->mtx);
>>       ctx->netdev = dev->net;
>>
>>
>> --

I think we could do with a log message before the SOB too (like you
did in your 'Use resource_size()' patch? :-)
The subject line is rather terse on its own.

Cheers
Julie
