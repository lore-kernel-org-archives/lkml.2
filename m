Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754614Ab3ADTMw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 14:12:52 -0500
Received: from li42-95.members.linode.com ([209.123.162.95]:56761 "EHLO
	li42-95.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754370Ab3ADTMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 14:12:51 -0500
From: Pantelis Antoniou <panto@antoniou-consulting.com>
To: Jon Loeliger <jdl@jdl.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Matt Porter <mporter@ti.com>, Russ Dill <Russ.Dill@ti.com>,
        Pantelis Antoniou <panto@antoniou-consulting.com>
Subject: fdtdump: properly handle multi-string properties
Date: Fri,  4 Jan 2013 21:12:46 +0200
Message-Id: <1357326766-12691-1-git-send-email-panto@antoniou-consulting.com>
X-Mailer: git-send-email 1.7.12
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Device tree can store multiple strings in a single property.
We didn't handle that case properly.

Signed-off-by: Pantelis Antoniou <panto@antoniou-consulting.com>
---
 fdtdump.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/fdtdump.c b/fdtdump.c
index 207a46d..d4fa6d7 100644
--- a/fdtdump.c
+++ b/fdtdump.c
@@ -21,13 +21,23 @@ static void print_data(const char *data, int len)
 {
 	int i;
 	const char *p = data;
+	const char *s;
 
 	/* no data, don't print */
 	if (len == 0)
 		return;
 
 	if (util_is_printable_string(data, len)) {
-		printf(" = \"%s\"", (const char *)data);
+		printf(" = ");
+
+		s = data;
+		do {
+			printf("\"%s\"", s);
+			s += strlen(s) + 1;
+			if (s < data + len)
+				printf(", ");
+		} while (s < data + len);
+
 	} else if ((len % 4) == 0) {
 		printf(" = <");
 		for (i = 0; i < len; i += 4)
-- 
1.7.12

