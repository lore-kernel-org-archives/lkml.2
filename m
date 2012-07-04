Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756990Ab2GDDpD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 23:45:03 -0400
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:31647
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756956Ab2GDDom (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 23:44:42 -0400
X-Forefront-Antispam-Report: CIP:137.71.25.55;KIP:(null);UIP:(null);IPV:NLI;H:nwd2mta1.analog.com;RD:nwd2mail10.analog.com;EFVD:NLI
X-SpamScore: -7
X-BigFish: VPS-7(zz9371I542M1432Izz1202hzzz2dh2a8h668h839h93fhd25hf0ah)
From: "Zhang, Sonic" <Sonic.Zhang@analog.com>
To: Axel Lin <axel.lin@gmail.com>
CC: Lars-Peter Clausen <lars@metafoo.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lrg@ti.com>
Date: Tue, 3 Jul 2012 23:44:34 -0400
Subject: RE: [PATCH v2] regulator: ad5398: Fix min/max current limit
 boundary checking
Thread-Topic: [PATCH v2] regulator: ad5398: Fix min/max current limit
 boundary checking
Thread-Index: Ac1Zk8Oho+HvrfF5RnairptkSJ03egAA4gCg
Message-ID: <DB904C5425BA6F4E8424B3B51A1414D171408060BB@NWD2CMBX1.ad.analog.com>
References: <1341301353.12050.1.camel@phoenix>
	 <DB904C5425BA6F4E8424B3B51A1414D17140805D85@NWD2CMBX1.ad.analog.com>
	 <4FF2A7F9.3090307@metafoo.de>
	 <DB904C5425BA6F4E8424B3B51A1414D17140805DAB@NWD2CMBX1.ad.analog.com>
	 <4FF2AC24.7090906@metafoo.de>
	 <DB904C5425BA6F4E8424B3B51A1414D17140805DC8@NWD2CMBX1.ad.analog.com>
	 <CAF+7xWk5qQa5nV3OdFM51U1Kh7g9w3dA5mLL+SGRQ7_AFNkp5A@mail.gmail.com>
	 <DB904C5425BA6F4E8424B3B51A1414D17140805E4C@NWD2CMBX1.ad.analog.com>
	 <1341315373.3158.3.camel@phoenix>
	 <DB904C5425BA6F4E8424B3B51A1414D1714080606C@NWD2CMBX1.ad.analog.com>
 <1341371928.25411.2.camel@phoenix>
In-Reply-To: <1341371928.25411.2.camel@phoenix>
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
X-MIME-Autoconverted: from base64 to 8bit by nfs id q643jI92020196



>-----Original Message-----
>From: Axel Lin [mailto:axel.lin@gmail.com]
>Sent: Wednesday, July 04, 2012 11:19 AM
>To: Zhang, Sonic
>Cc: Lars-Peter Clausen; Mark Brown; linux-kernel@vger.kernel.org; Liam
>Girdwood
>Subject: RE: [PATCH v2] regulator: ad5398: Fix min/max current limit boundary
>checking
>
>
>> >That is why we need to add:
>> >if (min_uA < chip->min_uA)
>> >        min_uA = chip->min_uA;
>> >
>>
>> Yes, but if you apply this logic to min_uA, you should apply the same logic to
>max_uA, even though it is not used in your application.
>
>Actually, the logic is the same:
>to find a supported (minmal) current in specified range.
>
>The question is the equation used in current code does not allow
>min_uA < chip->min_uA.
>Setting min_uA = chip->min_uA if min_uA < chip->min_uA does make sense
>because botch request actually returns the same current value.
>( I mean no user visible change )
>
>Adding below logic is not necessary.
>( Note: Adding this or not does not have any user visible change, it's
>just not necessary)
>
>if (max_uA > chip->min_uA)
>        max_uA = chip->max_uA;
>
>It is not necessary because the equation to choose selector does not
>depends on max_uA. No matter if we set max_uA = chip->max_uA or not in
>this case, it does not impact the equation to choose the selector.
>
>But, well, if you really prefer adding it. I'll send a v3 for it.
>Just let me know how do you think.

Yes, v3 please.

Sonic

>
>Regards,
>Axel
>
>

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
