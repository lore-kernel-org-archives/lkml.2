Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757498Ab2HWLPf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 07:15:35 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:55165 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751387Ab2HWLPb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 07:15:31 -0400
From: "AnilKumar, Chimata" <anilkumar@ti.com>
To: Chinmay V S <cvs268@gmail.com>
CC: "carmine.iascone@st.com" <carmine.iascone@st.com>,
        Arnd Bergmann <arnd@arndb.de>,
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
Thread-Index: AQHNgC+0NDpTyonaHU+HVTncuJ8wyZdlGIEAgAAPuoCAAFzA0P//wzoAgADFFbiAASUWTYAAAPYw
Date: Thu, 23 Aug 2012 11:15:09 +0000
Message-ID: <331ABD5ECB02734CA317220B2BBEABC13EA1EBF5@DBDE01.ent.ti.com>
References: <1345617039-27469-1-git-send-email-anilkumar@ti.com>
 <201208220748.39106.arnd@arndb.de>
 <CAK-9PRBy0PCQ4XAVZzQpWv5rnT8A9f6F=qxT=pJEaioN7RN_5w@mail.gmail.com>
 <331ABD5ECB02734CA317220B2BBEABC13EA1B975@DBDE01.ent.ti.com>
 <CAK-9PRBDpxtrxZWL_x9Uz--GMWDN5anyB_fuKtLrvZcLoRR+FQ@mail.gmail.com>
 <331ABD5ECB02734CA317220B2BBEABC13EA1BDA9@DBDE01.ent.ti.com>
 <CAK-9PRD6FH=5g0SrVcw+81Witpo8zRfvnsmGaePaA4swjHWkSw@mail.gmail.com>
 <331ABD5ECB02734CA317220B2BBEABC13EA1EA53@DBDE01.ent.ti.com>
 <CAK-9PRCe3Q0Tjn1qNdzkVcrPmUm_BPQowDgKE4+wVu5T-SVTZQ@mail.gmail.com>
In-Reply-To: <CAK-9PRCe3Q0Tjn1qNdzkVcrPmUm_BPQowDgKE4+wVu5T-SVTZQ@mail.gmail.com>
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

Chinmay,

On Thu, Aug 23, 2012 at 15:53:10, Chinmay V S wrote:
> > Note from datasheet, "1LSb=4g/4096 at 12bit representation,
> > ±2g Full-scale"
> 
> Precisely my point. All the datasheet says is :
> 1. It is +/-2G mode --> so Numerator is 4G.
> 2. We are using 12bits --> so Denominator is 2^12 = 4096.
> 
> There is no clear reason/justification as to why 12bits was chosen in
> the first place. At this point unless someone from the
> design/original-driver team actually confirms why the 12bit
> representation was chosen, it is all conjecture on our part.
> 
> If you have the actual LIS331DLH hardware, can you verify if the lower
> 4bits do actually contain any data (or are they always zero). This
> will help us decide whether to use them(16bit mode) or discard
> them(12bit mode)?...
> 

This is the outdata of accelerometer

root@am335xevm:~# cat /sys/devices/platform/lis3lv02d/position
[   16.323852] lis3lv02d: hi 0x1    low 0x50   val 0x15
[   16.329742] lis3lv02d: hi 0x0    low 0x0    val 0x0
[   16.335052] lis3lv02d: hi 0x3e   low 0x50   val 0x3e5
(20,0,973)
root@am335xevm:~# cat /sys/devices/platform/lis3lv02d/position
[   25.777343] lis3lv02d: hi 0x2    low 0xa0   val 0x2a
[   25.783203] lis3lv02d: hi 0xc1   low 0xf0   val 0xfffffc1f
[   25.790130] lis3lv02d: hi 0xfd   low 0x50   val 0xffffffd5
(41,-969,-41)
root@am335xevm:~# cat /sys/devices/platform/lis3lv02d/position
[   47.607330] lis3lv02d: hi 0xc0   low 0x60   val 0xfffffc06
[   47.613464] lis3lv02d: hi 0xfd   low 0x90   val 0xffffffd9
[   47.619934] lis3lv02d: hi 0x2    low 0x40   val 0x24
(-994,-38,35)

Lower nibble always "0"

Regards
AnilKumar
