Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753372Ab0ISH27 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Sep 2010 03:28:59 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:48927 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752357Ab0ISH2j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Sep 2010 03:28:39 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX18/RrIYiP8/4gvLVWL5d7+DHzvJO9vZg36cJ3MaMh
	n104+84tUrRYc5
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
To: linux-fbdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Joseph Chan <JosephChan@via.com.tw>, Jonathan Corbet <corbet@lwn.net>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 12/12] viafb: add documentation for proc interface
Date: Sun, 19 Sep 2010 07:39:57 +0000
Message-Id: <7cc0ccf5d629b9788f86d1e745ac532d5847e2dd.1284879533.git.FlorianSchandinat@gmx.de>
X-Mailer: git-send-email 1.6.3.2
In-Reply-To: <a20caff43626418b91187e476905ebc7cd974701.1284879533.git.FlorianSchandinat@gmx.de>
References: <a20caff43626418b91187e476905ebc7cd974701.1284879533.git.FlorianSchandinat@gmx.de>
In-Reply-To: <cover.1284879532.git.FlorianSchandinat@gmx.de>
References: <cover.1284879532.git.FlorianSchandinat@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

viafb: add documentation for proc interface

This patch adds documentation for the new proc interface that allows
modification of the output device configuration. Should be stable and
useful enough now for daily use.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Joseph Chan <JosephChan@via.com.tw>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 Documentation/fb/viafb.txt |   48 ++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 48 insertions(+), 0 deletions(-)

diff --git a/Documentation/fb/viafb.txt b/Documentation/fb/viafb.txt
index f3e046a..1a2e8aa 100644
--- a/Documentation/fb/viafb.txt
+++ b/Documentation/fb/viafb.txt
@@ -197,6 +197,54 @@ Notes:
        example,
            # fbset -depth 16
 
+
+[Configure viafb via /proc]
+---------------------------
+    The following files exist in /proc/viafb
+
+    supported_output_devices
+
+        This read-only file contains a full ',' seperated list containing all
+        output devices that could be available on your platform. It is likely
+        that not all of those have a connector on your hardware but it should
+        provide a good starting point to figure out which of those names match
+        a real connector.
+        Example:
+        # cat /proc/viafb/supported_output_devices
+
+    iga1/output_devices
+    iga2/output_devices
+
+        These two files are readable and writable. iga1 and iga2 are the two
+        independent units that produce the screen image. Those images can be
+        forwarded to one or more output devices. Reading those files is a way
+        to query which output devices are currently used by an iga.
+        Example:
+        # cat /proc/viafb/iga1/output_devices
+        If there are no output devices printed the output of this iga is lost.
+        This can happen for example if only one (the other) iga is used.
+        Writing to these files allows adjusting the output devices during
+        runtime. One can add new devices, remove existing ones or switch
+        between igas. Essentially you can write a ',' seperated list of device
+        names (or a single one) in the same format as the output to those
+        files. You can add a '+' or '-' as a prefix allowing simple addition
+        and removal of devices. So a prefix '+' adds the devices from your list
+        to the already existing ones, '-' removes the listed devices from the
+        existing ones and if no prefix is given it replaces all existing ones
+        with the listed ones. If you remove devices they are expected to turn
+        off. If you add devices that are already part of the other iga they are
+        removed there and added to the new one.
+        Examples:
+        Add CRT as output device to iga1
+        # echo +CRT > /proc/viafb/iga1/output_devices
+
+        Remove (turn off) DVP1 and LVDS1 as output devices of iga2
+        # echo -DVP1,LVDS1 > /proc/viafb/iga2/output_devices
+
+        Replace all iga1 output devices by CRT
+        # echo CRT > /proc/viafb/iga1/output_devices
+
+
 [Bootup with viafb]:
 --------------------
     Add the following line to your grub.conf:
-- 
1.6.3.2

