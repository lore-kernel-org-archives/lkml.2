Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756663Ab2HVPkv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 11:40:51 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:59960 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752962Ab2HVPks convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 11:40:48 -0400
From: "AnilKumar, Chimata" <anilkumar@ti.com>
To: Chinmay V S <cvs268@gmail.com>
CC: Arnd Bergmann <arnd@arndb.de>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "eric.piel@tremplin-utc.net" <eric.piel@tremplin-utc.net>,
        "jic23@cam.ac.uk" <jic23@cam.ac.uk>, "greg@kroah.com" <greg@kroah.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "dmitry.torokhov@gmail.com" <dmitry.torokhov@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2] lis3lv02d: Add STMicroelectronics lis331dlh digital
 accelerometer
Thread-Topic: [PATCH v2] lis3lv02d: Add STMicroelectronics lis331dlh digital
 accelerometer
Thread-Index: AQHNgC+0NDpTyonaHU+HVTncuJ8wyZdlGIEAgAAPuoCAAFzA0P//wzoAgACtl/A=
Date: Wed, 22 Aug 2012 15:40:25 +0000
Message-ID: <331ABD5ECB02734CA317220B2BBEABC13EA1BDA9@DBDE01.ent.ti.com>
References: <1345617039-27469-1-git-send-email-anilkumar@ti.com>
 <201208220748.39106.arnd@arndb.de>
 <CAK-9PRBy0PCQ4XAVZzQpWv5rnT8A9f6F=qxT=pJEaioN7RN_5w@mail.gmail.com>
 <331ABD5ECB02734CA317220B2BBEABC13EA1B975@DBDE01.ent.ti.com>
 <CAK-9PRBDpxtrxZWL_x9Uz--GMWDN5anyB_fuKtLrvZcLoRR+FQ@mail.gmail.com>
In-Reply-To: <CAK-9PRBDpxtrxZWL_x9Uz--GMWDN5anyB_fuKtLrvZcLoRR+FQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.132.219]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 22, 2012 at 16:09:22, Chinmay V S wrote:
> Hmmm. Interesting. As i understand LIS331DLH provides 16bit data
> irrespective of the full-scale/sensitivity configuration. Hence we
> could effectively map +/-2G to +/-32768(signed 16bit 2's complement).
> According to the current-patch right-shifting the register values by
> 4(i.e. reducing 16bit --> 12bit) will mean that we lose accuracy by
> ~1mG.
> 
> Clearly this will NOT affect use-case like display-orientation in
> smart-phones, but surely medical and industrial applications WILL
> benefit from the additional accuracy by utilising the entire 16-bit
> resolution provided by LIS331DLH hardware.
> 
> I went through the LIS331DLH datasheet/application-note from
> http://www.st.com/internet/analog/product/218132.jsp and i'm a bit
> confused from your statement about +/-2G being 12bit data. Nowhere is
> it mentioned that LIS331DLH provides +/-2G|+/-4G|+/-8G as 12|13|14 bit
> data respectively. Then again i might be wrong...
> 

Look at this application note which talks about the outdata values
for 2G range (page 12/31) http://www.st.com/internet/com/TECHNICAL_RESOURCES/TECHNICAL_LITERATURE/APPLICATION_NOTE/CD00215823.pdf

Corresponding to the 4G and 8G I got the details form older
patches (SHIFT_ADJ_4G and SHIFT_ADJ_8G).
http://driverdev.linuxdriverproject.org/pipermail/devel/2010-November/009685.html

We can easily interpret number of bits for 4G and 8G from 2G
information.

Thanks
AnilKumar
