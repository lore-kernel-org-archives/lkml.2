Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753891Ab2HVIpi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 04:45:38 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:62760 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755889Ab2HVIp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 04:45:27 -0400
MIME-Version: 1.0
In-Reply-To: <201208220748.39106.arnd@arndb.de>
References: <1345617039-27469-1-git-send-email-anilkumar@ti.com> <201208220748.39106.arnd@arndb.de>
From: Chinmay V S <cvs268@gmail.com>
Date: Wed, 22 Aug 2012 14:14:55 +0530
Message-ID: <CAK-9PRBy0PCQ4XAVZzQpWv5rnT8A9f6F=qxT=pJEaioN7RN_5w@mail.gmail.com>
Subject: Re: [PATCH v2] lis3lv02d: Add STMicroelectronics lis331dlh digital accelerometer
To: AnilKumar Ch <anilkumar@ti.com>
Cc: Arnd Bergmann <arnd@arndb.de>, gregkh@linuxfoundation.org,
        eric.piel@tremplin-utc.net, jic23@cam.ac.uk, greg@kroah.com,
        akpm@linux-foundation.org, broonie@opensource.wolfsonmicro.com,
        dmitry.torokhov@gmail.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

A few nitpicks.

> + * LIS3331DLH spec says 1LSBs corresponds 4G/1024 -> 1LSB is 1000/1024 mG.
> + * Sensitivity values for +/-2G, outdata in 12 bits for +/-2G scale. so 4
> + * bits adjustment is required
Shouldn't it be "1LSB is 4000/1024 mG" ?
Also "outdata in 12bits" (typo. in->is?)

On a more technical note, now that LIS3331DLH has 16bit resolution,
why don't we simply return the entire 16-bit value in
lis3lv02d_read_16(). The fact that lis3lv02d_read_16() has 16-bit
resolution can be indicated by

@@ -954,6 +984,16 @@ int lis3lv02d_init_device(struct lis3lv02d *lis3)
                lis3->odr_mask = CTRL1_ODR0|CTRL1_ODR1|CTRL1_ODR2|CTRL1_ODR3;
                lis3->scale = LIS3_SENSITIVITY_8B;
                break;
+       case WAI_3DLH:
+               pr_info("16 bits 3DLH sensor found\n");
+               lis3->read_data = lis3lv02d_read_16;
+               lis3->mdps_max_val = 32768; /* 16 bits for +/-2G */


-- 
regards
CVS
