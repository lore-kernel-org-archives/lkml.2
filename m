Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759585Ab0JVTBt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 15:01:49 -0400
Received: from kroah.org ([198.145.64.141]:34457 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759527Ab0JVS5K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:57:10 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Oct 22 11:52:35 2010
Message-Id: <20101022185235.670567349@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 22 Oct 2010 11:52:07 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Zhang Rui <rui.zhang@intel.com>, Len Brown <len.brown@intel.com>
Subject: [093/103] ACPI: Disable Windows Vista compatibility for Toshiba P305D
In-Reply-To: <20101022185455.GA9114@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Zhang Rui <rui.zhang@intel.com>

commit 337279ce3aa85d81d34c0f837d1c204df105103b upstream.

Disable the Windows Vista (SP1) compatibility for Toshiba P305D.

http://bugzilla.kernel.org/show_bug.cgi?id=14736

Signed-off-by: Zhang Rui <rui.zhang@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/acpi/blacklist.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/acpi/blacklist.c
+++ b/drivers/acpi/blacklist.c
@@ -241,6 +241,14 @@ static struct dmi_system_id acpi_osi_dmi
 		     DMI_MATCH(DMI_PRODUCT_NAME, "K50IJ"),
 		},
 	},
+	{
+	.callback = dmi_disable_osi_vista,
+	.ident = "Toshiba P305D",
+	.matches = {
+		     DMI_MATCH(DMI_SYS_VENDOR, "TOSHIBA"),
+		     DMI_MATCH(DMI_PRODUCT_NAME, "Satellite P305D"),
+		},
+	},
 
 	/*
 	 * BIOS invocation of _OSI(Linux) is almost always a BIOS bug.


