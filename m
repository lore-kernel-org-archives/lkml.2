Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753231Ab1IVRt5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 13:49:57 -0400
Received: from mms2.broadcom.com ([216.31.210.18]:4602 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751684Ab1IVRtz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 13:49:55 -0400
X-Server-Uuid: D3C04415-6FA8-4F2C-93C1-920E106A2031
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
Date: Thu, 22 Sep 2011 10:49:39 -0700
Subject: RE: [PATCH 3/7] i2c-eg20t: delete 10bit access processing
Thread-Topic: [PATCH 3/7] i2c-eg20t: delete 10bit access processing
Thread-Index: Acx4vIbyvZ2J7T+mS1665n3FArJG7QAkY9Mw
Message-ID: <B6A520E9CD57404AAFC0831E4FB39541A98073AF26@IRVEXCHCCR02.corp.ad.broadcom.com>
References: <1316591509-4433-1-git-send-email-tomoya-linux@dsn.okisemi.com>
 <1316591509-4433-3-git-send-email-tomoya-linux@dsn.okisemi.com>
 <B6A520E9CD57404AAFC0831E4FB39541A98073AC7E@IRVEXCHCCR02.corp.ad.broadcom.com>
 <4E7A7DBA.3020406@dsn.okisemi.com>
In-Reply-To: <4E7A7DBA.3020406@dsn.okisemi.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
X-WSS-ID: 6265A9275IS11091039-01-01
Content-Type: text/plain;
 charset=utf-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id p8MHoBLf000496

The device is BCM20791.  Please contact Aaron Smith (aarons@broadcom.com) for evaluation.  

By the way, the existing handling of 10-bit address in the patch you intended to delete does not work.  You'll need to fix that before you can test with the device successfully. 

For the write operation, it's a easy fix:

@@ -410,25 +408,16 @@ static s32 pch_i2c_writebytes(struct i2c_adapter *i2c_adap,
 	}
 
 	if (msgs->flags & I2C_M_TEN) {
-		addr_2_msb = ((addr & I2C_MSB_2B_MSK) >> 7);
+		addr_2_msb = ((addr & I2C_MSB_2B_MSK) >> 7) & 0x06;


For the read operation, static s32 pch_i2c_readbytes(), you'll need to do a write followed by a restart and a read...  please refer to the i2c spec...

Regards,

-Jeffrey

-----Original Message-----
From: Tomoya MORINAGA [mailto:tomoya-linux@dsn.okisemi.com] 
Sent: Wednesday, September 21, 2011 8:14 PM
To: Jeffrey (Sheng-Hui) Chu
Cc: Jean Delvare; Ben Dooks; linux-i2c@vger.kernel.org; linux-kernel@vger.kernel.org; Qi Wang; yong.y.wang@intel.com; joel.clark@intel.com; kok.howg.ewe@intel.com; toshiharu-linux@dsn.okisemi.com
Subject: Re: [PATCH 3/7] i2c-eg20t: delete 10bit access processing

(2011/09/22 0:42), Jeffrey (Sheng-Hui) Chu wrote:

 > There is i2c device coming out that uses 10-bit address.
Thank you for your information.
We want to test 10-bit mode using the device.
So let me know the device information ?

Anyway, Now, kernel i2c-core is EXPERIMENTAL stage for 10-bit mode like below.

   (Documentation/i2c/ten-bit-addresses)
    WARNING! The current 10 bit address support is EXPERIMENTAL. There
   are several places in the code that will cause SEVERE PROBLEMS with
   10 bit addresses, even though there is some basic handling and
   hooks. Also,
   almost no supported adapter handles the 10 bit addresses correctly.

   As soon as a real 10 bit address device is spotted 'in the wild', we
   can and will add proper support. Right now, 10 bit address devices
   are defined by the I2C protocol, but we have never seen a single
   device which supports them.

After kernel supports 10bit-mode formally, we will add the function  to i2c-eg20t again.

Thanks,
tomoya

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
