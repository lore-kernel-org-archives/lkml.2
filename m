Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758861Ab0HLApG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 20:45:06 -0400
Received: from kroah.org ([198.145.64.141]:40043 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758710Ab0HKX5b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 19:57:31 -0400
X-Mailbox-Line: From gregkh@clark.site Wed Aug 11 16:54:56 2010
Message-Id: <20100811235456.340938703@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 11 Aug 2010 16:53:49 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [008/111] PCI: Do not run NVidia quirks related to MSI with MSI disabled
In-Reply-To: <20100811235623.GA24440@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Rafael J. Wysocki <rjw@sisk.pl>

commit 3d2a531804d16cd8df6dbbb0429c6f143e756049 upstream.

There is no reason to run NVidia-specific quirks related to HT MSI
mappings with MSI disabled via pci=nomsi, so make
__nv_msi_ht_cap_quirk() return immediately in that case.

This allows at least one machine to boot 100% of the time with
pci=nomsi (it still doesn't boot reliably without that).

Addresses https://bugzilla.kernel.org/show_bug.cgi?id=16443 .

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/pci/quirks.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -2356,6 +2356,9 @@ static void __devinit __nv_msi_ht_cap_qu
 	int pos;
 	int found;
 
+	if (!pci_msi_enabled())
+		return;
+
 	/* check if there is HT MSI cap or enabled on this device */
 	found = ht_check_msi_mapping(dev);
 


