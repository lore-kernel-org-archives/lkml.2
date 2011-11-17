Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756892Ab1KQL3H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 06:29:07 -0500
Received: from mail-wy0-f202.google.com ([74.125.82.202]:58387 "EHLO
	mail-wy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756494Ab1KQL3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 06:29:04 -0500
X-Greylist: delayed 304 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Nov 2011 06:29:04 EST
From: Daniel Kurtz <djkurtz@chromium.org>
To: jkosina@suse.cz, oneukum@suse.de, bleung@chromium.org
Cc: stern@rowland.harvard.edu, olofj@chromium.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Daniel Kurtz <djkurtz@chromium.org>
Subject: [PATCH 0/3 v2] usb/hid-core: drain URB queue when going to suspend
Date: Thu, 17 Nov 2011 19:23:47 +0800
Message-Id: <1321529030-7845-1-git-send-email-djkurtz@chromium.org>
X-Mailer: git-send-email 1.7.3.1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In some situations, trying to suspend a laptop with an attached USB keyboard
would fail if both NumLock and CapsLock LEDs were lit.
This was due to a race condition between asynchronously submitted
LED-manipulating CTRL URBs and the suspend process.

This is a different solution to the same problem highlighted here:
https://lkml.org/lkml/2011/9/2/391

These patches are against Jiri's hid/for-next branch.

Daniel Kurtz (3):
  HID: usbhid: remove LED_ON
  HID: usbhid: hid-core: submit queued urbs before suspend
  HID: usbhid: defer LED setting to a workqueue

Differences since v1:
  * Rebase on hid/for-next
  * Solve race with usbhid_stop() [reported by Oliver Neukum]

 drivers/hid/hid-input.c       |   42 +++++++
 drivers/hid/usbhid/hid-core.c |  241 ++++++++++++++++++++++++-----------------
 drivers/hid/usbhid/usbhid.h   |    3 +-
 include/linux/hid.h           |    2 +
 4 files changed, 187 insertions(+), 101 deletions(-)

-- 
1.7.3.1

