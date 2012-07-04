Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757528Ab2GDC4a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 22:56:30 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:57035 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754426Ab2GDC41 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 22:56:27 -0400
X-Forefront-Antispam-Report: CIP:137.71.25.57;KIP:(null);UIP:(null);IPV:NLI;H:nwd2mta2.analog.com;RD:nwd2mail11.analog.com;EFVD:NLI
X-SpamScore: -7
X-BigFish: VPS-7(zz9371I542M1432Izz1202hzzz2dh2a8h668h839h93fhd25hf0ah)
From: "Zhang, Sonic" <Sonic.Zhang@analog.com>
To: Axel Lin <axel.lin@gmail.com>
CC: Lars-Peter Clausen <lars@metafoo.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lrg@ti.com>
Date: Tue, 3 Jul 2012 22:56:18 -0400
Subject: RE: [PATCH v2] regulator: ad5398: Fix min/max current limit
 boundary checking
Thread-Topic: [PATCH v2] regulator: ad5398: Fix min/max current limit
 boundary checking
Thread-Index: Ac1ZEBRRpUX6tVLWQO6sFUHrs6xQ6AAgEJMw
Message-ID: <DB904C5425BA6F4E8424B3B51A1414D1714080606C@NWD2CMBX1.ad.analog.com>
References: <1341301353.12050.1.camel@phoenix>
	 <DB904C5425BA6F4E8424B3B51A1414D17140805D85@NWD2CMBX1.ad.analog.com>
	 <4FF2A7F9.3090307@metafoo.de>
	 <DB904C5425BA6F4E8424B3B51A1414D17140805DAB@NWD2CMBX1.ad.analog.com>
	 <4FF2AC24.7090906@metafoo.de>
	 <DB904C5425BA6F4E8424B3B51A1414D17140805DC8@NWD2CMBX1.ad.analog.com>
	 <CAF+7xWk5qQa5nV3OdFM51U1Kh7g9w3dA5mLL+SGRQ7_AFNkp5A@mail.gmail.com>
	 <DB904C5425BA6F4E8424B3B51A1414D17140805E4C@NWD2CMBX1.ad.analog.com>
 <1341315373.3158.3.camel@phoenix>
In-Reply-To: <1341315373.3158.3.camel@phoenix>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: zh-CN, en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: analog.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q642uYaP020127



>-----Original Message-----
>From: Axel Lin [mailto:axel.lin@gmail.com]
>Sent: Tuesday, July 03, 2012 7:36 PM
>To: Zhang, Sonic
>Cc: Lars-Peter Clausen; Mark Brown; linux-kernel@vger.kernel.org; Liam
>Girdwood
>Subject: RE: [PATCH v2] regulator: ad5398: Fix min/max current limit boundary
>checking
>
>
>> >The equation to calculate the selector does not depend on max_uA.
>> >So I think we don't need to set the requested max_uA.
>> >
>>
>> But, ad5398_set_current_limit() behaves different for min_uA and max_uA with
>you patch. Is this expected?
>>
>
>What we want is to set the smallest current supported by this hardware
>within the range you requested.
>
>Current code uses below equation to choose selector:
>selector = DIV_ROUND_UP((min_uA - chip->min_uA) * chip->current_level,
>                        range_uA);
>
>With this equation, we need to ensure min_uA >= chip->min_uA,
>otherwise it returns a negative selector.
>
>That is why we need to add:
>if (min_uA < chip->min_uA)
>        min_uA = chip->min_uA;
>

Yes, but if you apply this logic to min_uA, you should apply the same logic to max_uA, even though it is not used in your application.


Sonic

>
>Axel
>

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
