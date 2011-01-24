Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752924Ab1AXAhs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jan 2011 19:37:48 -0500
Received: from core.signal11.us ([64.251.29.136]:50753 "EHLO core.signal11.us"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752748Ab1AXAhr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jan 2011 19:37:47 -0500
From: Alan Ott <alan@signal11.us>
To: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, greg@kroah.com,
        stern@rowland.harvard.edu, libusb-devel@lists.sourceforge.net
Cc: Alan Ott <alan@signal11.us>
Subject: [PATCH v3 0/1] HID: Report Descriptor in Sysfs
Date: Sun, 23 Jan 2011 19:36:16 -0500
Message-Id: <1295829377-7731-1-git-send-email-alan@signal11.us>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <20110123225935.GB12488@kroah.com>
References: <20110123225935.GB12488@kroah.com>
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Sun Jan 23 19:37:46 2011
X-DSPAM-Confidence: 0.9899
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 4d3cc9da26381643010366
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is version 3 of the patch, with binary data in the sysfs file instead
of ASCII, as suggested by Alan Stern and Greg KH.  Also now with
documentation.

Original Description:

So I'd like to have access to the HID report descriptor in a sysfs entry, so
I can read it without opening the device.  hid-core seemed like the place to
put it.

Using the /sys/class links, for hidraw devices, this puts a new file,
report_descriptor in the directory:
	/sys/class/hidraw/hidraw0/device/

For my USB device (for example), the new file is in:
	/sys/bus/usb/devices/1-5.3:1.0/0003:046D:C216.0001/

For my Bluetooth device, the new file is in:
	/sys/class/bluetooth/hci0/hci0:11/0005:054C:0268.0002/

I'm not super confident that these file locations are the best place, but I
made a best guess so that it could be discussed.  The current location is
where the hid-core stuff lives.  Is there a reason these directories are
named bus:vendor:product:id (instead of hid-core or something similar)?  Is
there a better way to do this?

Alan.

Alan Ott (1):
  hid: Add HID Report Descriptor to sysfs.

 Documentation/ABI/testing/sysfs-driver-hid |   10 ++++++++
 drivers/hid/hid-core.c                     |   33 ++++++++++++++++++++++++++++
 2 files changed, 43 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-driver-hid


