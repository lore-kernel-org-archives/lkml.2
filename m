Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758428Ab0HKXt7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 19:49:59 -0400
Received: from kroah.org ([198.145.64.141]:57515 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758208Ab0HKXty (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 19:49:54 -0400
X-Mailbox-Line: From gregkh@clark.site Wed Aug 11 16:46:25 2010
Message-Id: <20100811234625.173816865@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 11 Aug 2010 16:45:42 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Tejun Heo <tj@kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [03/11] PCI: disable MSI on VIA K8M800
In-Reply-To: <20100811234809.GA676@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Tejun Heo <tj@kernel.org>

commit 549e15611b4ac1de51ef0e0a79c2704f50a638a2 upstream.

MSI delivery from on-board ahci controller doesn't work on K8M800.  At
this point, it's unclear whether the culprit is with the ahci
controller or the host bridge.  Given the track record and considering
the rather minimal impact of MSI, disabling it seems reasonable.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Rainer Hurtado Navarro <publio.escipion.el.africano@gmail.com>
Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -2115,6 +2115,7 @@ DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_RS480, quirk_disabl
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_VIA, PCI_DEVICE_ID_VIA_VT3336, quirk_disable_all_msi);
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_VIA, PCI_DEVICE_ID_VIA_VT3351, quirk_disable_all_msi);
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_VIA, PCI_DEVICE_ID_VIA_VT3364, quirk_disable_all_msi);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_VIA, PCI_DEVICE_ID_VIA_8380_0, quirk_disable_all_msi);
 
 /* Disable MSI on chipsets that are known to not support it */
 static void __devinit quirk_disable_msi(struct pci_dev *dev)


