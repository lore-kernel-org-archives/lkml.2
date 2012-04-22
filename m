Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751876Ab2DVMSZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2012 08:18:25 -0400
Received: from smtprelay-b21.telenor.se ([195.54.99.212]:39845 "EHLO
	smtprelay-b21.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751403Ab2DVMSY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2012 08:18:24 -0400
X-SENDER-IP: [85.230.169.225]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AkxUADL2k09V5qnhPGdsb2JhbABEiiqnFRkBAQEBHhkNJ4JmIxgRcQoaiCa5XxORIASbfY0m
X-IronPort-AV: E=Sophos;i="4.75,462,1330902000"; 
   d="scan'208";a="319451376"
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Henrik Rydberg <rydberg@euromail.se>
Subject: [PATCH 0/3] hid: Enable report fixup on rebind
Date: Sun, 22 Apr 2012 14:21:37 +0200
Message-Id: <1335097300-11881-1-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

This patchset contains a resolution to the problem with
driver-specific modification of the report descriptor. The core of the
problem lies with the dual semantics of hid_parse_report(), which is
therefore split into two functions. As a consequence, the hid core can
handle the rebind case internally, with no changes to the
drivers. Out-of-tree drivers will work fine as long as they operate in
the same way as the in-kernel drivers.

The first two patches are bug fixes found in the process. I am hoping
for some test feedback on those. The third patch is the main one.

Henrik Rydberg (3):
  hid-hyperv: Do not use hid_parse_report() directly
  hid-logitech: Collect report descriptors before sending
  hid: Handle driver-specific device descriptor in core

 drivers/hid/hid-core.c        |  112 +++++++++++++++++++++++++++++++++--------
 drivers/hid/hid-hyperv.c      |   14 +++++-
 drivers/hid/hid-logitech-dj.c |   71 +++++++++++---------------
 include/linux/hid.h           |   14 ++----
 4 files changed, 135 insertions(+), 76 deletions(-)

-- 
1.7.10

