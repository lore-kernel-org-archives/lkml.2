Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754378Ab0FVTGO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 15:06:14 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:58784 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754185Ab0FVTGN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 15:06:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=mwCy1+i3cutCiV2eA/lxTeimFb9t1oWZvn61duWiQ0lC09Hc5b2Tcv6OLwvsg7+tW6
         AUvpBktCTf07MzSAMc7sI1syjnMR1On9Fh89cPTOspmAk7/c4EzaWhsmdUJ7zrOvh/P4
         SCcJbwTiu6tjGB30yGVa1nSJ1bk0ncRM5HGJU=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: linux-fbdev@vger.kernel.org
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       Denys Vlasenko <vda.linux@googlemail.com>
Subject: [PATCH] fbcon: deinline large static function get_color()
Date: Tue, 22 Jun 2010 21:05:56 +0200
Message-Id: <1277233556-14827-1-git-send-email-vda.linux@googlemail.com>
X-Mailer: git-send-email 1.6.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This function's body is good two screenfuls and it has six callsites.
No apparent reason why it is marked "iniline".

Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
---
 drivers/video/console/fbcon.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/video/console/fbcon.c b/drivers/video/console/fbcon.c
index b0a3fa0..24983e4 100644
--- a/drivers/video/console/fbcon.c
+++ b/drivers/video/console/fbcon.c
@@ -286,7 +286,7 @@ static inline int fbcon_is_inactive(struct vc_data *vc, struct fb_info *info)
 		vc->vc_mode != KD_TEXT || ops->graphics);
 }
 
-static inline int get_color(struct vc_data *vc, struct fb_info *info,
+static int get_color(struct vc_data *vc, struct fb_info *info,
 	      u16 c, int is_fg)
 {
 	int depth = fb_get_color_depth(&info->var, &info->fix);
-- 
1.6.2.5

