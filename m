Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754387Ab2BEG7E (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 01:59:04 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:41820 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753064Ab2BEG7A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 01:59:00 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tony Luck <tony.luck@intel.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 02/24] PCI: add busn inline helper
Date: Sat,  4 Feb 2012 22:57:46 -0800
Message-Id: <1328425088-6562-3-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1328425088-6562-1-git-send-email-yinghai@kernel.org>
References: <1328425088-6562-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090206.4F2E28A9.002E,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

convert back and forth with busn and domain_nr/bus_nr

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 include/linux/ioport.h |   17 +++++++++++++++++
 1 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/include/linux/ioport.h b/include/linux/ioport.h
index 6fe9e19..f80c0cc 100644
--- a/include/linux/ioport.h
+++ b/include/linux/ioport.h
@@ -138,6 +138,23 @@ extern struct resource ioport_resource;
 extern struct resource iomem_resource;
 extern struct resource iobusn_resource;
 
+static inline int busn_domain_nr(resource_size_t busn)
+{
+	return busn >> 8;
+}
+static inline int busn_bus_nr(resource_size_t busn)
+{
+	return busn & 0xff;
+}
+static inline resource_size_t busn_update_bus_nr(resource_size_t busn, int b_nr)
+{
+	return (busn & ~0xff) | (b_nr & 0xff);
+}
+static inline resource_size_t busn(int d_nr, int b_nr)
+{
+	return  ((d_nr & 0xffff) << 8) | (b_nr & 0xff);
+}
+
 extern struct resource *request_resource_conflict(struct resource *root, struct resource *new);
 extern int request_resource(struct resource *root, struct resource *new);
 extern int release_resource(struct resource *new);
-- 
1.7.7

