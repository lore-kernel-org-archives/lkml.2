Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753085Ab1HTGNL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Aug 2011 02:13:11 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:59980 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751127Ab1HTGMt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Aug 2011 02:12:49 -0400
From: Julia Lawall <julia@diku.dk>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: kernel-janitors@vger.kernel.org, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, Grant Likely <grant.likely@secretlab.ca>,
        linuxppc-dev@lists.ozlabs.org, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Subject: [PATCH 4/4] sound/aoa/fabrics/layout.c: remove unneeded kfree
Date: Sat, 20 Aug 2011 08:12:41 +0200
Message-Id: <1313820761-12042-4-git-send-email-julia@diku.dk>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

The label outnodev is only used when kzalloc has not yet taken place or has
failed, so there is no need for the call for kfree under this label.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
identifier x;
expression E1!=0,E2,E3,E4;
statement S;
iterator I;
@@

(
if (...) { ... when != kfree(x)
               when != x = E3
               when != E3 = x
*  return ...;
 }
... when != x = E2
    when != I(...,x,...) S
if (...) { ... when != x = E4
 kfree(x); ... return ...; }
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 sound/aoa/fabrics/layout.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/aoa/fabrics/layout.c b/sound/aoa/fabrics/layout.c
index 3fd1a7e..552b97a 100644
--- a/sound/aoa/fabrics/layout.c
+++ b/sound/aoa/fabrics/layout.c
@@ -1073,10 +1073,10 @@ static int aoa_fabric_layout_probe(struct soundbus_dev *sdev)
 	sdev->pcmid = -1;
 	list_del(&ldev->list);
 	layouts_list_items--;
+	kfree(ldev);
  outnodev:
  	of_node_put(sound);
  	layout_device = NULL;
- 	kfree(ldev);
 	return -ENODEV;
 }
 

