Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754691Ab1LVCUc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 21:20:32 -0500
Received: from [12.239.217.82] ([12.239.217.82]:9459 "EHLO venom.synaptics.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754667Ab1LVCU3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 21:20:29 -0500
X-Greylist: delayed 592 seconds by postgrey-1.27 at vger.kernel.org; Wed, 21 Dec 2011 21:20:28 EST
From: Christopher Heiny <cheiny@synaptics.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Jean Delvare <khali@linux-fr.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Input <linux-input@vger.kernel.org>,
        Christopher Heiny <cheiny@synaptics.com>,
        Joerie de Gram <j.de.gram@gmail.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>
Subject: [RFC PATCH 00/11] input: Synaptics RMI4 Touchscreen Driver
Date: Wed, 21 Dec 2011 18:09:51 -0800
Message-Id: <1324519802-23894-1-git-send-email-cheiny@synaptics.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements a driver supporting Synaptics ClearPad and other
touchscreen sensors that use the RMI4 protocol, as defined here:

    http://www.synaptics.com/sites/default/files/511-000136-01-Rev-E-RMI4%20Intrfacing%20Guide.pdf

as well as successor documents that haven't made their way through to
publication yet.

This code represents a complete refactoring and rewrite of the previously
submitted patches, and supersedes all those patches.  We believe that all
outstanding issues arising from the previous submissions have been addressed.
However, because of the quantity of new code, we are submitting this patch
as an RFC and requesting feedback from the kernel community.


This patch is against the v2.6.38 tag of Linus' kernel tree, commit
521cb40b0c44418a4fd36dc633f575813d59a43d.


Included in this patch are:
    - full support for an RMI virtual bus as a standard kernel bus

    - physical layer implementations for I2C and SPI

    - function implementations for the following RMI4 functions:
        * F01 device control
        * F09 self test (aka BIST)
        * F11 multifinger pointing
        * F19 capacitive buttons
        * F34 device reflash
        * F54 analog data reporting

    - character device access to the RMI4 register map via rmidev

    - deletion of more legacy code and behavior

The driver supports a system having one or more RMI sensors attached to it.
Most devices have just a single touch sensor, but some have more than one.
An example is the Fuse concept phone, which has 4 RMI sensors in it.

Each sensor is presented as a device on the RMI logical bus (/sys/bus/rmi).
Devices are named/numbered in the order they are discovered on the bus,
starting with /sys/bus/rmi/devices/sensor00 for the first once, .../sensor01
for the second one, and so on.

Individual RMI functions are presented as child devices of the sensor device.
For example, sensor00/fn01, sensor00/fn11, and so on.  Control of an RMI
function's operating parameters is implemented via sysfs.

For diagnostic purposes, the rmidev interface is provided.  This implements
a character device (/dev/rmi0, and so on) that provides flat file access to
the RMI4 register map.  For more information, see the file
Documentation/input/rmidev.txt.


Due to the large amount of code, we've broken this patch into 11 parts, as
follows:
    01 - header files and documenation
    02 - core sensor and bus implementation
    03 - physical layer drivers
    04 - Kconfigs and Makefiles
    05 - rmidev
    06..11 - drivers for individual RMI functions


Comments and other feedback on this driver are welcomed.

Christopher Heiny and the Synaptics RMI4 driver team

Signed-off-by: Christopher Heiny <cheiny@synaptics.com>

Cc: Jean Delvare <khali@linux-fr.org>
Cc: Linus Walleij <linus.walleij@stericsson.com>
Cc: Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>
Cc: Joeri de Gram <j.de.gram@gmail.com>

---
