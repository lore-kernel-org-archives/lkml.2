Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752621Ab2GZPzr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 11:55:47 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:27451 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752436Ab2GZPzq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 11:55:46 -0400
X-IronPort-AV: E=Sophos;i="4.77,659,1336363200"; 
   d="scan'208";a="203311594"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: <linux-kernel@vger.kernel.org>
CC: <xen-devel@lists.xensource.com>, <Stefano.Stabellini@eu.citrix.com>,
        <konrad.wilk@oracle.com>, <Ian.Campbell@citrix.com>, <tim@xen.org>,
        <linux-arm-kernel@lists.infradead.org>, <linaro-dev@lists.linaro.org>,
        <catalin.marinas@arm.com>, <arnd@arndb.de>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH 20/24] xen: update xen_add_to_physmap interface
Date: Thu, 26 Jul 2012 16:34:02 +0100
Message-ID: <1343316846-25860-20-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <alpine.DEB.2.02.1207251741470.26163@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1207251741470.26163@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update struct xen_add_to_physmap to be in sync with Xen's version of the
structure.
The size field was introduced by:

changeset:   24164:707d27fe03e7
user:        Jean Guyader <jean.guyader@eu.citrix.com>
date:        Fri Nov 18 13:42:08 2011 +0000
summary:     mm: New XENMEM space, XENMAPSPACE_gmfn_range

According to the comment:

"This new field .size is located in the 16 bits padding between .domid
and .space in struct xen_add_to_physmap to stay compatible with older
versions."

This is not true on ARM where there is not padding, but it is valid on
X86, so introducing size is safe on X86 and it is going to fix the
interace for ARM.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
---
 include/xen/interface/memory.h |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/include/xen/interface/memory.h b/include/xen/interface/memory.h
index abbbff0..d8e33a9 100644
--- a/include/xen/interface/memory.h
+++ b/include/xen/interface/memory.h
@@ -163,6 +163,9 @@ struct xen_add_to_physmap {
     /* Which domain to change the mapping for. */
     domid_t domid;
 
+    /* Number of pages to go through for gmfn_range */
+    uint16_t    size;
+
     /* Source mapping space. */
 #define XENMAPSPACE_shared_info 0 /* shared info page */
 #define XENMAPSPACE_grant_table 1 /* grant table page */
-- 
1.7.2.5

