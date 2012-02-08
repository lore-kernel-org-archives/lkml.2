Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755373Ab2BHDZa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 22:25:30 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:57006 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752301Ab2BHDZ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 22:25:28 -0500
From: Che-Liang Chiou <clchiou@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
        Che-Liang Chiou <clchiou@chromium.org>
Subject: [PATCH 0/5] Input: serio_raw - add monitor/replay debugging interface
Date: Wed,  8 Feb 2012 11:24:52 +0800
Message-Id: <1328671497-20880-1-git-send-email-clchiou@chromium.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1328084386-31110-1-git-send-email-clchiou@chromium.org>
References: <1328084386-31110-1-git-send-email-clchiou@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The serio_raw driver is designed to provide "raw access" to mice, keyboards
etc; thus, a driver accessing serio_raw may live entirely in userland.

However, serio_raw lacks testability.  It is practically impossible to do
regression tests on changes to a serio_raw -based userland driver.  On the other
hand, the kernel's input subsystem has good testability support.  With the help
of tools like utouch-evemu, we may capture and replay input events for evdev
drivers in regression tests.

This patchset contains extensions to the serio_raw driver which add debugfs
entries for monitoring and replaying byte sequence between a userland driver
and device.  These byte sequences can be used in regression tests of the
userland driver.  This patchset closes the gap between serio_raw and the input
subsystem regarding testability.

This patchset is successfully applied on kernel version 3.3-rc2.

Che-Liang Chiou (5):
  Input: serio_raw - return proper result when serio_raw_read fails
  Input: serio_raw - extract queue interface
  Input: serio_raw - factor out common pattern of write
  Input: serio_raw - add debugfs interface
  Input: serio_raw - implement debugfs interface

 drivers/input/serio/serio_raw.c |  394 +++++++++++++++++++++++++++++++++------
 1 files changed, 337 insertions(+), 57 deletions(-)

-- 
1.7.7.3

