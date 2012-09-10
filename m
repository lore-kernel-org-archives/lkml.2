Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756351Ab2IJDUU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 23:20:20 -0400
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:36452 "EHLO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755074Ab2IJDUR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 23:20:17 -0400
From: Yunfan Zhang <yfzhang@marvell.com>
To: Axel Lin <axel.lin@gmail.com>
CC: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Sun, 9 Sep 2012 20:17:55 -0700
Subject: RE: regulator: fan53555: vsel_max does not match with the max
 voltage?
Thread-Topic: regulator: fan53555: vsel_max does not match with the max
 voltage?
Thread-Index: Ac2PASFGgAKtLhVnSZGhzYbmE4JqjgAAS4Kg
Message-ID: <4737A960563B524DA805CA602BE04B3064CC59077C@SC-VEXCH2.marvell.com>
References: <1347246319.6908.1.camel@phoenix>
In-Reply-To: <1347246319.6908.1.camel@phoenix>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: zh-CN, en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q8A3KPv0015596

> -----Original Message-----
> From: Axel Lin [mailto:axel.lin@gmail.com]
> Sent: 2012å¹´9æœˆ10æ—¥ 11:05
> To: Yunfan Zhang
> Cc: Liam Girdwood; Mark Brown; linux-kernel@vger.kernel.org
> Subject: regulator: fan53555: vsel_max does not match with the max voltage?
> 
> Hi Yunfan,
> Just found below issue while reading the code:
> 
> For FAN53555_CHIP_ID_04,
>         di->vsel_min = 603000;
>         di->vsel_max = 1411000;
>         di->vsel_step = 12826;
> volt[63] = 1411038
> 
> Then volt[63] is greater than the vsel_max now.
> This looks does not make sense.

Axel, Thanks for your findings! 
Yes, the volt[63] is GT the vsel_max. Actually vsel_max is not used... The max voltage will be bounded by desc->n_voltages. I will make a patch to remove it to avoid confusing. Thanks a lot!
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
