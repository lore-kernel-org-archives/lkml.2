Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933072Ab2HVQVl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 12:21:41 -0400
Received: from smtp.citrix.com ([66.165.176.89]:16732 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933001Ab2HVQUb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 12:20:31 -0400
X-IronPort-AV: E=Sophos;i="4.77,808,1336363200"; 
   d="scan'208";a="35465044"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: xen-devel@lists.xensource.com
CC: linux-kernel@vger.kernel.org, konrad.wilk@oracle.com,
        Stefano.Stabellini@eu.citrix.com,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH 3/6] xen: update xen_add_to_physmap interface
Date: Wed, 22 Aug 2012 17:20:13 +0100
Message-ID: <1345652416-27181-3-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <alpine.DEB.2.02.1208221635020.15568@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1208221635020.15568@kaball.uk.xensource.com>
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

Changes in v2:

- remove erroneous comment in the commit message.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
---
 include/xen/interface/memory.h |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/include/xen/interface/memory.h b/include/xen/interface/memory.h
index eac3ce1..8d4efc1 100644
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

