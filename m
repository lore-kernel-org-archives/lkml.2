Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753872Ab0EGHQg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 03:16:36 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:51673 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751579Ab0EGHQe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 03:16:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=TFCxVYJBBiFEvdLYnyddQSfeib7FRueONgt7pLfYo0UBQDES0eMRnqG/DmO70FahRJ
         Brkguh4sAyZ96uf++xbzJlRvE8xwzZyPWWP2b1C2NV4Xjt6rbIl+72XGoyl5jztaSVGE
         CEj9ssL9M3gz0gHq3D8BFQsIomSX7UYIgHDqg=
MIME-Version: 1.0
In-Reply-To: <CEE6BB42CAD6E947908279175AF8470A025A68CE5C@EXDCVYMBSTM006.EQ1STM.local>
References: <v2ubd0d95d71005061941j4f9272d1he7dc9bcf5daa6457@mail.gmail.com>
	 <CEE6BB42CAD6E947908279175AF8470A025A68CE5C@EXDCVYMBSTM006.EQ1STM.local>
Date: Fri, 7 May 2010 15:16:34 +0800
Message-ID: <q2jbd0d95d71005070016we6efdcb8n239bd786fe7369bc@mail.gmail.com>
Subject: Re: [PATCH] Check kmalloc return value before use the buffer
From: Steven Liu <lingjiujianke@gmail.com>
To: Linus WALLEIJ <linus.walleij@stericsson.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oh,I think I have a mistake


Signed-off-by: root <root@T-bagwell.(none)>
---
 arch/arm/mach-u300/dummyspichip.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-u300/dummyspichip.c
b/arch/arm/mach-u300/dummyspichip.c
index 5f55012..df19f9b 100644
--- a/arch/arm/mach-u300/dummyspichip.c
+++ b/arch/arm/mach-u300/dummyspichip.c
@@ -64,6 +64,11 @@ static ssize_t dummy_looptest(struct device *dev,
 		goto out;
 	}
 	bigrxbuf_virtual = kmalloc(DMA_TEST_SIZE, GFP_KERNEL);
+	if (bigrxbuf_virtual == NULL) {
+		status = -ENOMEM;
+		kfree(bigtxbuf_virtual);
+		goto out;
+	}

 	/* Fill TXBUF with some happy pattern */
 	memset(bigtxbuf_virtual, 0xAA, DMA_TEST_SIZE);
-- 
1.6.0.3





what a bout this one, please?


Best regards!



2010/5/7 Linus WALLEIJ <linus.walleij@stericsson.com>:
> Hi Liu,
>
>> Hi,linus.walleij
>>
>>           Check kmalloc return value before use the buffer
>>
>>
>> Signed-off-by: LiuQi <lingjiujianke@gmail.com>
>> ---
>>  arch/arm/mach-u300/dummyspichip.c |    5 +++++
>>  1 files changed, 5 insertions(+), 0 deletions(-)
>>
>> diff --git a/arch/arm/mach-u300/dummyspichip.c
>> b/arch/arm/mach-u300/dummyspichip.c
>> index 962f9de..4f2af7c 100644
>> --- a/arch/arm/mach-u300/dummyspichip.c
>> +++ b/arch/arm/mach-u300/dummyspichip.c
>> @@ -63,6 +63,11 @@ static ssize_t dummy_looptest(struct device *dev,
>>               goto out;
>>       }
>>       bigrxbuf_virtual = kmalloc(DMA_TEST_SIZE, GFP_KERNEL);
>> +     if (bigtxbuf_virtual == NULL) {
>> +             status = -ENOMEM;
>> +             kfree(bigtxbuf_virtual);
>
> kfree():ing NULL is OK, but you just checked it to be NULL so why?
>
>> +             goto out;
>> +     }
>>
>>       /* Fill TXBUF with some happy pattern */
>>       memset(bigtxbuf_virtual, 0xAA, DMA_TEST_SIZE);
>
> Otherwise the bug it fixes is good to fix.
>
> Yours,
> Linus Walleij
>
