Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754725Ab2DWKDp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 06:03:45 -0400
Received: from smtprelay-b22.telenor.se ([195.54.99.213]:60594 "EHLO
	smtprelay-b22.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754273Ab2DWKDn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 06:03:43 -0400
X-SENDER-IP: [85.230.169.225]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqxdAMcnlU9V5qnhPGdsb2JhbABEiiqnGRkBAQEBHhkNJ4JmIxgRcQoaiCa5dBORIASbfY0m
X-IronPort-AV: E=Sophos;i="4.75,466,1330902000"; 
   d="scan'208";a="23553109"
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Henrik Rydberg <rydberg@euromail.se>
Subject: [PATCH v3 0/6] hid: Introduce device groups
Date: Mon, 23 Apr 2012 12:07:01 +0200
Message-Id: <1335175627-2270-1-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

Here is the third version of the extension to the device-driver
matching mechanism. AFAICT, there are no outstanding issues. I think
we are getting close. :-)

Building on the report fixup patches, this patchset brings a bit of
transparency to the hid bus, by the addition of device groups.  This
allows a more versatile handling of hid drivers in userland, and
simplifies the logic in the kernel.

In particular, there can be one generic module per device group, and
those modules are handled automatically by udev. Dynamic rebinding of
drivers is fully supported. For instance, to load a special
out-of-tree driver instead of the a generic one, simply unbind the
device and load the new module. One can also keep _all_ generic
drivers as modules, significantly simplifying the process of adding
and testing new features.

And, of course, auto-loading of new multitouch drivers works, since
that was what triggered this patchset to begin with. :-)

The second patch contains a simple descriptor scanner that is
new. The last patch unifies the generic drivers into a single,
loadable module.

Enjoy,
Henrik

Henrik Rydberg (6):
  hid: Add device group to modalias
  hid: Scan the device for group info before adding it
  hid: Allow bus wildcard matching
  hid: Create a generic device group
  hid-multitouch: Switch to device groups
  hid: Create a common generic driver

 drivers/hid/Kconfig             |   12 +++
 drivers/hid/Makefile            |    2 +
 drivers/hid/hid-core.c          |  172 ++++++++++++++++++++-------------------
 drivers/hid/hid-generic.c       |   53 ++++++++++++
 drivers/hid/hid-input.c         |   11 ---
 drivers/hid/hid-multitouch.c    |    3 +-
 drivers/hid/usbhid/hid-core.c   |   16 ----
 include/linux/hid.h             |   20 +++--
 include/linux/mod_devicetable.h |    4 +-
 net/bluetooth/hidp/core.c       |   27 +-----
 scripts/mod/file2alias.c        |    5 +-
 11 files changed, 180 insertions(+), 145 deletions(-)
 create mode 100644 drivers/hid/hid-generic.c

-- 
1.7.10
