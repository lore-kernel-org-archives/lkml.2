Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756135Ab2IJDF3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 23:05:29 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:56907 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753466Ab2IJDF1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 23:05:27 -0400
Message-ID: <1347246319.6908.1.camel@phoenix>
Subject: regulator: fan53555: vsel_max does not match with the max voltage?
From: Axel Lin <axel.lin@gmail.com>
To: Yunfan Zhang <yfzhang@marvell.com>
Cc: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org
Date: Mon, 10 Sep 2012 11:05:19 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Yunfan,
Just found below issue while reading the code:

For FAN53555_CHIP_ID_04,
        di->vsel_min = 603000;
        di->vsel_max = 1411000;
        di->vsel_step = 12826;

So we have below voltage list for FAN53555_CHIP_ID_04:

volt[0] = 603000
volt[1] = 615826
volt[2] = 628652
volt[3] = 641478
volt[4] = 654304
volt[5] = 667130

.......

volt[60] = 1372560
volt[61] = 1385386
volt[62] = 1398212
volt[63] = 1411038

Then volt[63] is greater than the vsel_max now.
This looks does not make sense.

Regards,
Axel

