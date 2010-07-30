Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760033Ab0G3SUu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 14:20:50 -0400
Received: from kroah.org ([198.145.64.141]:58749 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759933Ab0G3R43 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:56:29 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:51:44 2010
Message-Id: <20100730175144.293118895@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:52:11 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Kamal Mostafa <kamal@canonical.com>, Dmitry Torokhov <dtor@mail.ru>
Subject: [114/205] Input: i8042 - add Gigabyte Spring Peak to dmi_noloop_table
In-Reply-To: <20100730175238.GA3924@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Kamal Mostafa <kamal@canonical.com>

commit 3e1bbc8d5018a05c0793c8a32b777a1396eb4414 upstream.

Gigabyte "Spring Peak" notebook indicates wrong chassis-type, tripping up
i8042 and breaking the touchpad.  Add this model to i8042_dmi_noloop_table[]
to resolve.

BugLink: https://bugs.launchpad.net/bugs/580664

Signed-off-by: Kamal Mostafa <kamal@canonical.com>
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/input/serio/i8042-x86ia64io.h |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/input/serio/i8042-x86ia64io.h
+++ b/drivers/input/serio/i8042-x86ia64io.h
@@ -166,6 +166,13 @@ static const struct dmi_system_id __init
 		},
 	},
 	{
+		/* Gigabyte Spring Peak - defines wrong chassis type */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "GIGABYTE"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Spring Peak"),
+		},
+	},
+	{
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "HP Pavilion dv9700"),


