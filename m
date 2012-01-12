Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753892Ab2ALPBq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 10:01:46 -0500
Received: from mail-ee0-f74.google.com ([74.125.83.74]:63308 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753841Ab2ALPBl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 10:01:41 -0500
Subject: [PATCH] x86/PCI: build amd_bus.o only when CONFIG_AMD_NB=y
To: Linus Torvalds <torvalds@linux-foundation.org>
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-pci@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>,
        Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org
Date: Thu, 12 Jan 2012 08:01:40 -0700
Message-ID: <20120112150140.12223.47232.stgit@bhelgaas.mtv.corp.google.com>
In-Reply-To: <20120112145935.12223.39035.stgit@bhelgaas.mtv.corp.google.com>
References: <20120112145935.12223.39035.stgit@bhelgaas.mtv.corp.google.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We only need amd_bus.o for AMD systems with PCI.  arch/x86/pci/Makefile
already depends on CONFIG_PCI=y, so this patch just adds the dependency
on CONFIG_AMD_NB.

Cc: Yinghai Lu <yinghai@kernel.org>
Cc: stable@kernel.org	# 2.6.34+ (needs adjustment for k8 -> amd rename)
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
---
 arch/x86/pci/Makefile |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/pci/Makefile b/arch/x86/pci/Makefile
index 6b8759f..d24d3da 100644
--- a/arch/x86/pci/Makefile
+++ b/arch/x86/pci/Makefile
@@ -18,8 +18,9 @@ obj-$(CONFIG_X86_NUMAQ)		+= numaq_32.o
 obj-$(CONFIG_X86_MRST)		+= mrst.o
 
 obj-y				+= common.o early.o
-obj-y				+= amd_bus.o bus_numa.o
+obj-y				+= bus_numa.o
 
+obj-$(CONFIG_AMD_NB)		+= amd_bus.o
 obj-$(CONFIG_PCI_CNB20LE_QUIRK)	+= broadcom_bus.o
 
 ifeq ($(CONFIG_PCI_DEBUG),y)

