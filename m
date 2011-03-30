Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933767Ab1C3VZs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:25:48 -0400
Received: from mga02.intel.com ([134.134.136.20]:33747 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965081Ab1C3VJM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:09:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="621238474"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: pbruskispam@op.pl, tiwai@suse.de, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [206/275] ALSA: ctxfi - Fix incorrect SPDIF status bit mask
Message-Id: <20110330210730.96AA13E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:07:30 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Przemyslaw Bruski <pbruskispam@op.pl>

commit 4c1847e884efddcc3ede371f7839e5e65b25c34d upstream.

SPDIF status mask creation was incorrect.

Signed-off-by: Przemyslaw Bruski <pbruskispam@op.pl>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 sound/pci/ctxfi/ctatc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.35.y/sound/pci/ctxfi/ctatc.c
===================================================================
--- linux-2.6.35.y.orig/sound/pci/ctxfi/ctatc.c	2011-03-29 22:50:36.791317022 -0700
+++ linux-2.6.35.y/sound/pci/ctxfi/ctatc.c	2011-03-29 23:03:02.557234737 -0700
@@ -869,7 +869,7 @@
 	mutex_lock(&atc->atc_mutex);
 	dao->ops->get_spos(dao, &status);
 	if (((status >> 24) & IEC958_AES3_CON_FS) != iec958_con_fs) {
-		status &= ((~IEC958_AES3_CON_FS) << 24);
+		status &= ~(IEC958_AES3_CON_FS << 24);
 		status |= (iec958_con_fs << 24);
 		dao->ops->set_spos(dao, status);
 		dao->ops->commit_write(dao);
