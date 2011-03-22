Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755289Ab1CVIRN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 04:17:13 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:41577 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755122Ab1CVIRK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 04:17:10 -0400
X-IronPort-AV: E=Sophos;i="4.63,224,1299474000"; 
   d="scan'208";a="30614151"
From: "Hennerich, Michael" <Michael.Hennerich@analog.com>
To: "Cai, Cliff" <Cliff.Cai@analog.com>, Jonathan Cameron <jic23@cam.ac.uk>
CC: "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Drivers <Drivers@analog.com>,
        "device-drivers-devel@blackfin.uclinux.org" 
	<device-drivers-devel@blackfin.uclinux.org>,
        Cliff Cai <cliff@analog.com>
Date: Tue, 22 Mar 2011 08:16:53 +0000
Subject: RE: [PATCH RESEND v2]IIO driver for Analog Devices Digital Output
 Gyroscope ADXRS450
Thread-Topic: [PATCH RESEND v2]IIO driver for Analog Devices Digital Output
 Gyroscope ADXRS450
Thread-Index: Acvn7uiiVPkrIiCsR/yxiW16KskFDAAcjuggAAGDjfA=
Message-ID: <544AC56F16B56944AEC3BD4E3D5917713754315B05@LIMKCMBX1.ad.analog.com>
References: <1300526846-27183-1-git-send-email-cliff.cai@analog.com>
 <4D878D8B.6070902@cam.ac.uk>
 <DB904C5425BA6F4E8424B3B51A1414D167E03359CD@NWD2CMBX1.ad.analog.com>
In-Reply-To: <DB904C5425BA6F4E8424B3B51A1414D167E03359CD@NWD2CMBX1.ad.analog.com>
Accept-Language: de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: de-DE, en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p2M8HhSB005277

Cai, Cliff wrote on 2011-03-22:
>
>
>> -----Original Message-----
>> From: Jonathan Cameron [mailto:jic23@cam.ac.uk]
>> Sent: 2011å¹´3æœˆ22æ—¥ 1:40
>> To: Cai, Cliff
>> Cc: linux-iio@vger.kernel.org; linux-kernel@vger.kernel.org; Drivers;
>> device-drivers-devel@blackfin.uclinux.org; Cliff Cai
>> Subject: Re: [PATCH RESEND v2]IIO driver for Analog Devices Digital
>> Output Gyroscope ADXRS450
>>
>> On 03/19/11 09:27, cliff.cai@analog.com wrote:
>>> From: Cliff Cai <cliff.cai@analog.com>
>>>
>>> Change v2:v1:
>>>
>>> Make modification according to Michael Hennerich's comments,
>>> correct the spi transfer way,use existing sysfs interfaces.
>> Hi Cliff,
>>
>> As you are proposing a couple of new interfaces we need to have
>> documentation for them. They are quad and dynamic_null_correction. We
>> need to first establish whether they are of general utility and hence
>> should be in the main abi doc. The quadrature one isn't something I've
>> seen before. Is it common in gyros?
>
> I'm not sure about this.
> Michael,do you have any ideas?

The ADXRS450 is a quite new part and features a new sensor design -
So I don't think the quadrature error is to date very common.
It might become in future...

>From the datasheet:

"The quad sensor design rejects linear and angular
acceleration, including external g-forces and vibration. This is
achieved by mechanically coupling the four sensing structures
such that external g-forces appear as common-mode signals
that can be removed by the fully differential architecture implemented in the ADXRS450."

"The quad memory registers contain a value corresponding to the amount of
quadrature error present in the device at a given time.
Quadrature can be likened to a measurement of the error of the motion of the
resonator structure, and can be caused by stresses and aging effects.
The quadrature data is filtered to 80 Hz and can be read frequently to
detect sudden shifts in the level of quadrature.
The data is presented as a 16-bit, twos complement number."

>
>> Dynamic null correction looks like it should be gyro_z_calibbias to
>> me but I could be wrong.  The doc says "
>> The user can make small adjustments to the rateout of the device by
>> asserting these bits. This 10-bit register allows the user to adjust
>> the static rateout of the device by up to Â±6.4Â°/sec.
>> "
>>
>> which makes me think it is an internally applied offset on the output
>> signal and hence calibbias in our abi.
>
> Thanks
>
>> Other than that, various minor nitpicks inline.
>>
>> Jonathan

Greetings,
Michael

--
Analog Devices GmbH      Wilhelm-Wagenfeld-Str. 6      80807 Muenchen
Sitz der Gesellschaft: Muenchen; Registergericht: Muenchen HRB 40368; Geschaeftsfuehrer:Dr.Carsten Suckrow, Thomas Wessel, William A. Martin, Margaret Seif

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
