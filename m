Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755304Ab2LSAre (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 19:47:34 -0500
Received: from [12.239.217.82] ([12.239.217.82]:56908 "EHLO
	venom.synaptics.com" rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754977Ab2LSArc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 19:47:32 -0500
From: Christopher Heiny <cheiny@synaptics.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Jean Delvare <khali@linux-fr.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Input <linux-input@vger.kernel.org>,
        Christopher Heiny <cheiny@synaptics.com>,
        Allie Xiong <axiong@synaptics.com>, Vivian Ly <vly@synaptics.com>,
        Daniel Rosenberg <daniel.rosenberg@synaptics.com>,
        Alexandra Chin <alexandra.chin@tw.synaptics.com>,
        Joerie de Gram <j.de.gram@gmail.com>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Linus Walleij <linus.walleij@stericsson.com>
Subject: [RFC PATCH 00/05] input: Synaptics RMI4 Touchscreen Driver
Date: Tue, 18 Dec 2012 16:46:31 -0800
Message-Id: <1355877996-1433-1-git-send-email-cheiny@synaptics.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset implements changes based on the synaptics-rmi4 branch of
Dmitry's input tree.  The base for the patchset is Dmitry's commit
0af25383d395fb5ece54b79d12d06138bf8b9836 from 2012-11-28.

Overall this patchset implements the following changes:

* updates to Dmitry's RMI4_CORE structure from his 2012-11-28 patches.
This tries to maintain the same approach as Dmitry's implementation, but
we had to move away from using the bus probe() routine, since it wasn't
possible for that routine to readily determine if it had a struct driver() for
an RMI4 sensor or an RMI4 device.  Otherwise, we've stuck close to Dmitry's
work, which has tidied things up nicely.

* We've renamed the structures rmi_function_handler to rmi_function_driver and
rmi_device to rmi_function_dev, mainly because they actually were being treated
as drivers and devices for individual RMI4 functions, and the previous
terminology was somewhat confusing.

* Moved much of the debugfs stuff to use standard macros.  This required
changing a bunch of bools to u32s.  Debugfs interfaces that handled multiple
values in a single file were NOT changed, because some debug tools depend on
that format.  Once we've udpate those tools, we'll change or remove the
remaining interfaces.

* Many other bools were changed to u8, per Dmitry's request.

* Trivial - file copyright header is updated to be more in line with the rest
of the files under ./input.


We've broken this patch into 6 parts, as follows:
    01 - public header file
    02 - core sensor and bus implementation
    03 - I2C physical layer driver
    04.05 - drivers for individual RMI functions


Hopefully this is the last time we'll have wide-ranging structural changes in
the driver code, and future patchsets can be much smaller and confined to
one or two areas of interest.


Comments and other feedback on this driver are welcomed.

Christopher Heiny and the Synaptics RMI4 driver team

Signed-off-by: Christopher Heiny <cheiny@synaptics.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Jean Delvare <khali@linux-fr.org>
Cc: Linus Walleij <linus.walleij@stericsson.com>
Cc: Joeri de Gram <j.de.gram@gmail.com>

---
