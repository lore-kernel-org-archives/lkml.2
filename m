Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932743Ab0GAUul (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 16:50:41 -0400
Received: from kroah.org ([198.145.64.141]:47396 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932507Ab0GAUuE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 16:50:04 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:34:31 2010
Message-Id: <20100701173431.216023497@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:33:58 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Matthew Wilcox <willy@linux.intel.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [patch 052/164] PCI quirk: Disable MSI on VIA K8T890 systems
In-Reply-To: <20100701175152.GA2135@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Wilcox <matthew@wil.cx>

commit 134b345081534235dbf228b1005c14590e0570ba upstream.

Bugzilla 15287 indicates that there's a problem with Message Signalled
Interrupts on VIA K8T890 systems.  Add a quirk to disable MSI on these
systems.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
Tested-by: Jan Kreuzer <kontrollator@gmx.de>
Tested-by: lh <jarryson@gmail.com>
Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/pci/quirks.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -2113,6 +2113,7 @@ static void __devinit quirk_disable_msi(
 	}
 }
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_8131_BRIDGE, quirk_disable_msi);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_VIA, 0xa238, quirk_disable_msi);
 
 /* Go through the list of Hypertransport capabilities and
  * return 1 if a HT MSI capability is found and enabled */


