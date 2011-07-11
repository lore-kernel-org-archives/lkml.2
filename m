Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757659Ab1GKOHs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 10:07:48 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:34766 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757594Ab1GKOHq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 10:07:46 -0400
Subject: [PATCH 1/2] Input: atkbd - make dmi callback functions return 1
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Vojtech Pavlik <vojtech@suse.cz>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 11 Jul 2011 22:07:36 +0800
Message-ID: <1310393256.2415.2.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We only care about if there is a successful match from the table (or no match at all),
we can make dmi_check_system return immediately if we have a successful match
instead of iterate thorough the whole table.

Make the dmi callback function return 1 then dmi_check_system
will return immediately if we have a successful match.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/input/keyboard/atkbd.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/input/keyboard/atkbd.c b/drivers/input/keyboard/atkbd.c
index 11478eb..19cfc0c 100644
--- a/drivers/input/keyboard/atkbd.c
+++ b/drivers/input/keyboard/atkbd.c
@@ -1578,14 +1578,14 @@ static int __init atkbd_setup_forced_release(const struct dmi_system_id *id)
 	atkbd_platform_fixup = atkbd_apply_forced_release_keylist;
 	atkbd_platform_fixup_data = id->driver_data;
 
-	return 0;
+	return 1;
 }
 
 static int __init atkbd_setup_scancode_fixup(const struct dmi_system_id *id)
 {
 	atkbd_platform_scancode_fixup = id->driver_data;
 
-	return 0;
+	return 1;
 }
 
 static const struct dmi_system_id atkbd_dmi_quirk_table[] __initconst = {
-- 
1.7.4.1



