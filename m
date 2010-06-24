Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754628Ab0FXDV7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 23:21:59 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:45142 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754394Ab0FXDVz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 23:21:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=CXPU2akbkn6mpIzM5aXvk97n30CmuO+KUj8TLIhbydaPfNqkwAj8pB+pwBC3XLP3Ih
         5PmQSpvWNvvfwZTGMHeGMVffRiClAT5e5rum83Qe3xbDMmpqgZQ2TDBwZwcSJukFHYlx
         /PhIW9JDDv6QMIC9EegJnPgzjF/FqFLNuSxU4=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, James Simmons <jsimmons@infradead.org>,
       linux-fbdev@vger.kernel.org, Denys Vlasenko <vda.linux@googlemail.com>
Cc: linux-kernel@vger.kernel.org, Denys Vlasenko <vda.linux@googlemail.com>
Subject: [PATCH] fbcon: deinline four foo_update_attr() functions
Date: Thu, 24 Jun 2010 05:21:46 +0200
Message-Id: <1277349706-5195-1-git-send-email-vda.linux@googlemail.com>
X-Mailer: git-send-email 1.6.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch deinlines four similar functions, foo_update_attr(),
in four fbcon-related files.
These functions contain loops, two of theam have _hested_ loops,
and they have more than one callsite each.
I think they should not be inlined.

Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
---
 drivers/video/console/bitblit.c   |    2 +-
 drivers/video/console/fbcon_ccw.c |    2 +-
 drivers/video/console/fbcon_cw.c  |    2 +-
 drivers/video/console/fbcon_ud.c  |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/video/console/bitblit.c b/drivers/video/console/bitblit.c
index af88651..28b1a83 100644
--- a/drivers/video/console/bitblit.c
+++ b/drivers/video/console/bitblit.c
@@ -22,7 +22,7 @@
 /*
  * Accelerated handlers.
  */
-static inline void update_attr(u8 *dst, u8 *src, int attribute,
+static void update_attr(u8 *dst, u8 *src, int attribute,
 			       struct vc_data *vc)
 {
 	int i, offset = (vc->vc_font.height < 10) ? 1 : 2;
diff --git a/drivers/video/console/fbcon_ccw.c b/drivers/video/console/fbcon_ccw.c
index d135671..41b32ae 100644
--- a/drivers/video/console/fbcon_ccw.c
+++ b/drivers/video/console/fbcon_ccw.c
@@ -22,7 +22,7 @@
  * Rotation 270 degrees
  */
 
-static inline void ccw_update_attr(u8 *dst, u8 *src, int attribute,
+static void ccw_update_attr(u8 *dst, u8 *src, int attribute,
 				  struct vc_data *vc)
 {
 	int i, j, offset = (vc->vc_font.height < 10) ? 1 : 2;
diff --git a/drivers/video/console/fbcon_cw.c b/drivers/video/console/fbcon_cw.c
index 126110f..6a73782 100644
--- a/drivers/video/console/fbcon_cw.c
+++ b/drivers/video/console/fbcon_cw.c
@@ -22,7 +22,7 @@
  * Rotation 90 degrees
  */
 
-static inline void cw_update_attr(u8 *dst, u8 *src, int attribute,
+static void cw_update_attr(u8 *dst, u8 *src, int attribute,
 				  struct vc_data *vc)
 {
 	int i, j, offset = (vc->vc_font.height < 10) ? 1 : 2;
diff --git a/drivers/video/console/fbcon_ud.c b/drivers/video/console/fbcon_ud.c
index 93a3e73..ff0872c 100644
--- a/drivers/video/console/fbcon_ud.c
+++ b/drivers/video/console/fbcon_ud.c
@@ -22,7 +22,7 @@
  * Rotation 180 degrees
  */
 
-static inline void ud_update_attr(u8 *dst, u8 *src, int attribute,
+static void ud_update_attr(u8 *dst, u8 *src, int attribute,
 				  struct vc_data *vc)
 {
 	int i, offset = (vc->vc_font.height < 10) ? 1 : 2;
-- 
1.6.2.5

