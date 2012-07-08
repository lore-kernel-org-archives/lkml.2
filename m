Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752492Ab2GHVNv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2012 17:13:51 -0400
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:26171
	"EHLO mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752312Ab2GHVNt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2012 17:13:49 -0400
X-IronPort-AV: E=Sophos;i="4.77,547,1336341600"; 
   d="scan'208";a="149999165"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: David Airlie <airlied@linux.ie>
Cc: kernel-janitors@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] drivers/gpu/drm/gma500/oaktrail_crtc.c: remove invalid reference to list iterator variable
Date: Sun,  8 Jul 2012 23:13:42 +0200
Message-Id: <1341782023-23868-2-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1341782023-23868-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1341782023-23868-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

If list_for_each_entry, etc complete a traversal of the list, the iterator
variable ends up pointing to an address at an offset from the list head,
and not a meaningful structure.  Thus this value should not be used after
the end of the iterator.

A break is added after the switch; the break in the switch would jump out
of the switch, but not out of the complete iteration.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
identifier c;
expression E;
iterator name list_for_each_entry;
statement S;
@@

list_for_each_entry(c,...) { ... when != break;
                                 when forall
                                 when strict
}
...
(
c = E
|
*c
)
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
Acked-by: Paul Menzel <paulepanter@users.sourceforge.net>

---
 drivers/gpu/drm/gma500/oaktrail_crtc.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/gma500/oaktrail_crtc.c b/drivers/gpu/drm/gma500/oaktrail_crtc.c
index f821c83..4b2172e 100644
--- a/drivers/gpu/drm/gma500/oaktrail_crtc.c
+++ b/drivers/gpu/drm/gma500/oaktrail_crtc.c
@@ -329,6 +329,7 @@ static int oaktrail_crtc_mode_set(struct drm_crtc *crtc,
 			is_mipi = true;
 			break;
 		}
+		break;
 	}
 
 	/* Disable the VGA plane that we never use */
