Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759097Ab2CBTpD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 14:45:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:4357 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751644Ab2CBTpC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 14:45:02 -0500
From: Myron Stowe <myron.stowe@redhat.com>
Subject: [PATCH] x86/PCI: add spinlock held check to
	'pcibios_fwaddrmap_lookup()'
To: jbarnes@virtuousgeek.org
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 02 Mar 2012 12:45:01 -0700
Message-ID: <20120302194501.26152.22845.stgit@amt.stowe>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'pcibios_fwaddrmap_lookup()' is used to maintain FW-assigned BIOS BAR
values for reinstatement when normal resource assignment attempts
fail and must be called with the 'pcibios_fwaddrmap_lock' spinlock
held.

This patch adds a WARN_ON notification if the spinlock is not currently
held by the caller.

Signed-off-by: Myron Stowe <myron.stowe@redhat.com>
---

 arch/x86/pci/i386.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/pci/i386.c b/arch/x86/pci/i386.c
index 33e6a0b..831971e 100644
--- a/arch/x86/pci/i386.c
+++ b/arch/x86/pci/i386.c
@@ -57,6 +57,8 @@ static struct pcibios_fwaddrmap *pcibios_fwaddrmap_lookup(struct pci_dev *dev)
 {
 	struct pcibios_fwaddrmap *map;
 
+	WARN_ON(!spin_is_locked(&pcibios_fwaddrmap_lock));
+
 	list_for_each_entry(map, &pcibios_fwaddrmappings, list)
 		if (map->dev == dev)
 			return map;

