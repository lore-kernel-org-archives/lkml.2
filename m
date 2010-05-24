Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759022Ab0EXXJd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 19:09:33 -0400
Received: from kroah.org ([198.145.64.141]:36455 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758733Ab0EXXJ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 19:09:29 -0400
X-Mailbox-Line: From gregkh@clark.site Mon May 24 16:03:51 2010
Message-Id: <20100524230351.044290356@clark.site>
User-Agent: quilt/0.48-8.10
Date: Mon, 24 May 2010 15:59:51 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Borislav Petkov <borislav.petkov@amd.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [19/34] x86, k8: Fix build error when K8_NB is disabled
In-Reply-To: <20100524230418.GA12770@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Borislav Petkov <borislav.petkov@amd.com>

commit ade029e2aaacc8965a548b0b0f80c5bee97ffc68 upstream.

K8_NB depends on PCI and when the last is disabled (allnoconfig) we fail
at the final linking stage due to missing exported num_k8_northbridges.
Add a header stub for that.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
LKML-Reference: <20100503183036.GJ26107@aftab>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/include/asm/k8.h |    5 +++++
 1 file changed, 5 insertions(+)

--- a/arch/x86/include/asm/k8.h
+++ b/arch/x86/include/asm/k8.h
@@ -13,11 +13,16 @@ extern void k8_flush_garts(void);
 extern int k8_scan_nodes(unsigned long start, unsigned long end);
 
 #ifdef CONFIG_K8_NB
+extern int num_k8_northbridges;
+
 static inline struct pci_dev *node_to_k8_nb_misc(int node)
 {
 	return (node < num_k8_northbridges) ? k8_northbridges[node] : NULL;
 }
+
 #else
+#define num_k8_northbridges 0
+
 static inline struct pci_dev *node_to_k8_nb_misc(int node)
 {
 	return NULL;


