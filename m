Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756474Ab0DVT2k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 15:28:40 -0400
Received: from kroah.org ([198.145.64.141]:40792 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756395Ab0DVT2c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 15:28:32 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:09:14 2010
Message-Id: <20100422190914.369894682@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:08:49 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Corentin Chary <corentincj@iksaif.net>, Len Brown <len.brown@intel.com>,
       Ben Hutchings <ben@decadent.org.uk>
Subject: [078/197] eeepc-laptop: add hotplug_disable parameter
In-Reply-To: <20100422191857.GA13268@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

commit 322a1356be96bcc4b97e8e370f6468c821330077 upstream.

Some new models need to disable wireless hotplug.
For the moment, we don't know excactly what models need that,
except 1005HA.
Users will be able to use that param as a workaround.

[bwh: Backported to 2.6.32]

Signed-off-by: Corentin Chary <corentincj@iksaif.net>
Signed-off-by: Len Brown <len.brown@intel.com>
Cc: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/platform/x86/eeepc-laptop.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/drivers/platform/x86/eeepc-laptop.c
+++ b/drivers/platform/x86/eeepc-laptop.c
@@ -254,6 +254,14 @@ MODULE_AUTHOR("Corentin Chary, Eric Coop
 MODULE_DESCRIPTION(EEEPC_HOTK_NAME);
 MODULE_LICENSE("GPL");
 
+static bool hotplug_disabled;
+
+module_param(hotplug_disabled, bool, 0644);
+MODULE_PARM_DESC(hotplug_disabled,
+		 "Disable hotplug for wireless device. "
+		 "If your laptop need that, please report to "
+		 "acpi4asus-user@lists.sourceforge.net.");
+
 /*
  * ACPI Helpers
  */
@@ -1305,6 +1313,8 @@ static int __devinit eeepc_hotk_add(stru
 	device->driver_data = ehotk;
 	ehotk->device = device;
 
+	ehotk->hotplug_disabled = hotplug_disabled;
+
 	eeepc_dmi_check();
 
 	result = eeepc_hotk_check();


