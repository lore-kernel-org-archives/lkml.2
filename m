Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755398Ab0CWCH4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 22:07:56 -0400
Received: from [12.234.97.163] ([12.234.97.163]:29326 "EHLO
	archaeopteryx.synaptics.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751420Ab0CWCHy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 22:07:54 -0400
From: Christopher Heiny <cheiny@synaptics.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Jean Delvare <khali@linux-fr.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Linux Input <linux-input@vger.kernel.org>,
       Christopher Heiny <cheiny@synaptics.com>,
       Allie Xiong <axiong@synaptics.com>,
       William Manson <wmanson@synaptics.com>
Subject: [RFC PATCH 0/1] input/touchscreen: Synaptics Touchscreen Driver
Date: Mon, 22 Mar 2010 19:07:37 -0700
Message-Id: <1269310058-10894-1-git-send-email-cheiny@synaptics.com>
X-Mailer: git-send-email 1.6.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds an initial driver supporting Synaptics ClearPad
touchscreens that use the RMI4 protocol, as defined here:

http://www.synaptics.com/sites/default/files/511-000136-01_revA.pdf


This patch addresses most of the feedback relating to our previous submission.
Any elements not acted on (such as creation of an 'rmi' bus on the kernel
bus architecture) are captured as TODOs in the code, and will be implemented
in a future submission.  In addition:
    - We think we've resolved all the whitespace issues.  For Kconfig,
      we used the indent pattern used by other modules.  For all other
      sources, we've converted to 8-space hard TAB characters.
    - Some concerns were expressed regarding our I2C implementation.
      Dmitry recommended we contact Jean Delvare for further review,
      so we are cc'ing him on this patch.


This version of the driver does not support all features of the RMI4
protocol yet.  We felt it more important to start with a solid
implementation of the basic functionality, and then build on that base
to support additional features (such as gestures, proximity detection,
capacitive buttons, and so on).

Additionally, as this is our team's first venture into the wonderful
world of kernel submissions, we figured it was important to start out
initially with a fairly simple codebase, just in case we're doing
something horribly wrong.


The significant files in this version of the driver are:
    rmi_core.c
        Implements the basic core of the RMI4 protocol
        including self-discovery of RMI4 functions.  This
        also implements RMI4 function 0x01, which provides
        generic device control.
    rmi_function_11.c
        Implements basic RMI4 function 0x11 (2D sensor)
        features, including multitouch up to 10 fingers.
    rmi_app_touchpad.c
        The major driver functions (mod_init, mod_exit,
        and so on).
An additional file is included, but will eventually be changed/dropped
    rmi_i2c_gta01.c
        Provides platform setup for development.  This will
        be replaced in the future by a generic approach to
        specifying platform parameters.
More detailed descriptions can be found in each file's comments.

We chose to use multiple source files because it makes it easy to add
support for additional RMI4 functions with minimal impact to existing
functions.  Additionally, this supports future changes to the
configuration to allow you to compile in only those RMI4 functions that
you need for your particular device.


There are two existing drivers for similar Synaptics devices in the
current kernel tree (excluding the PS/2 touchpad driver).  These are:

./linux-2.6/drivers/input/mouse/synaptics_i2c.c
      A driver for the Exeda 15mm touchpad, written by Mike Rapoport
      <mike@compulab.co.il> and Igor Grinberg <grinberg@compulab.co.il>

./linux-2.6/drivers/staging/dream/synaptics_i2c_rmi.c
      A driver for the HTC Dream ClearPad, written by Arve Hjønnevåg
      <arve@android.com>

We have not extended these drivers for a couple of reasons.  First, the
two drivers are specific to particular Synaptics products, and it is our
desire to produce a general solution that takes advantage of the 'self
describing' features of products that use the RMI protocol.

Second, and more importantly, is that the existing drivers are written
for an older version of the RMI protocol (aka RMI3) that is being
retired in favor of a more recent and substantially changed version (aka
RMI4).  Most currently shipping Synaptics ClearPads speak the RMI4
protocol, and it will be Synaptics protocol of choice going forward.  In
almost all respects, RMI4 is not backward compatible with RMI3, making
it impractical to support both versions in the same driver.


Comments and other feedback on this driver are welcomed.

Bill Manson
Allie Xiong
Christopher Heiny



---
