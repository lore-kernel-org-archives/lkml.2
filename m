Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752321Ab2GCJve (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 05:51:34 -0400
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:59231
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750869Ab2GCJvc convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 05:51:32 -0400
X-Forefront-Antispam-Report: CIP:137.71.25.57;KIP:(null);UIP:(null);IPV:NLI;H:nwd2mta2.analog.com;RD:nwd2mail11.analog.com;EFVD:NLI
X-SpamScore: -7
X-BigFish: VPS-7(zz9371I542M1432Izz1202hzzz2dh2a8h668h839h944hd25hf0ah)
From: "Zhang, Sonic" <Sonic.Zhang@analog.com>
To: "axel.lin@gmail.com" <axel.lin@gmail.com>
CC: Lars-Peter Clausen <lars@metafoo.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lrg@ti.com>
Date: Tue, 3 Jul 2012 05:51:39 -0400
Subject: RE: [PATCH v2] regulator: ad5398: Fix min/max current limit
 boundary checking
Thread-Topic: [PATCH v2] regulator: ad5398: Fix min/max current limit
 boundary checking
Thread-Index: Ac1ZAHbcKVN9iMTcRQCNmmnvsYjdGQAANqVg
Message-ID: <DB904C5425BA6F4E8424B3B51A1414D17140805E4C@NWD2CMBX1.ad.analog.com>
References: <1341301353.12050.1.camel@phoenix>
 <DB904C5425BA6F4E8424B3B51A1414D17140805D85@NWD2CMBX1.ad.analog.com>
 <4FF2A7F9.3090307@metafoo.de>
 <DB904C5425BA6F4E8424B3B51A1414D17140805DAB@NWD2CMBX1.ad.analog.com>
 <4FF2AC24.7090906@metafoo.de>
 <DB904C5425BA6F4E8424B3B51A1414D17140805DC8@NWD2CMBX1.ad.analog.com>
 <CAF+7xWk5qQa5nV3OdFM51U1Kh7g9w3dA5mLL+SGRQ7_AFNkp5A@mail.gmail.com>
In-Reply-To: <CAF+7xWk5qQa5nV3OdFM51U1Kh7g9w3dA5mLL+SGRQ7_AFNkp5A@mail.gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: zh-CN, en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: analog.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



>-----Original Message-----
>From: Axel Lin [mailto:axel.lin@gmail.com]
>Sent: Tuesday, July 03, 2012 5:44 PM
>To: Zhang, Sonic
>Cc: Lars-Peter Clausen; Mark Brown; linux-kernel@vger.kernel.org; Liam
>Girdwood
>Subject: Re: [PATCH v2] regulator: ad5398: Fix min/max current limit boundary
>checking
>
>>>As long as it is smaller than the maximum requested current, yes. You
>>>request a current range with the regulator API and any value within this
>>>range is fine as the actual output current.
>>>
>>
>> If so, please also set the max_uA as well.
>
>The equation to calculate the selector does not depend on max_uA.
>So I think we don't need to set the requested max_uA.
>

But, ad5398_set_current_limit() behaves different for min_uA and max_uA with you patch. Is this expected?

Sonic

>Current does check the selected current by:
>if (ad5398_calc_current(chip, selector) > max_uA)
>        return -EINVAL;
>
>This ensures the selected current falls within specified range.
>
>Regards,
>Axel


