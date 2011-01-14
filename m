Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753531Ab1ANGfl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 01:35:41 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:39609 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751007Ab1ANGfc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 01:35:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=Aiotdmy34b3furh3rjtnzL4mk9iH7XMmIDlcnQ6SRq/zzRoCWqU8mlksw/vX1zBtuJ
         H3Nq5m2Pjec5JJVbWwFGh5x/wTEFSnQayOIRLp7VC8rk9YO4UiUvYJfZ0jYSFQLxlPoX
         RCYS1rHIds1uCD9TbN1NSkCrLPDCeAiRdPlUM=
MIME-Version: 1.0
In-Reply-To: <1294933197.4114.85.camel@Joe-Laptop>
References: <1294919372-1904-1-git-send-email-ratbert.chuang@gmail.com> <1294933197.4114.85.camel@Joe-Laptop>
From: Po-Yu Chuang <ratbert.chuang@gmail.com>
Date: Fri, 14 Jan 2011 14:35:09 +0800
Message-ID: <AANLkTinQaqYN3Jo=N3W3a_9PYKPMbmvJU+_UjoajXnP9@mail.gmail.com>
Subject: Re: [PATCH] net: add Faraday FTMAC100 10/100 Ethernet driver
To: Joe Perches <joe@perches.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Po-Yu Chuang <ratbert@faraday-tech.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Joe,

On Thu, Jan 13, 2011 at 11:39 PM, Joe Perches <joe@perches.com> wrote:
> On Thu, 2011-01-13 at 19:49 +0800, Po-Yu Chuang wrote:
>> From: Po-Yu Chuang <ratbert@faraday-tech.com>
>>
>> FTMAC100 Ethernet Media Access Controller supports 10/100 Mbps and
>> MII.  This driver has been working on some ARM/NDS32 SoC including
>> Faraday A320 and Andes AG101.
>
> A couple of trivial comments not already mentioned by others.
>
>> diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
> []
>> @@ -2014,6 +2014,15 @@ config BCM63XX_ENET
>>         This driver supports the ethernet MACs in the Broadcom 63xx
>>         MIPS chipset family (BCM63XX).
>>
>> +config FTMAC100
>> +     tristate "Faraday FTMAC100 10/100 Ethernet support"
>> +     depends on ARM
>> +     select MII
>> +     help
>> +       This driver supports the FTMAC100 Ethernet controller from
>> +       Faraday. It is used on Faraday A320, Andes AG101, AG101P
>> +       and some other ARM/NDS32 SoC's.
>> +
>
> ARM specific net drivers are for now in drivers/net/arm/
> Perhaps it's better to locate these files there?

This controller is used by not only ARM-base platforms, but also
NDS32-base ones.
NDS32 is an ISA designed by Andes tech. Although it is not yet in the mainline,
they plan to push their stuff to mainline and are working on that.

So... I don't know if it is better to put my driver to driver/net/arm/.

Should I leave my driver at driver/net/ or put it in drvier/net/arm/
and let Andes tech guys
move it out of driver/net/arm/ when they use it later?

>> +     if (unlikely(ftmac100_rxdes_rx_error(rxdes))) {
>> +             if (printk_ratelimit())
>> +                     dev_info(dev, "rx err\n");
>
> There are many printk_ratelimit() tests.
>
> It's better to use net_ratelimit() or a local ratelimit_state
> so there's less possible suppression of other subsystem
> messages.

OK, fixed.


Thanks a lot for your absolutely non-trivial review. :-)
I'll submit a new version ASAP.

Thanks,
Po-Yu  Chuang
