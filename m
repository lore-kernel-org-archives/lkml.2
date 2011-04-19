Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754099Ab1DSCq4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 22:46:56 -0400
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:39758 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753868Ab1DSCqy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 22:46:54 -0400
From: Haojian Zhuang <hzhuang1@marvell.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>
CC: "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dmitry.torokhov@gmail.com" <dmitry.torokhov@gmail.com>,
        "a.zummo@towertech.it" <a.zummo@towertech.it>,
        "johnpol@2ka.mipt.ru" <johnpol@2ka.mipt.ru>,
        "cbou@mail.ru" <cbou@mail.ru>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "lrg@slimlogic.co.uk" <lrg@slimlogic.co.uk>
Date: Mon, 18 Apr 2011 19:42:09 -0700
Subject: RE: [PATCH 13/14] regulator: check name in initialization of max8925
Thread-Topic: [PATCH 13/14] regulator: check name in initialization of
 max8925
Thread-Index: Acv94kxpo/S5Gwx2ShStHEqcKpdtGQAWEuMA
Message-ID: <25B60CDC2F704E4E9D88FFD52780CB4C05CF05B424@SC-VEXCH1.marvell.com>
References: <1303135451-26362-14-git-send-email-haojian.zhuang@marvell.com>
 <20110418142855.GE2466@opensource.wolfsonmicro.com>
 <BANLkTim1QHe-hpyt0yQxKt2SBwtOAPQ3Bg@mail.gmail.com>
 <20110418160424.GG1765@opensource.wolfsonmicro.com>
In-Reply-To: <20110418160424.GG1765@opensource.wolfsonmicro.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p3J2lQTu010881



>-----Original Message-----
>From: Mark Brown [mailto:broonie@opensource.wolfsonmicro.com]
>Sent: 2011Äê4ÔÂ19ÈÕ 12:04 AM
>To: Haojian Zhuang
>Cc: Haojian Zhuang; sameo@linux.intel.com; linux-kernel@vger.kernel.org;
>dmitry.torokhov@gmail.com; a.zummo@towertech.it; johnpol@2ka.mipt.ru;
>cbou@mail.ru; dwmw2@infradead.org; lrg@slimlogic.co.uk
>Subject: Re: [PATCH 13/14] regulator: check name in initialization of
>max8925
>
>On Mon, Apr 18, 2011 at 11:33:34PM +0800, Haojian Zhuang wrote:
>
>> So I want to avoid to use the index and check regulator[] one by one.
>> I use a pointer to link
>> all regulator data together. I just need to check whether the
>> regulator pointer is valid or not.
>
>Why?  I don't understand what the goal of this change is.

Original implementation:
	Max8925_core.c:
		If ((pdata == NULL) || (pdata->regulator[0] == NULL))
			Return -EINVAL;
	Machine driver:
		Platform data:
			.regulator[0]	= xxx
			.regulator[1]	= xxx

	The index of regulator array is id of buck and ldo.
	There's issue in max8925_core.c since we can't assume regulator[0] always declared in machine driver.

Current implementation:
	Max8925_core.c:
		If ((pdata == NULL) || (pdata->regulator == NULL))
			Return -EINVAL;
	Machine driver:
		Platform data:
			Use two parameters: num_regulators and regulator pointer. The index of new regulator array isn't id of buck and ldo any more.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
