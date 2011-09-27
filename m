Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754136Ab1I0NGz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 09:06:55 -0400
Received: from mms1.broadcom.com ([216.31.210.17]:2766 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751856Ab1I0NGy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 09:06:54 -0400
X-Server-Uuid: 02CED230-5797-4B57-9875-D5D2FEE4708A
From: "Jeffrey (Sheng-Hui) Chu" <jeffchu@broadcom.com>
To: "Tomoya MORINAGA" <tomoya-linux@dsn.okisemi.com>
cc: "Jean Delvare" <khali@linux-fr.org>, "Ben Dooks" <ben-linux@fluff.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Qi Wang" <qi.wang@intel.com>,
        "yong.y.wang@intel.com" <yong.y.wang@intel.com>,
        "joel.clark@intel.com" <joel.clark@intel.com>,
        "kok.howg.ewe@intel.com" <kok.howg.ewe@intel.com>,
        "toshiharu-linux@dsn.okisemi.com" <toshiharu-linux@dsn.okisemi.com>,
        "Aaron Smith" <aarons@broadcom.com>
Date: Tue, 27 Sep 2011 06:06:46 -0700
Subject: RE: [PATCH 3/7] i2c-eg20t: delete 10bit access processing
Thread-Topic: [PATCH 3/7] i2c-eg20t: delete 10bit access processing
Thread-Index: Acx8qSohfAQ7k4GPQzymCkCemd7jVgAbR+aA
Message-ID: <B6A520E9CD57404AAFC0831E4FB39541A98073B6D2@IRVEXCHCCR02.corp.ad.broadcom.com>
References: <1316591509-4433-1-git-send-email-tomoya-linux@dsn.okisemi.com>
 <1316591509-4433-3-git-send-email-tomoya-linux@dsn.okisemi.com>
 <B6A520E9CD57404AAFC0831E4FB39541A98073AC7E@IRVEXCHCCR02.corp.ad.broadcom.com>
 <4E7A7DBA.3020406@dsn.okisemi.com>
 <B6A520E9CD57404AAFC0831E4FB39541A98073AF26@IRVEXCHCCR02.corp.ad.broadcom.com>
 <4E811338.2030005@dsn.okisemi.com>
In-Reply-To: <4E811338.2030005@dsn.okisemi.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
X-WSS-ID: 629F14743D01898057-01-01
Content-Type: text/plain;
 charset=utf-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id p8RD7A5S024465

http://www.engadget.com/2011/09/26/broadcom-unveils-smaller-more-power-efficient-40nm-nfc-chips/ 

-----Original Message-----
From: Tomoya MORINAGA [mailto:tomoya-linux@dsn.okisemi.com] 
Sent: Monday, September 26, 2011 8:05 PM
To: Jeffrey (Sheng-Hui) Chu
Cc: Jean Delvare; Ben Dooks; linux-i2c@vger.kernel.org; linux-kernel@vger.kernel.org; Qi Wang; yong.y.wang@intel.com; joel.clark@intel.com; kok.howg.ewe@intel.com; toshiharu-linux@dsn.okisemi.com; Aaron Smith
Subject: Re: [PATCH 3/7] i2c-eg20t: delete 10bit access processing

(2011/09/23 2:49), Jeffrey (Sheng-Hui) Chu wrote:
> The device is BCM20791.  Please contact Aaron Smith (aarons@broadcom.com) for evaluation.
Though googling the device, I can't find the device.
Broadcom website too.

>
> By the way, the existing handling of 10-bit address in the patch you intended to delete does not work.  You'll need to fix that before you can test with the device successfully.
>
> For the write operation, it's a easy fix:
>
> @@ -410,25 +408,16 @@ static s32 pch_i2c_writebytes(struct i2c_adapter *i2c_adap,
>   	}
>
>   	if (msgs->flags&  I2C_M_TEN) {
> -		addr_2_msb = ((addr&  I2C_MSB_2B_MSK)>>  7);
> +		addr_2_msb = ((addr&  I2C_MSB_2B_MSK)>>  7)&  0x06;
>
>
> For the read operation, static s32 pch_i2c_readbytes(), you'll need to do a write followed by a restart and a read...  please refer to the i2c spec...
>
> Regards,

Thank you for your indication.
We will update this after supporting 10bit access.

Thanks,
tomoya

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
