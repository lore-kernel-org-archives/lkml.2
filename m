Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933889Ab1DNSYc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 14:24:32 -0400
Received: from mail.windriver.com ([147.11.1.11]:41287 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933633Ab1DNR5f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 13:57:35 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 114/209] Input: i8042 - add Sony VAIO VPCZ122GX to nomux list
Date: Thu, 14 Apr 2011 13:54:32 -0400
Message-Id: <1302803767-9715-1-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
References: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

  =====================================================================
  | This is a commit scheduled for the next v2.6.34 longterm release. |
  | If you see a problem with using this for longterm, please comment.|
  =====================================================================

[Note that the mainline will not have this particular fix but rather
will blacklist entire VAIO line based off DMI board name. For stable
I am being a bit more cautious and blacklist one particular product.]

Trying to query/activate active multiplexing mode on this VAIO makes
both keyboard and touchpad inoperable. Futher kernels will blacklist
entire VAIO line, however here we blacklist just one particular model.

[PG: mainline commit for blacklist is 73b14484fb686252aaf4aac4fa65b4]

Reported-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/input/serio/i8042-x86ia64io.h |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/input/serio/i8042-x86ia64io.h b/drivers/input/serio/i8042-x86ia64io.h
index c452504..8f46380 100644
--- a/drivers/input/serio/i8042-x86ia64io.h
+++ b/drivers/input/serio/i8042-x86ia64io.h
@@ -329,6 +329,13 @@ static const struct dmi_system_id __initconst i8042_dmi_nomux_table[] = {
 		},
 	},
 	{
+		/* Sony Vaio VPCZ122GX */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Sony Corporation"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "VPCZ122GX"),
+		},
+	},
+	{
 		/* Sony Vaio FS-115b */
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "Sony Corporation"),
-- 
1.7.4.4

