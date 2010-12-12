Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756109Ab0LLXsf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 18:48:35 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36817 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755093Ab0LLXs3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:48:29 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: dmitry.torokhov@gmail.com, dtor@mail.ru, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [201/223] Input: i8042 - add Sony VAIO VPCZ122GX to nomux list
Message-Id: <20101212234827.D17D5B27BF@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:48:27 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

[Note that the mainline will not have this particular fix but rather
will blacklist entire VAIO line based off DMI board name. For stable
I am being a bit more cautious and blacklist one particular product.]

Trying to query/activate active multiplexing mode on this VAIO makes
both keyboard and touchpad inoperable. Futher kernels will blacklist
entire VAIO line, however here we blacklist just one particular model.

Reported-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/input/serio/i8042-x86ia64io.h |    7 +++++++
 1 file changed, 7 insertions(+)

Index: linux/drivers/input/serio/i8042-x86ia64io.h
===================================================================
--- linux.orig/drivers/input/serio/i8042-x86ia64io.h
+++ linux/drivers/input/serio/i8042-x86ia64io.h
@@ -333,6 +333,13 @@ static const struct dmi_system_id __init
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
