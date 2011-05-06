Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932839Ab1EFAzD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 20:55:03 -0400
Received: from kroah.org ([198.145.64.141]:36781 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755892Ab1EFAYv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 20:24:51 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May  5 17:22:10 2011
Message-Id: <20110506002210.313803632@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 05 May 2011 17:20:37 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Florian Ragwitz <rafl@debian.org>, Dmitry Torokhov <dtor@mail.ru>
Subject: [052/143] Input: elantech - allow forcing Elantech protocol
In-Reply-To: <20110506002311.GA15354@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Florian Ragwitz <rafl@debian.org>

commit f81bc788ff91d4efd4baf88b2c29713838caa8e5 upstream.

Apparently hardware vendors now ship elantech touchpads with different version
magic. This options allows for them to be tested easier with the current driver
in order to add their magic to the whitelist later.

Signed-off-by: Florian Ragwitz <rafl@debian.org>
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/input/mouse/elantech.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/drivers/input/mouse/elantech.c
+++ b/drivers/input/mouse/elantech.c
@@ -24,6 +24,10 @@
 			printk(KERN_DEBUG format, ##arg);	\
 	} while (0)
 
+static bool force_elantech;
+module_param_named(force_elantech, force_elantech, bool, 0644);
+MODULE_PARM_DESC(force_elantech, "Force the Elantech PS/2 protocol extension to be used, 1 = enabled, 0 = disabled (default).");
+
 /*
  * Send a Synaptics style sliced query command
  */
@@ -595,8 +599,12 @@ int elantech_detect(struct psmouse *psmo
 		 param[0], param[1], param[2]);
 
 	if (param[0] == 0 || param[1] != 0) {
-		pr_debug("elantech.c: Probably not a real Elantech touchpad. Aborting.\n");
-		return -1;
+		if (!force_elantech) {
+			pr_debug("elantech.c: Probably not a real Elantech touchpad. Aborting.\n");
+			return -1;
+		}
+
+		pr_debug("elantech.c: Probably not a real Elantech touchpad. Enabling anyway due to force_elantech.\n");
 	}
 
 	if (set_properties) {


