Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753828Ab0F1LzV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 07:55:21 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48266 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753091Ab0F1LzM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 07:55:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=suO5OQU6cLzrgWuWI8iALRsI1sV7ypHoNSwNYUFlkEmrRgp64fSt3BRp0x+5LAE71B
         gjeAJAS1FrjT3Sxbi9M9FA4KmF76zJYwsuGwJbjlR1B54eyfb0Z3vxPAZGqMKhW4Q9PS
         RWzwY3A5zNgkTwJ3l+4YoxXwbBHOxv3C8hPOQ=
From: Kulikov Vasiliy <segooon@gmail.com>
To: trivial@kernel.org
Cc: Kernel Janitors <kernel-janitors@vger.kernel.org>,
       Jing Huang <huangj@brocade.com>,
       "James E.J. Bottomley" <James.Bottomley@suse.de>,
       Krishna Gudipati <kgudipat@brocade.com>,
       Kulikov Vasiliy <segooon@gmail.com>, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 07/16] trivial: use ARRAY_SIZE
Date: Mon, 28 Jun 2010 15:55:08 +0400
Message-Id: <1277726109-24633-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change sizeof(x) / sizeof(*x) to ARRAY_SIZE(x).

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 drivers/scsi/bfa/bfa_fcs.c |   10 ++++------
 1 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_fcs.c b/drivers/scsi/bfa/bfa_fcs.c
index 3516172..153cb2a 100644
--- a/drivers/scsi/bfa/bfa_fcs.c
+++ b/drivers/scsi/bfa/bfa_fcs.c
@@ -86,7 +86,7 @@ bfa_fcs_attach(struct bfa_fcs_s *fcs, struct bfa_s *bfa, struct bfad_s *bfad,
 	bfa_attach_fcs(bfa);
 	fcbuild_init();
 
-	for (i = 0; i < sizeof(fcs_modules) / sizeof(fcs_modules[0]); i++) {
+	for (i = 0; i < ARRAY_SIZE(fcs_modules); i++) {
 		mod = &fcs_modules[i];
 		if (mod->attach)
 			mod->attach(fcs);
@@ -102,7 +102,7 @@ bfa_fcs_init(struct bfa_fcs_s *fcs)
 	int             i;
 	struct bfa_fcs_mod_s  *mod;
 
-	for (i = 0; i < sizeof(fcs_modules) / sizeof(fcs_modules[0]); i++) {
+	for (i = 0; i < ARRAY_SIZE(fcs_modules); i++) {
 		mod = &fcs_modules[i];
 		if (mod->modinit)
 			mod->modinit(fcs);
@@ -163,13 +163,11 @@ void
 bfa_fcs_exit(struct bfa_fcs_s *fcs)
 {
 	struct bfa_fcs_mod_s  *mod;
-	int             nmods, i;
+	int i;
 
 	bfa_wc_init(&fcs->wc, bfa_fcs_exit_comp, fcs);
 
-	nmods = sizeof(fcs_modules) / sizeof(fcs_modules[0]);
-
-	for (i = 0; i < nmods; i++) {
+	for (i = 0; i < ARRAY_SIZE(fcs_modules); i++) {
 
 		mod = &fcs_modules[i];
 		if (mod->modexit) {
-- 
1.7.0.4

