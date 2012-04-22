Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751643Ab2DVGCK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2012 02:02:10 -0400
Received: from smtprelay-b11.telenor.se ([62.127.194.20]:53583 "EHLO
	smtprelay-b11.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751018Ab2DVGCH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2012 02:02:07 -0400
X-SENDER-IP: [85.230.169.225]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AkxUAE2ek09V5qnhPGdsb2JhbABEiiqnFhkBAQEBHhkNJ4JmIxgRcQoaiCa5XRORIASbfY0m
X-IronPort-AV: E=Sophos;i="4.75,461,1330902000"; 
   d="scan'208";a="100771128"
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Henrik Rydberg <rydberg@euromail.se>
Subject: [PATCH v2 0/6] hid: Introduce device groups
Date: Sun, 22 Apr 2012 08:05:20 +0200
Message-Id: <1335074726-2276-1-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Here is the second version of the extension to the device-driver
matching mechanism. The previous version did not work well with
out-of-tree drivers. The default group handling was backwards, so I
had better list the right behavior here for easier review. For
starters, drivers belong to one of these groups:

HID_GROUP_ANY - The default for all drivers. Matches any device.
HID_GROUP_GENERIC - The generic drivers. Matches generic devices only.
HID_GROUP_MULTITOUCH - The MT driver. Matches MT devices only.

A HID device is placed in one of the above groups during device
add. The logic is determined by the hid core. It does not matter to
userland which group a device belongs to, because all out-of-tree
drivers and all dynamic device ids belong to the default group, which
matches any device. The device groups only steer udev to the right
module, without loss of generality. In fact, switching drivers in
userland is simplified.

A known outstanding issue is the rebinding of a hid device to a driver
that affects the report parsing. I am currently testing a patchset for
it, which should go in before this one.  However, since it is largely
orthogonal, and it seems the present patchset does the right thing
with regards to everything else, I thought I'd give it another spin
first.

The patches apply to 3.4-rc3; final version will apply for next.

Enjoy,
Henrik

Henrik Rydberg (6):
  hid: Add device group to modalias
  hid: Parse the device before adding it
  hid: Create a generic device group
  hid: Allow bus wildcard matching
  hid-multitouch: Switch to device groups
  hid-multitouch: Remove remnant quirk handling

 drivers/hid/hid-core.c          |  130 ++++++++++++++-------------------------
 drivers/hid/hid-input.c         |   11 ----
 drivers/hid/hid-multitouch.c    |    3 +-
 drivers/hid/usbhid/hid-core.c   |    2 +-
 include/linux/hid.h             |   20 +++---
 include/linux/mod_devicetable.h |    4 +-
 net/bluetooth/hidp/core.c       |    2 +-
 scripts/mod/file2alias.c        |    5 +-
 8 files changed, 71 insertions(+), 106 deletions(-)

-- 
1.7.10

