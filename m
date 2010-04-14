Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755297Ab0DNMQ2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 08:16:28 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35740 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755073Ab0DNMQ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 08:16:27 -0400
Date: Wed, 14 Apr 2010 14:16:25 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: [PATCH] Input: add HP Compaq 2710p to 'noloop' table
Message-ID: <alpine.LNX.2.00.1004141409450.8345@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add HP Compaq 2710p to 'noloop' table. Otherwsie this machine is reported 
to not report properly to AUX_LOOP command time-to-time, causing 
non-working keyboard due to messed up i8042.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>

--- 

The relevant i8042.debug output from the failing case is

drivers/input/serio/i8042.c: 20 -> i8042 (command) [0]
drivers/input/serio/i8042.c: 65 <- i8042 (return) [0]
drivers/input/serio/i8042.c: 60 -> i8042 (command) [0]
drivers/input/serio/i8042.c: 74 -> i8042 (parameter) [0]
drivers/input/serio/i8042.c: d3 -> i8042 (command) [0]
drivers/input/serio/i8042.c: 5a -> i8042 (parameter) [0]
drivers/input/serio/i8042.c: 5a <- i8042 (return) [0]
drivers/input/serio/i8042.c: a7 -> i8042 (command) [0]
drivers/input/serio/i8042.c: 20 -> i8042 (command) [0]
drivers/input/serio/i8042.c: 74 <- i8042 (return) [0]
drivers/input/serio/i8042.c: a8 -> i8042 (command) [0]
drivers/input/serio/i8042.c: 20 -> i8042 (command) [0]
drivers/input/serio/i8042.c: 54 <- i8042 (return) [1]
drivers/input/serio/i8042.c: 60 -> i8042 (command) [1]
drivers/input/serio/i8042.c: 56 -> i8042 (parameter) [1]
drivers/input/serio/i8042.c: d3 -> i8042 (command) [1]
drivers/input/serio/i8042.c: a5 -> i8042 (parameter) [1]
drivers/input/serio/i8042.c: 60 -> i8042 (command) [1]
drivers/input/serio/i8042.c: 74 -> i8042 (parameter) [1]
drivers/input/serio/i8042.c: d3 -> i8042 (command) [1]
drivers/input/serio/i8042.c: f0 -> i8042 (parameter) [1]
drivers/input/serio/i8042.c: 00 <- i8042 (return) [1]
drivers/input/serio/i8042.c: 60 -> i8042 (command) [1]
drivers/input/serio/i8042.c: 56 -> i8042 (parameter) [1]
drivers/input/serio/i8042.c: 60 -> i8042 (command) [1]
drivers/input/serio/i8042.c: 47 -> i8042 (parameter) [1]
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
drivers/input/serio/i8042.c: f2 -> i8042 (kbd-data) [1]
...
drivers/input/serio/i8042.c: ed -> i8042 (kbd-data) [52]

 drivers/input/serio/i8042-x86ia64io.h |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/input/serio/i8042-x86ia64io.h b/drivers/input/serio/i8042-x86ia64io.h
index ead0494..d2c7cf0 100644
--- a/drivers/input/serio/i8042-x86ia64io.h
+++ b/drivers/input/serio/i8042-x86ia64io.h
@@ -172,6 +172,13 @@ static const struct dmi_system_id __initconst i8042_dmi_noloop_table[] = {
 			DMI_MATCH(DMI_PRODUCT_VERSION, "Rev 1"),
 		},
 	},
+	{
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "HP Compaq 2710p (#ABD)"),
+			DMI_MATCH(DMI_PRODUCT_VERSION, "F.14"),
+		},
+	},
 	{ }
 };
 
