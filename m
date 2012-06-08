Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933480Ab2FHFZi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 01:25:38 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43200 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761120Ab2FHFHR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 01:07:17 -0400
Message-Id: <20120608041847.540026866@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 08 Jun 2012 05:19:30 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Thomas Hellstrom <thellstrom@vmware.com>,
        Jakob Bornecrantz <jakob@vmware.com>, Dave Airlie <airlied@redhat.com>
Subject: [ 50/82] drm/vmwgfx: Fix nasty write past alloced memory area
In-Reply-To: <20120608041840.861504477@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Hellstrom <thellstrom@vmware.com>

commit 0824db38e515644f8d1bfd64adbd7cb2c6ea7c62 upstream.

Signed-off-by: Thomas Hellstrom <thellstrom@vmware.com>
Reviewed-by: Jakob Bornecrantz <jakob@vmware.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_gmr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_gmr.c b/drivers/gpu/drm/vmwgfx/vmwgfx_gmr.c
index 51c9ba5..21ee782 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_gmr.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_gmr.c
@@ -66,7 +66,7 @@ static int vmw_gmr2_bind(struct vmw_private *dev_priv,
 	cmd += sizeof(remap_cmd) / sizeof(uint32);
 
 	for (i = 0; i < num_pages; ++i) {
-		if (VMW_PPN_SIZE > 4)
+		if (VMW_PPN_SIZE <= 4)
 			*cmd = page_to_pfn(*pages++);
 		else
 			*((uint64_t *)cmd) = page_to_pfn(*pages++);


