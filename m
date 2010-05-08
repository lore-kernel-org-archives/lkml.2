Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755339Ab0EHB1P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 21:27:15 -0400
Received: from crca.org.au ([74.207.252.120]:40976 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751514Ab0EHB1O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 21:27:14 -0400
X-Bogosity: Ham, spamicity=0.000000
Message-ID: <4BE4BDED.5050406@tuxonice.net>
Date: Sat, 08 May 2010 11:27:09 +1000
From: Nigel Cunningham <nigel@tuxonice.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: Linus WALLEIJ <linus.walleij@stericsson.com>
CC: Steven Liu <lingjiujianke@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Check kmalloc return value before use the buffer
References: <v2ubd0d95d71005061941j4f9272d1he7dc9bcf5daa6457@mail.gmail.com>	 <CEE6BB42CAD6E947908279175AF8470A025A68CE5C@EXDCVYMBSTM006.EQ1STM.local>	 <z2mbd0d95d71005070017w7aa97001m2b81be6dbc1021b9@mail.gmail.com>	 <4BE3DF5A.9070601@tuxonice.net> <v2gbd0d95d71005070247j1f615a65mcbd52b5b6474206e@mail.gmail.com> <CEE6BB42CAD6E947908279175AF8470A025A68D366@EXDCVYMBSTM006.EQ1STM.local>
In-Reply-To: <CEE6BB42CAD6E947908279175AF8470A025A68D366@EXDCVYMBSTM006.EQ1STM.local>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi again.

On 08/05/10 04:57, Linus WALLEIJ wrote:
> [Steven]
>
>> the code in arch/arm/mach-u300/dummyspichip.c is
>>
>>      bigtxbuf_virtual = kmalloc(DMA_TEST_SIZE, GFP_KERNEL);
>>      if (bigtxbuf_virtual == NULL) {
>>          status = -ENOMEM;
>>          goto out;
>>      }
>>      bigrxbuf_virtual = kmalloc(DMA_TEST_SIZE, GFP_KERNEL);
>>
>>
>> if kmalloc memory space for bigrxbuf_virtual is NULL, when it have
>> kmalloc DMA_TEST_SIZE memory space for bigtxbuf_virtual,so ,if kmalloc
>> memory for bigtxbuf_virtual success and kmalloc memory for
>> bigrxbuf_virtual faild,i think we must kfree  bigtxbuf_virtual memory
>
> Ha, I also misread tx for rx, sorry.

I've just looked again, and the original version did have rx in the 
test. We weren't seeing things :)

> Acked-by: Linus Walleij<linus.walleij@stericsson.com>

Acked-by: Nigel Cunningham <nigel@tuxonice.net>

Regards,

Nigel
