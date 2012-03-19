Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162037Ab2CSFxG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 01:53:06 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:25501 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162016Ab2CSFtu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 01:49:50 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>, x86 <x86@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH -v2 14/26] PCI: Use for_each_res with noassign_bars
Date: Sun, 18 Mar 2012 22:48:37 -0700
Message-Id: <1332136129-14010-15-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1332136129-14010-1-git-send-email-yinghai@kernel.org>
References: <1332136129-14010-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4F66C8FB.010B,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace those open code, and make code more readable.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/pci/common.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/x86/pci/common.c b/arch/x86/pci/common.c
index 0ec860f..7ea09f8 100644
--- a/arch/x86/pci/common.c
+++ b/arch/x86/pci/common.c
@@ -136,8 +136,7 @@ static void __devinit pcibios_fixup_device_resources(struct pci_dev *dev)
 		* resource so the kernel doesn't attmept to assign
 		* it later on in pci_assign_unassigned_resources
 		*/
-		for (bar = 0; bar <= PCI_STD_RESOURCE_END; bar++) {
-			bar_r = &dev->resource[bar];
+		for_each_pci_dev_base_norom_resource(dev, bar_r, bar) {
 			if (bar_r->start == 0 && bar_r->end != 0) {
 				bar_r->flags = 0;
 				bar_r->end = 0;
-- 
1.7.7

