Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753326Ab2LDP2S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 10:28:18 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:42161 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751728Ab2LDP2O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 10:28:14 -0500
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Jean Delvare <khali@linux-fr.org>,
        linux-input@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 00/14] i2c-hid cleanup and bug fixes
Date: Tue,  4 Dec 2012 16:27:41 +0100
Message-Id: <1354634875-5182-1-git-send-email-benjamin.tissoires@gmail.com>
X-Mailer: git-send-email 1.8.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

Jean made a recent review of i2c-hid, and before this driver goes into
Linus' tree, here are some cleanups.

Patch 2 has not been detected by Jean, but it appeared while playing with
buffers allocation. So this is the only change not asked by the previous
review.

I still need to work on the mutex to protect the potential race on .open and
.close, but meanwhile, here is a first batch of patches.

Cheers,
Benjamin

Benjamin Tissoires (14):
  HID: i2c-hid: change I2C name
  HID: i2c-hid: fix memory corruption due to missing hid declarations
  HID: i2c-hid: enhance Kconfig
  HID: i2c-hid: fix checkpatch.pl warning
  HID: i2c-hid: fix i2c_hid_dbg macro
  HID: i2c-hid: remove unused static declarations
  HID: i2c-hid: fix return paths
  HID: i2c-hid: fix error messages
  HID: i2c-hid: i2c_hid_get_report may fail
  HID: i2c-hid: reorder allocation/free of buffers
  HID: i2c-hid: remove unneeded test in i2c_hid_remove
  HID: i2c-hid: remove extra .irq field in struct i2c_hid
  HID: i2c-hid: also call i2c_hid_free_buffers in i2c_hid_remove
  HID: i2c-hid: fix i2c_hid_get_raw_report count mismatches

 drivers/hid/i2c-hid/Kconfig   |   7 +-
 drivers/hid/i2c-hid/i2c-hid.c | 184 ++++++++++++++++++++----------------------
 2 files changed, 89 insertions(+), 102 deletions(-)

-- 
1.8.0.1

