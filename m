Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933777Ab2HWKBW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 06:01:22 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:36149 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932133Ab2HWKBR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 06:01:17 -0400
From: "AnilKumar, Chimata" <anilkumar@ti.com>
To: Chinmay V S <cvs268@gmail.com>,
        "carmine.iascone@st.com" <carmine.iascone@st.com>
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
Thread-Index: AQHNgC+0NDpTyonaHU+HVTncuJ8wyZdlGIEAgAAPuoCAAFzA0P//wzoAgADFFbiAAQcWsA==
Date: Thu, 23 Aug 2012 10:00:54 +0000
Message-ID: <331ABD5ECB02734CA317220B2BBEABC13EA1EA53@DBDE01.ent.ti.com>
References: <1345617039-27469-1-git-send-email-anilkumar@ti.com>
 <201208220748.39106.arnd@arndb.de>
 <CAK-9PRBy0PCQ4XAVZzQpWv5rnT8A9f6F=qxT=pJEaioN7RN_5w@mail.gmail.com>
 <331ABD5ECB02734CA317220B2BBEABC13EA1B975@DBDE01.ent.ti.com>
 <CAK-9PRBDpxtrxZWL_x9Uz--GMWDN5anyB_fuKtLrvZcLoRR+FQ@mail.gmail.com>
 <331ABD5ECB02734CA317220B2BBEABC13EA1BDA9@DBDE01.ent.ti.com>
 <CAK-9PRD6FH=5g0SrVcw+81Witpo8zRfvnsmGaePaA4swjHWkSw@mail.gmail.com>
In-Reply-To: <CAK-9PRD6FH=5g0SrVcw+81Witpo8zRfvnsmGaePaA4swjHWkSw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.132.219]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 22, 2012 at 22:24:10, Chinmay V S wrote:
> > Look at this application note which talks about the outdata values
> > for 2G range (page 12/31) http://www.st.com/internet/com/TECHNICAL_RESOURCES/TECHNICAL_LITERATURE/APPLICATION_NOTE/CD00215823.pdf
> 
> Had been through the application note earlier. The table5 (on page 12)
> that you refer to, does NOT contradict either 12/16bit, as in all the
> examples the lower 4 bits are zero. So i don't see how one can assume
> from these examples that for +/-2G they one should consider 12/16bits.
> A nice side-effect of using 12|13|14bits for +/-2|4|8G is that the
> values returned by the driver are in mG in all the 3 modes.
> 
> > Corresponding to the 4G and 8G I got the details form older
> > patches (SHIFT_ADJ_4G and SHIFT_ADJ_8G).
> > http://driverdev.linuxdriverproject.org/pipermail/devel/2010-November/009685.html
> >
> > We can easily interpret number of bits for 4G and 8G from 2G
> > information.
> 
> Going through the code of this driver i can see what you are talking
> about. Depending on the full-scale-range the device is being
> configured for, the number of bits used to represent acceleration in
> the driver is changed.
> 
> Again judging from the code, the driver is always returning
> acceleration at a constant accuracy i.e. 1mG in all the 3 modes
> (+/-2|4|8G)i.e.
> +/-2G is mode means value can be anywhere from +/-2048mG,
> (requiring 12bits.)
> +/-4G in the range of +/-4096mG, requiring 13bits.
> +/-8G i.e. +/-8192mG, requiring 14bits.
> 
> Was this done...
> 
> a. ...because LIS331DLH's theoretical MAX accuracy is ~1mG
> If yes, then using 12bits is fine.
> 

Note from datasheet, "1LSb=4g/4096 at 12bit representation,
±2g Full-scale"

>From this I understood that ±2G full scale value is 12 bits.
That is one more reason to take 12bit value.

Regards
AnilKumar
