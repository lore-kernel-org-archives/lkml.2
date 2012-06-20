Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932529Ab2FTScx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 14:32:53 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:52480 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932305Ab2FTSX2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 14:23:28 -0400
Message-Id: <20120620173025.226294822@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Date: Wed, 20 Jun 2012 10:31:10 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Chen Gong <gong.chen@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [ 50/61] edac: fix the error about memory type detection on SandyBridge
In-Reply-To: <20120620173033.GA5634@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen Gong <gong.chen@linux.intel.com>

commit 2cbb587d3bc41a305168e91b4f3c5b6944a12566 upstream.

On SandyBridge, DDRIOA(Dev: 17 Func: 0 Offset: 328) is used
to detect whether DIMM is RDIMM/LRDIMM, not TA(Dev: 15 Func: 0).

Signed-off-by: Chen Gong <gong.chen@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/edac/sb_edac.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/edac/sb_edac.c
+++ b/drivers/edac/sb_edac.c
@@ -599,7 +599,7 @@ static int get_dimm_config(const struct
 		pvt->is_close_pg = false;
 	}
 
-	pci_read_config_dword(pvt->pci_ta, RANK_CFG_A, &reg);
+	pci_read_config_dword(pvt->pci_ddrio, RANK_CFG_A, &reg);
 	if (IS_RDIMM_ENABLED(reg)) {
 		/* FIXME: Can also be LRDIMM */
 		debugf0("Memory is registered\n");


