Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932130Ab2HVKjz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 06:39:55 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:38765 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751964Ab2HVKjx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 06:39:53 -0400
MIME-Version: 1.0
In-Reply-To: <331ABD5ECB02734CA317220B2BBEABC13EA1B975@DBDE01.ent.ti.com>
References: <1345617039-27469-1-git-send-email-anilkumar@ti.com>
 <201208220748.39106.arnd@arndb.de> <CAK-9PRBy0PCQ4XAVZzQpWv5rnT8A9f6F=qxT=pJEaioN7RN_5w@mail.gmail.com>
 <331ABD5ECB02734CA317220B2BBEABC13EA1B975@DBDE01.ent.ti.com>
From: Chinmay V S <cvs268@gmail.com>
Date: Wed, 22 Aug 2012 16:09:22 +0530
Message-ID: <CAK-9PRBDpxtrxZWL_x9Uz--GMWDN5anyB_fuKtLrvZcLoRR+FQ@mail.gmail.com>
Subject: Re: [PATCH v2] lis3lv02d: Add STMicroelectronics lis331dlh digital accelerometer
To: "AnilKumar, Chimata" <anilkumar@ti.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "eric.piel@tremplin-utc.net" <eric.piel@tremplin-utc.net>,
        "jic23@cam.ac.uk" <jic23@cam.ac.uk>, "greg@kroah.com" <greg@kroah.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "dmitry.torokhov@gmail.com" <dmitry.torokhov@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hmmm. Interesting. As i understand LIS331DLH provides 16bit data
irrespective of the full-scale/sensitivity configuration. Hence we
could effectively map +/-2G to +/-32768(signed 16bit 2's complement).
According to the current-patch right-shifting the register values by
4(i.e. reducing 16bit --> 12bit) will mean that we lose accuracy by
~1mG.

Clearly this will NOT affect use-case like display-orientation in
smart-phones, but surely medical and industrial applications WILL
benefit from the additional accuracy by utilising the entire 16-bit
resolution provided by LIS331DLH hardware.

I went through the LIS331DLH datasheet/application-note from
http://www.st.com/internet/analog/product/218132.jsp and i'm a bit
confused from your statement about +/-2G being 12bit data. Nowhere is
it mentioned that LIS331DLH provides +/-2G|+/-4G|+/-8G as 12|13|14 bit
data respectively. Then again i might be wrong...

-- 
regards
ChinmayVS
