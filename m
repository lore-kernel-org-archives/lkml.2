Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755478Ab0IHVR3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 17:17:29 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:35451 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754142Ab0IHVRZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 17:17:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=RuuylunCHDstvnARhDO7MEnDBANc27weP1VRMI0fpXSe+uoanLnuxTVXlMQ0BvDRBQ
         4omnQ7LMck8ut/O82POGlO3j2TpjyXfGzG6xGSAgPrg1p+y6Xre/XOY7H/2D5xQ2iJUL
         BUT+SbgcZgl5RutW+2rbXvnJXb1IwavCg491k=
From: Nikitas Angelinas <nikitasangelinas@gmail.com>
To: airlied@linux.ie, eric@anholt.net, zhenyuw@linux.intel.com,
        yakui.zhao@intel.com, chris@chris-wilson.co.uk,
        jbarnes@virtuousgeek.org
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Nikitas Angelinas <nikitasangelinas@gmail.com>
Subject: [PATCH 4/8] drivers/gpu/drm/i915: use ARRAY_SIZE macro in intel_tv.c
Date: Wed,  8 Sep 2010 22:17:57 +0100
Message-Id: <1283980677-4980-1-git-send-email-nikitasangelinas@gmail.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1283979457-4649-1-git-send-email-nikitasangelinas@gmail.com>
References: <1283979457-4649-1-git-send-email-nikitasangelinas@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace sizeof(tv_modes) / sizeof (tv_modes[0]) with
ARRAY_SIZE(tv_modes) in drivers/gpu/drm/i915/intel_tv.c

Signed-off-by: Nikitas Angelinas <nikitasangelinas@gmail.com>
---
 drivers/gpu/drm/i915/intel_tv.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_tv.c b/drivers/gpu/drm/i915/intel_tv.c
index d2029ef..6dc19f6 100644
--- a/drivers/gpu/drm/i915/intel_tv.c
+++ b/drivers/gpu/drm/i915/intel_tv.c
@@ -30,6 +30,7 @@
  * Integrated TV-out support for the 915GM and 945GM.
  */
 
+#include <linux/kernel.h>
 #include "drmP.h"
 #include "drm.h"
 #include "drm_crtc.h"
@@ -926,7 +927,7 @@ intel_tv_mode_lookup (char *tv_format)
 {
 	int i;
 
-	for (i = 0; i < sizeof(tv_modes) / sizeof (tv_modes[0]); i++) {
+	for (i = 0; i < ARRAY_SIZE(tv_modes); i++) {
 		const struct tv_mode *tv_mode = &tv_modes[i];
 
 		if (!strcmp(tv_format, tv_mode->name))
-- 
1.7.2.3

