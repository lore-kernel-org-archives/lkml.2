Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756205Ab0EGJru (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 05:47:50 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:45670 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755023Ab0EGJrs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 05:47:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=YzKL4WlwvrjFLH1Ypz1eMllnoB97Ifbm6exJoGkBY1ivNYtNwZVt73U1Sn768lpMmr
         E5gE+U1GiTvb0FnHpix4ycMtJWOYhknS3c6k34ToCfuRCa8OJGuzlvAfK9d+I/eHsaSg
         gmKTdb12OEf1Sa0KUXDmKKJsd4Rk9rpUEQ/jI=
MIME-Version: 1.0
In-Reply-To: <4BE3DF5A.9070601@tuxonice.net>
References: <v2ubd0d95d71005061941j4f9272d1he7dc9bcf5daa6457@mail.gmail.com>
	 <CEE6BB42CAD6E947908279175AF8470A025A68CE5C@EXDCVYMBSTM006.EQ1STM.local>
	 <z2mbd0d95d71005070017w7aa97001m2b81be6dbc1021b9@mail.gmail.com>
	 <4BE3DF5A.9070601@tuxonice.net>
Date: Fri, 7 May 2010 17:47:45 +0800
Message-ID: <v2gbd0d95d71005070247j1f615a65mcbd52b5b6474206e@mail.gmail.com>
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

Hi, guy,

the code in arch/arm/mach-u300/dummyspichip.c is

    bigtxbuf_virtual = kmalloc(DMA_TEST_SIZE, GFP_KERNEL);
    if (bigtxbuf_virtual == NULL) {
        status = -ENOMEM;
        goto out;
    }
    bigrxbuf_virtual = kmalloc(DMA_TEST_SIZE, GFP_KERNEL);


if kmalloc memory space for bigrxbuf_virtual is NULL, when it have
kmalloc DMA_TEST_SIZE memory space for bigtxbuf_virtual,so ,if kmalloc
memory for bigtxbuf_virtual success and kmalloc memory for
bigrxbuf_virtual faild,i think we must kfree  bigtxbuf_virtual memory



best regards,



LiuQi
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
