Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759620Ab0JZKTe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 06:19:34 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:60782 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759456Ab0JZKSV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 06:18:21 -0400
From: Julia Lawall <julia@diku.dk>
To: Jaroslav Kysela <perex@perex.cz>
Cc: kernel-janitors@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: [PATCH 9/14] sound/oss/sb_ess.c: delete double assignment
Date: Tue, 26 Oct 2010 12:25:38 +0200
Message-Id: <1288088743-3725-10-git-send-email-julia@diku.dk>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1288088743-3725-1-git-send-email-julia@diku.dk>
References: <1288088743-3725-1-git-send-email-julia@diku.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Delete successive assignments to the same location.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
expression i;
@@

*i = ...;
 i = ...;
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 sound/oss/sb_ess.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/sound/oss/sb_ess.c b/sound/oss/sb_ess.c
index 51a3d38..9890cf2 100644
--- a/sound/oss/sb_ess.c
+++ b/sound/oss/sb_ess.c
@@ -1722,7 +1722,6 @@ printk (KERN_INFO "FKS: es_rec_set_recmask mask = %x\n", mask);
 				right = (value & 0x0000ff00) >> 8;
 			} else {				/* Turn it off (3)  */
 				left  = 0;
-				left  = 0;
 				right = 0;
 			}
 			sb_common_mixer_set(devc, i + ES_REC_MIXER_RECDIFF, left, right);

