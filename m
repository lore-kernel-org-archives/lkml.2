Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753067Ab0EQGeK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 02:34:10 -0400
Received: from hera.kernel.org ([140.211.167.34]:60892 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750998Ab0EQGeI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 02:34:08 -0400
Date: Mon, 17 May 2010 06:33:48 GMT
From: tip-bot for Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       jbarnes@virtuousgeek.org, tglx@linutronix.de, hpa@linux.intel.com,
       jacob.jun.pan@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       jbarnes@virtuousgeek.org, tglx@linutronix.de,
       jacob.jun.pan@linux.intel.com, hpa@linux.intel.com
In-Reply-To: <1273873281-17489-2-git-send-email-jacob.jun.pan@linux.intel.com>
References: <1273873281-17489-2-git-send-email-jacob.jun.pan@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mrst] x86, mrst, pci: return 0 for non-present pci bars
Message-ID: <tip-e4af4268a34d8cd28c46a03161fc017cbd2db887@git.kernel.org>
Git-Commit-ID: e4af4268a34d8cd28c46a03161fc017cbd2db887
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 17 May 2010 06:33:49 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e4af4268a34d8cd28c46a03161fc017cbd2db887
Gitweb:     http://git.kernel.org/tip/e4af4268a34d8cd28c46a03161fc017cbd2db887
Author:     Jacob Pan <jacob.jun.pan@linux.intel.com>
AuthorDate: Fri, 14 May 2010 14:41:14 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Sun, 16 May 2010 22:45:36 -0700

x86, mrst, pci: return 0 for non-present pci bars

Moorestown PCI code has special handling of devices with fixed BARs. In
case of BAR sizing writes, we need to update the fake PCI MMCFG space with real
size decode value.

When a BAR is not present, we need to return 0 instead of ~0. ~0 will be
treated as device error per bugzilla 12006.

Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
LKML-Reference: <1273873281-17489-2-git-send-email-jacob.jun.pan@linux.intel.com>
Acked-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/pci/mrst.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/pci/mrst.c b/arch/x86/pci/mrst.c
index 8bf2fcb..d5c7aef 100644
--- a/arch/x86/pci/mrst.c
+++ b/arch/x86/pci/mrst.c
@@ -109,7 +109,7 @@ static int pci_device_update_fixed(struct pci_bus *bus, unsigned int devfn,
 			decode++;
 			decode = ~(decode - 1);
 		} else {
-			decode = ~0;
+			decode = 0;
 		}
 
 		/*
