Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030387Ab2CFLad (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 06:30:33 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:36829 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759060Ab2CFLac (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 06:30:32 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of festevam@gmail.com designates 10.100.245.27 as permitted sender) smtp.mail=festevam@gmail.com; dkim=pass header.i=festevam@gmail.com
From: Fabio Estevam <festevam@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: bones@secretlab.ca, grant.likely@secretlab.ca,
        Fabio Estevam <festevam@gmail.com>,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH] dtc: flattree: Removed unused variable
Date: Tue,  6 Mar 2012 08:30:22 -0300
Message-Id: <1331033422-12044-1-git-send-email-festevam@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the following warning message:

scripts/dtc/flattree.c:700:14: warning: variable 'p' set but not used [-Wunused-but-set-variable]

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 scripts/dtc/flattree.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/scripts/dtc/flattree.c b/scripts/dtc/flattree.c
index ead0332..28d0b23 100644
--- a/scripts/dtc/flattree.c
+++ b/scripts/dtc/flattree.c
@@ -697,7 +697,6 @@ static struct reserve_info *flat_read_mem_reserve(struct inbuf *inb)
 {
 	struct reserve_info *reservelist = NULL;
 	struct reserve_info *new;
-	const char *p;
 	struct fdt_reserve_entry re;
 
 	/*
@@ -706,7 +705,6 @@ static struct reserve_info *flat_read_mem_reserve(struct inbuf *inb)
 	 *
 	 * First pass, count entries.
 	 */
-	p = inb->ptr;
 	while (1) {
 		flat_read_chunk(inb, &re, sizeof(re));
 		re.address  = fdt64_to_cpu(re.address);
-- 
1.7.1

