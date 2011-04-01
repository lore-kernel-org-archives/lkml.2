Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756838Ab1DAVDp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 17:03:45 -0400
Received: from adelie.canonical.com ([91.189.90.139]:36093 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753582Ab1DAVDn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 17:03:43 -0400
From: Chase Douglas <chase.douglas@canonical.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Henrik Rydberg <rydberg@euromail.se>, Simon Budig <simon@budig.de>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH resend] hid-magicmouse: Increase evdev buffer size
Date: Fri,  1 Apr 2011 17:03:39 -0400
Message-Id: <1301691819-2090-1-git-send-email-chase.douglas@canonical.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The evdev buffer isn't big enough when you get many fingers on the
device. Bump up the buffer to a reasonable size, matching what other
multitouch devices use. Without this change, events may be discarded in
the evdev buffer before they are read.

Reported-by: Simon Budig <simon@budig.de>
Cc: Henrik Rydberg <rydberg@euromail.se>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: stable@kernel.org
Signed-off-by: Chase Douglas <chase.douglas@canonical.com>
---
Forgot to Cc the mailing lists on the first send.

 drivers/hid/hid-magicmouse.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/hid/hid-magicmouse.c b/drivers/hid/hid-magicmouse.c
index 698e645..404dcbc 100644
--- a/drivers/hid/hid-magicmouse.c
+++ b/drivers/hid/hid-magicmouse.c
@@ -418,6 +418,8 @@ static void magicmouse_setup_input(struct input_dev *input, struct hid_device *h
 			input_set_abs_params(input, ABS_MT_POSITION_Y, -2456,
 				2565, 4, 0);
 		}
+
+		input_set_events_per_packet(input, 60);
 	}
 
 	if (report_undeciphered) {
-- 
1.7.4.1

