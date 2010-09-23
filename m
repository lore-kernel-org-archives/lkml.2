Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754969Ab0IWLxY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 07:53:24 -0400
Received: from fanny.its.uu.se ([130.238.4.241]:47519 "EHLO fanny.its.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754528Ab0IWLxX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 07:53:23 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19611.16302.262307.129176@pilspetsen.it.uu.se>
Date: Thu, 23 Sep 2010 13:53:18 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: linux-kernel@vger.kernel.org
Cc: linux-i2c@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: [BUG 2.6.36-rc5] of_i2c.ko <-> i2c-core.ko dependency loop
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Running modules_install from a newly built 2.6.36-rc5 kernel
on my 32-bit PowerMac results in:

WARNING: Module /lib/modules/2.6.36-rc5/kernel/drivers/i2c/busses/i2c-powermac.ko ignored, due to loop
WARNING: Loop detected: /lib/modules/2.6.36-rc5/kernel/drivers/i2c/i2c-core.ko needs of_i2c.ko which needs i2c-core.ko again!
WARNING: Module /lib/modules/2.6.36-rc5/kernel/drivers/i2c/i2c-core.ko ignored, due to loop
WARNING: Module /lib/modules/2.6.36-rc5/kernel/drivers/i2c/i2c-dev.ko ignored, due to loop
WARNING: Module /lib/modules/2.6.36-rc5/kernel/drivers/of/of_i2c.ko ignored, due to loop
WARNING: Module /lib/modules/2.6.36-rc5/kernel/sound/ppc/snd-powermac.ko ignored, due to loop

> grep '.*I2C.*=' .config
CONFIG_OF_I2C=m
CONFIG_I2C=m
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_CHARDEV=m
CONFIG_I2C_POWERMAC=m

I can't say exactly when this started, haven't built kernels on this
box in a while.

/Mikael
