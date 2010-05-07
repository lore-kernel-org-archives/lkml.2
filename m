Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756241Ab0EGJuS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 05:50:18 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:64624 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755727Ab0EGJuQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 05:50:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Q6lUN8hZFilGQQVPV+cvsCb1x1f9Dxmvr+PUoXxyzRShZxhP16ZsXltSGT53F5LtaF
         u/+WDR4O+B+CWd9nj88VP/B4EwL0rBz6i7XG1sZ5Xfp07IEIjkC+mi1dQzJdbhp87/TV
         PqTF7kXTcz1MZmdTJkKiTO5Euw1xIghTVAiJ0=
MIME-Version: 1.0
In-Reply-To: <4BE3DF5A.9070601@tuxonice.net>
References: <v2ubd0d95d71005061941j4f9272d1he7dc9bcf5daa6457@mail.gmail.com>
	 <CEE6BB42CAD6E947908279175AF8470A025A68CE5C@EXDCVYMBSTM006.EQ1STM.local>
	 <z2mbd0d95d71005070017w7aa97001m2b81be6dbc1021b9@mail.gmail.com>
	 <4BE3DF5A.9070601@tuxonice.net>
Date: Fri, 7 May 2010 17:50:14 +0800
Message-ID: <g2gbd0d95d71005070250t510894a5ofcb384ebd1506c13@mail.gmail.com>
Subject: Re: [PATCH] Check kmalloc return value before use the buffer
From: Steven Liu <lingjiujianke@gmail.com>
To: nigel@tuxonice.net
Cc: Linus WALLEIJ <linus.walleij@stericsson.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Check kmalloc return value before use the bigrxbuf_virtual ,when
bigrxbuf_virtual is NULL, kfree  bigtxbuf_virtual

2010/5/7 Nigel Cunningham <nigel@tuxonice.net>:
> Hi.
>
> No commit comment?
>
> On 07/05/10 17:17, Steven Liu wrote:
>>
>> Signed-off-by: LiuQi<lingjiujianke@gmail.com>
>> ---
>>  arch/arm/mach-u300/dummyspichip.c |    5 +++++
>>  1 files changed, 5 insertions(+), 0 deletions(-)
>>
>> diff --git a/arch/arm/mach-u300/dummyspichip.c
>> b/arch/arm/mach-u300/dummyspichip.c
>> index 5f55012..df19f9b 100644
>> --- a/arch/arm/mach-u300/dummyspichip.c
>> +++ b/arch/arm/mach-u300/dummyspichip.c
>> @@ -64,6 +64,11 @@ static ssize_t dummy_looptest(struct device *dev,
>>                goto out;
>>        }
>>        bigrxbuf_virtual = kmalloc(DMA_TEST_SIZE, GFP_KERNEL);
>> +       if (bigrxbuf_virtual == NULL) {
>> +               status = -ENOMEM;
>> +               kfree(bigtxbuf_virtual);
>
> Why kfree something you know is NULL?
>
> Regards,
>
> Nigel
>
