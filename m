Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752043Ab2GTTMO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 15:12:14 -0400
Received: from 1010ds2-suoe.0.fullrate.dk ([90.184.90.115]:25497 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751380Ab2GTTMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 15:12:12 -0400
Date: Fri, 20 Jul 2012 21:12:11 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
cc: Rob Landley <rob@landley.net>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] [IA64] aliasing-test: Remember to close fd on error in
 read_rom()
Message-ID: <alpine.LNX.2.00.1207202110590.23164@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 Documentation/ia64/aliasing-test.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/ia64/aliasing-test.c b/Documentation/ia64/aliasing-test.c
index 5caa2af..62a190d 100644
--- a/Documentation/ia64/aliasing-test.c
+++ b/Documentation/ia64/aliasing-test.c
@@ -132,6 +132,7 @@ static int read_rom(char *path)
 
 	rc = write(fd, "1", 2);
 	if (rc <= 0) {
+		close(fd);
 		perror("write");
 		return -1;
 	}
-- 
1.7.11.2


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

