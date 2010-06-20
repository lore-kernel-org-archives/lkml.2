Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754778Ab0FTNka (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jun 2010 09:40:30 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:34740 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754654Ab0FTNk0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jun 2010 09:40:26 -0400
Date: Sun, 20 Jun 2010 15:40:20 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 2/3] drivers/gpu/drm/i915: remove duplicate structure field
 initialization
Message-ID: <Pine.LNX.4.64.1006201540030.6207@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

In each case, is_mobile is defined twice to 1.  Drop one initialization.

The semantic match that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@r@
identifier I, s, fld;
position p0,p;
expression E;
@@

struct I s =@p0 { ... .fld@p = E, ...};

@s@
identifier I, s, r.fld;
position r.p0,p;
expression E;
@@

struct I s =@p0 { ... .fld@p = E, ...};

@script:python@
p0 << r.p0;
fld << r.fld;
ps << s.p;
pr << r.p;
@@

if int(ps[0].line)<int(pr[0].line) or int(ps[0].column)<int(pr[0].column):
  cocci.print_main(fld,p0)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/gpu/drm/i915/i915_drv.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_drv.c b/drivers/gpu/drm/i915/i915_drv.c
index 423dc90..39b8981 100644
--- a/drivers/gpu/drm/i915/i915_drv.c
+++ b/drivers/gpu/drm/i915/i915_drv.c
@@ -97,7 +97,7 @@ static const struct intel_device_info intel_i965g_info = {
 };
 
 static const struct intel_device_info intel_i965gm_info = {
-	.is_i965g = 1, .is_mobile = 1, .is_i965gm = 1, .is_i9xx = 1,
+	.is_i965g = 1, .is_i965gm = 1, .is_i9xx = 1,
 	.is_mobile = 1, .has_fbc = 1, .has_rc6 = 1,
 	.has_hotplug = 1,
 };
@@ -114,7 +114,7 @@ static const struct intel_device_info intel_g45_info = {
 };
 
 static const struct intel_device_info intel_gm45_info = {
-	.is_i965g = 1, .is_mobile = 1, .is_g4x = 1, .is_i9xx = 1,
+	.is_i965g = 1, .is_g4x = 1, .is_i9xx = 1,
 	.is_mobile = 1, .need_gfx_hws = 1, .has_fbc = 1, .has_rc6 = 1,
 	.has_pipe_cxsr = 1,
 	.has_hotplug = 1,
