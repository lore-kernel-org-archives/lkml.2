Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753020Ab1ARIFN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 03:05:13 -0500
Received: from core.signal11.us ([64.251.29.136]:47841 "EHLO core.signal11.us"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752796Ab1ARIFJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 03:05:09 -0500
From: Alan Ott <alan@signal11.us>
To: Jiri Kosina <jkosina@suse.cz>, Marcel Holtmann <marcel@holtmann.org>,
        "Gustavo F. Padovan" <padovan@profusion.mobi>,
        "David S. Miller" <davem@davemloft.net>, Alan Ott <alan@signal11.us>,
        Michael Poole <mdpoole@troilus.org>,
        Eric Dumazet <eric.dumazet@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Cc: Alan Ott <alan@signal11.us>
Subject: [PATCH v5 0/4] Adding HID Feature Report Support to hidraw
Date: Tue, 18 Jan 2011 03:04:36 -0500
Message-Id: <1295337880-12452-1-git-send-email-alan@signal11.us>
X-Mailer: git-send-email 1.7.0.4
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Tue Jan 18 03:05:09 2011
X-DSPAM-Confidence: 0.9899
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 4d3549b5166633266611951
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds Feature Report support for USB and Bluetooth HID devices
through hidraw.

The first two patches prepare the bluetooth side for the change.
	a. Make sure the hidp_session() thread is started before
	   device's probe() functions are called.
	b. Wait for ACK/NAK on sent reports, and return proper
	   error codes.
The third patch is the hidraw core and USB changes.
The fourth patch is the Bluetooth changes.

Thanks to Antonio Ospite and Bill Good for providing testing and feedback.


Alan Ott (4):
  bt hidp: Move hid_add_device() call to after hidp_session() has
    started.
  bt hidp: Wait for ACK on Sent Reports
  HID: Add Support for Setting and Getting Feature Reports from hidraw
  Bluetooth hidp: Add support for hidraw HIDIOCGFEATURE and
    HIDIOCSFEATURE

 drivers/hid/hidraw.c          |  106 +++++++++++++++++++-
 drivers/hid/usbhid/hid-core.c |   35 +++++++
 include/linux/hid.h           |    3 +
 include/linux/hidraw.h        |    3 +
 net/bluetooth/hidp/core.c     |  214 ++++++++++++++++++++++++++++++++++++++---
 net/bluetooth/hidp/hidp.h     |   15 +++
 6 files changed, 355 insertions(+), 21 deletions(-)


