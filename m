Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753446Ab2IXEvl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 00:51:41 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:42241 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752348Ab2IXEvk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 00:51:40 -0400
From: "Mohammed, Afzal" <afzal@ti.com>
To: Mark Jackson <mpfj-list@mimc.co.uk>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
CC: lkml <linux-kernel@vger.kernel.org>
Subject: RE: gpmc_cs_request() causes early boot hang
Thread-Topic: gpmc_cs_request() causes early boot hang
Thread-Index: AQHNmC9WQXyKDMW1okeEKCbWWvFUTZeY7CwA
Date: Mon, 24 Sep 2012 04:51:17 +0000
Message-ID: <C8443D0743D26F4388EA172BF4E2A7A93E9E7628@DBDE01.ent.ti.com>
References: <505CBFAA.3080604@mimc.co.uk>
In-Reply-To: <505CBFAA.3080604@mimc.co.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.170.142]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q8O4plKJ018507

Hi Mark,

On Sat, Sep 22, 2012 at 00:57:38, Mark Jackson wrote:
> I'm developing a beaglebone cape board which requires the use of a GPMC 
> chip select.
> 
> I've chosen GPMC_CS0, and in board-am335xevm.c, I have added the following:-
> 
> static void gpmc_test()
> {
>      unsigned long base = 0x12345678;
>      gpmc_cs_request(0, SZ_16M, &base);
>      printk(KERN_INFO "gpmc base @ 0x%08lx\n", base);
> }
> 
> ... and added a call to gpmc_test() at the end of am335x_evm_init().
> 
> If I try to run this code, the kernel fails to boot, and simply hangs at:-
> 
> Uncompressing Linux... done, booting the kernel.
> 
> If I comment out the call to gpmc_cs_request(), the system boots as 
> expected (but without my required cs).
> 
> I've looked at the use of this call in other board files, and can't see 
> that their code does anything special so I'm stuck on why this simple 
> code fails to work.
> 
> Can anyone shed light on what I'm doing wrong ?
> 
> Do I have to initialise the gpmc beforehand in some way ?

It seems you are using PSP Kernel.

Invoking omap_init_gpmc before gpmc request should help.

Regards
Afzal
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
