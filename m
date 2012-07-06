Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932161Ab2GFQc1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 12:32:27 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:44108 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757864Ab2GFQcZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 12:32:25 -0400
From: Yuri Khan <yurivkhan@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Yuri Khan <yurivkhan@gmail.com>
Subject: [PATCH 0/1] Input: xpad - Add a variation of Mad Catz Beat Pad
Date: Fri,  6 Jul 2012 23:32:03 +0700
Message-Id: <1341592324-665-1-git-send-email-yurivkhan@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,

I have a dance pad that has the vendor and product IDs of a Mad Catz 
Beat Pad (0738:4540), but it doesn't get handled by xpad.ko because xpad 
expects (a) interface class and subclass of 'X':'B', or (b) interface 
class 255, subclass 93, protocol 1 or 129; while my device identifies as 
interface class 3 (HID), subclass 0, protocol 0. As a result, usbhid 
grabs it and it sort of works, but the diagonal pads are not mapped.

When I add a usbhid option quirks=0x0738:0x4540:0x4 (so that usbhid does 
not attempt to handle this device) and rebuild the xpad module with the 
following patch, the device works as expected. Dmitry Torokhov, the 
current maintainer of input drivers, suggested that I include a change 
to add the usbhid quirk in my patch.

Yuri Khan (1):
  Input: xpad - Add a variation of Mad Catz Beat Pad

 drivers/hid/hid-ids.h           |    3 +++
 drivers/hid/usbhid/hid-quirks.c |    2 ++
 drivers/input/joystick/xpad.c   |    2 ++
 3 files changed, 7 insertions(+)

-- 
1.7.9.5

