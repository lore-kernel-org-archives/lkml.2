Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753600Ab2APIc6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 03:32:58 -0500
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:24325 "EHLO
	TX2EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753509Ab2APIc4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 03:32:56 -0500
X-SpamScore: -9
X-BigFish: VPS-9(zz936eK1432Nzz1202hzzz2dhc1ahc1bh2a8h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:137.71.25.57;KIP:(null);UIP:(null);IPV:NLI;H:nwd2mta2.analog.com;RD:nwd2mail11.analog.com;EFVD:NLI
From: "Hennerich, Michael" <Michael.Hennerich@analog.com>
To: "axel.lin@gmail.com" <axel.lin@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Richard Purdie <rpurdie@rpsys.net>,
        "device-drivers-devel@blackfin.uclinux.org" 
	<device-drivers-devel@blackfin.uclinux.org>
Date: Mon, 16 Jan 2012 08:33:38 +0000
Subject: RE: [PATCH] backlight: Fix the logic to set bits in adp8860_bl and
 adp8870_bl drivers
Thread-Topic: [PATCH] backlight: Fix the logic to set bits in adp8860_bl and
 adp8870_bl drivers
Thread-Index: AczSni1NROKeWaCFTM2zTaf5dSxREQBikDtA
Message-ID: <544AC56F16B56944AEC3BD4E3D59177148736CE09D@LIMKCMBX1.ad.analog.com>
References: <1326442521.5482.1.camel@phoenix>
 <20120113141019.1fc1439e.akpm@linux-foundation.org>
 <CAF+7xW=qATBpVy-wG6+Joq+LB19TmM6qJUxoOV0U7R8omLVrxw@mail.gmail.com>
In-Reply-To: <CAF+7xW=qATBpVy-wG6+Joq+LB19TmM6qJUxoOV0U7R8omLVrxw@mail.gmail.com>
Accept-Language: de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: de-DE, en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
X-OriginatorOrg: analog.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Axel Lin wrote on 2012-01-14:
>>> diff --git a/drivers/video/backlight/adp8860_bl.c
>>> b/drivers/video/backlight/adp8860_bl.c index 66bc74d..378276c 100644
>>> --- a/drivers/video/backlight/adp8860_bl.c +++
>>> b/drivers/video/backlight/adp8860_bl.c @@ -146,7 +146,7 @@ static int
>>> adp8860_set_bits(struct i2c_client *client, int reg, uint8_t bit_mask
>>>
>>>       ret = adp8860_read(client, reg, &reg_val);
>>>
>>> -     if (!ret && ((reg_val & bit_mask) == 0)) { +     if (!ret &&
>>> ((reg_val & bit_mask) != bit_mask)) {               reg_val |=
>>> bit_mask;               ret = adp8860_write(client, reg, reg_val);
>>>   } diff --git a/drivers/video/backlight/adp8870_bl.c
>>> b/drivers/video/backlight/adp8870_bl.c index 6c68a68..6735059 100644
>>> --- a/drivers/video/backlight/adp8870_bl.c +++
>>> b/drivers/video/backlight/adp8870_bl.c @@ -160,7 +160,7 @@ static int
>>> adp8870_set_bits(struct i2c_client *client, int reg, uint8_t bit_mask
>>>
>>>       ret = adp8870_read(client, reg, &reg_val);
>>>
>>> -     if (!ret && ((reg_val & bit_mask) == 0)) {
>>> +     if (!ret && ((reg_val & bit_mask) != bit_mask)) {
>>>               reg_val |= bit_mask;
>>>               ret = adp8870_write(client, reg, reg_val);
>>>       }
>>
>> This patch is applicable to 3.2.x, but I don't know whether to route it
>> to -stable becasue you didn't tell me what effect the patch has :(
>>
>
> It's because I don't have this hardware.
> I just found the bug while reading the code.
>
> I was thinking I should CC stable, but since the code is there for a
> long time
> and I don't know any complains of the bug. So I didn't CC stable.
>
> Michael, do you see any user-visible effects of the bug?

No - This fixes a bug. The code seemed to be working before,
only by accident.


Greetings,
Michael

--
Analog Devices GmbH      Wilhelm-Wagenfeld-Str. 6      80807 Muenchen
Sitz der Gesellschaft: Muenchen; Registergericht: Muenchen HRB 40368;
Geschaeftsfuehrer:Dr.Carsten Suckrow, Thomas Wessel, William A. Martin, Margaret Seif



