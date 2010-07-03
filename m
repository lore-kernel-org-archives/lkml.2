Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755264Ab0GCQDy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jul 2010 12:03:54 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:58781 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754912Ab0GCQDv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jul 2010 12:03:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=YuYpA0O8OcvpuOkdY/LImff+mNSp7bYdhf/hkzu+0PeVi4ZtEIasN++wIXjCXMftop
         lNOEeEFH0tmSbF2mpA0iWh1O7Ygj7mdvYgCOwoyg4fBFgabOQFnqdLTpgKvqESJZDaoX
         duXOh6Rd+71MeDYS11jUDFhvVdwHOhbILLkDY=
From: Kulikov Vasiliy <segooon@gmail.com>
To: Kernel Janitors <kernel-janitors@vger.kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>, Tejun Heo <tj@kernel.org>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH 04/19] arch/powerpc/platforms/pseries: use for_each_pci_dev()
Date: Sat,  3 Jul 2010 20:03:48 +0400
Message-Id: <1278173029-11541-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use for_each_pci_dev() to simplify the code.

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 arch/powerpc/platforms/pseries/eeh_cache.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/eeh_cache.c b/arch/powerpc/platforms/pseries/eeh_cache.c
index 30b987b..8ed0d2d 100644
--- a/arch/powerpc/platforms/pseries/eeh_cache.c
+++ b/arch/powerpc/platforms/pseries/eeh_cache.c
@@ -288,8 +288,7 @@ void __init pci_addr_cache_build(void)
 
 	spin_lock_init(&pci_io_addr_cache_root.piar_lock);
 
-	while ((dev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, dev)) != NULL) {
-
+	for_each_pci_dev(dev) {
 		pci_addr_cache_insert_device(dev);
 
 		dn = pci_device_to_OF_node(dev);
-- 
1.7.0.4

