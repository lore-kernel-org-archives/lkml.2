Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753924Ab0JAHyA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 03:54:00 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:60281 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751501Ab0JAHx7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 03:53:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:from:date:message-id
         :subject:to:cc:content-type:content-transfer-encoding;
        b=KKKDmK+UZRDvLoy4z+fAyz+VV7scNJ81wTQE7/qOkzEh5PzQEdIS/c77z32AwQiIC5
         0cJCnpwIbddWBv2hwwWxRKGWGizUlkNC8YeCvBQ81ZAnQykPD4X08C2G8rV8PbAxWeTY
         LJq3JYzFeKPqkbH/P3a4LySPh49V5uiiEuGDM=
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <20101001071906.GC20529@opensource.wolfsonmicro.com>
References: <1285912587.12422.2.camel@mola> <20101001071906.GC20529@opensource.wolfsonmicro.com>
From: Axel Lin <axel.lin@gmail.com>
Date: Fri, 1 Oct 2010 15:53:38 +0800
Message-ID: <AANLkTinNiRLi=EdpNku54Wsu7KNx3Tvhg9CEa6Q8wMGY@mail.gmail.com>
Subject: Re: [PATCH] regulator: max8649 - fix setting extclk_freq
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/10/1 Mark Brown <broonie@opensource.wolfsonmicro.com>:
> On Fri, Oct 01, 2010 at 01:56:27PM +0800, Axel Lin wrote:
>> The SYNC bits are BIT6 and BIT7 of MAX8649_SYNC register.
>> pdata->extclk_freq could be [0|1|2].
>> (MAX8649_EXTCLK_26MHZ|MAX8649_EXTCLK_13MHZ|MAX8649_EXTCLK_19MHZ)
>> It requires to left shift 6 bits to properly set extclk_freq.
>>
>> Signed-off-by: Axel Lin <axel.lin@gmail.com>
>
> Are there existing users of the driver?  It's not always 100% clear if
> people are expecting bitfield values that will be shifted in or values
> that can be ored directly in.  I don't really mind either way but I'd
> rather be careful.
>

max8649 regulator is used in arch/arm/mach-mmp/jasper.c (Marvell
Jasper Development Platform)

I checked include/linux/regulator/max8649.h
extclk_freq only takes 2 bits:
unsigned        extclk_freq:2;

People should set extclk_freq to
[MAX8649_EXTCLK_26MHZ|MAX8649_EXTCLK_13MHZ|MAX8649_EXTCLK_19MHZ],
so we need to do 6 bits left shift to properly set extclk_freq.

Regards,
Axel
