Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754477Ab1BOJfK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 04:35:10 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:39627 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089Ab1BOJfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 04:35:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=RLOqNA6kzuwoh7kwd8TqoLMiRCJcAT86UbQXw17ESRxJIa9nE3A4Wq94VDVjQTi2or
         6nVAnedaztB6ro8Alu5sOT30Dn3Nu8EJrNKd8xRL57tLA7ZspsKEXaIu75nUF5Vp4XcT
         dayILrniGalrVjVCKodI9FCLn2VZ2ARj1e/K0=
Subject: [PATCH] video: add missing framebuffer_release in error path
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>, Paul Mundt <lethal@linux-sh.org>,
        linux-fbdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 15 Feb 2011 17:35:02 +0800
Message-ID: <1297762502.4049.2.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a memory leak in the error path.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/video/cg14.c |    1 +
 drivers/video/cg6.c  |    1 +
 drivers/video/tcx.c  |    1 +
 3 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/video/cg14.c b/drivers/video/cg14.c
index 2424953..2063a63 100644
--- a/drivers/video/cg14.c
+++ b/drivers/video/cg14.c
@@ -565,6 +565,7 @@ out_dealloc_cmap:
 
 out_unmap_regs:
 	cg14_unmap_regs(op, info, par);
+	framebuffer_release(info);
 
 out_err:
 	return err;
diff --git a/drivers/video/cg6.c b/drivers/video/cg6.c
index 2b5a970..f3b8848 100644
--- a/drivers/video/cg6.c
+++ b/drivers/video/cg6.c
@@ -822,6 +822,7 @@ out_dealloc_cmap:
 
 out_unmap_regs:
 	cg6_unmap_regs(op, info, par);
+	framebuffer_release(info);
 
 out_err:
 	return err;
diff --git a/drivers/video/tcx.c b/drivers/video/tcx.c
index 77ad279..3d84235 100644
--- a/drivers/video/tcx.c
+++ b/drivers/video/tcx.c
@@ -481,6 +481,7 @@ out_dealloc_cmap:
 
 out_unmap_regs:
 	tcx_unmap_regs(op, info, par);
+	framebuffer_release(info);
 
 out_err:
 	return err;
-- 
1.7.1



