Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753032Ab0EGGwV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 02:52:21 -0400
Received: from eu1sys200aog105.obsmtp.com ([207.126.144.119]:59659 "EHLO
	eu1sys200aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751781Ab0EGGwT convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 02:52:19 -0400
From: Linus WALLEIJ <linus.walleij@stericsson.com>
To: Steven Liu <lingjiujianke@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 7 May 2010 08:52:12 +0200
Subject: RE: [PATCH] Check kmalloc return value before use the buffer
Thread-Topic: [PATCH] Check kmalloc return value before use the buffer
Thread-Index: AcrtjsQ80p1xLFImSyqhElolBIwLOAAIr2bA
Message-ID: <CEE6BB42CAD6E947908279175AF8470A025A68CE5C@EXDCVYMBSTM006.EQ1STM.local>
References: <v2ubd0d95d71005061941j4f9272d1he7dc9bcf5daa6457@mail.gmail.com>
In-Reply-To: <v2ubd0d95d71005061941j4f9272d1he7dc9bcf5daa6457@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Liu,

> Hi,linus.walleij
> 
>           Check kmalloc return value before use the buffer
> 
> 
> Signed-off-by: LiuQi <lingjiujianke@gmail.com>
> ---
>  arch/arm/mach-u300/dummyspichip.c |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/mach-u300/dummyspichip.c
> b/arch/arm/mach-u300/dummyspichip.c
> index 962f9de..4f2af7c 100644
> --- a/arch/arm/mach-u300/dummyspichip.c
> +++ b/arch/arm/mach-u300/dummyspichip.c
> @@ -63,6 +63,11 @@ static ssize_t dummy_looptest(struct device *dev,
>  		goto out;
>  	}
>  	bigrxbuf_virtual = kmalloc(DMA_TEST_SIZE, GFP_KERNEL);
> +	if (bigtxbuf_virtual == NULL) {
> +		status = -ENOMEM;
> +		kfree(bigtxbuf_virtual);

kfree():ing NULL is OK, but you just checked it to be NULL so why?

> +		goto out;
> +	}
> 
>  	/* Fill TXBUF with some happy pattern */
>  	memset(bigtxbuf_virtual, 0xAA, DMA_TEST_SIZE);

Otherwise the bug it fixes is good to fix.

Yours,
Linus Walleij
