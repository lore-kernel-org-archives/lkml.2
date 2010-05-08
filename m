Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752666Ab0EHI4t (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 May 2010 04:56:49 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:41982 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751362Ab0EHI4s convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 May 2010 04:56:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=txd/bDHrkSddWldoGKL/H9ALC7FEdFbL28xvGLON/uTEaQb5EdIFmpS0ZCndgUH6/3
         n9+yFsSb5GU5gXcKdpwgZUQxRjwpXJ5s7aMJBGTSNQ/KHdlT3kVNn3bJFleWP0pSrR/U
         18n6r+Je9AyHKkEQeA3Lm5pYEjPJwIDFMJw6Y=
MIME-Version: 1.0
In-Reply-To: <4BE4BDED.5050406@tuxonice.net>
References: <v2ubd0d95d71005061941j4f9272d1he7dc9bcf5daa6457@mail.gmail.com>
	 <CEE6BB42CAD6E947908279175AF8470A025A68CE5C@EXDCVYMBSTM006.EQ1STM.local>
	 <z2mbd0d95d71005070017w7aa97001m2b81be6dbc1021b9@mail.gmail.com>
	 <4BE3DF5A.9070601@tuxonice.net>
	 <v2gbd0d95d71005070247j1f615a65mcbd52b5b6474206e@mail.gmail.com>
	 <CEE6BB42CAD6E947908279175AF8470A025A68D366@EXDCVYMBSTM006.EQ1STM.local>
	 <4BE4BDED.5050406@tuxonice.net>
Date: Sat, 8 May 2010 16:56:47 +0800
Message-ID: <i2ubd0d95d71005080156z7bf1b34bh2a15532813ae7cec@mail.gmail.com>
Subject: Re: [PATCH] Check kmalloc return value before use the buffer
From: Steven Liu <lingjiujianke@gmail.com>
To: Nigel Cunningham <nigel@tuxonice.net>
Cc: Linus WALLEIJ <linus.walleij@stericsson.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Linus WALLEIJ]

   can this patch fix in?

2010/5/8 Nigel Cunningham <nigel@tuxonice.net>:
> Hi again.
>
> On 08/05/10 04:57, Linus WALLEIJ wrote:
>>
>> [Steven]
>>
>>> the code in arch/arm/mach-u300/dummyspichip.c is
>>>
>>>     bigtxbuf_virtual = kmalloc(DMA_TEST_SIZE, GFP_KERNEL);
>>>     if (bigtxbuf_virtual == NULL) {
>>>         status = -ENOMEM;
>>>         goto out;
>>>     }
>>>     bigrxbuf_virtual = kmalloc(DMA_TEST_SIZE, GFP_KERNEL);
>>>
>>>
>>> if kmalloc memory space for bigrxbuf_virtual is NULL, when it have
>>> kmalloc DMA_TEST_SIZE memory space for bigtxbuf_virtual,so ,if kmalloc
>>> memory for bigtxbuf_virtual success and kmalloc memory for
>>> bigrxbuf_virtual faild,i think we must kfree  bigtxbuf_virtual memory
>>
>> Ha, I also misread tx for rx, sorry.
>
> I've just looked again, and the original version did have rx in the test. We
> weren't seeing things :)
>
>> Acked-by: Linus Walleij<linus.walleij@stericsson.com>
>
> Acked-by: Nigel Cunningham <nigel@tuxonice.net>
>
> Regards,
>
> Nigel
>
