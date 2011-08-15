Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753160Ab1HOVPJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 17:15:09 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:36205 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752684Ab1HOVPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 17:15:07 -0400
From: William Douglas <william.r.douglas@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] printk: Fix bounds checking for log_prefix.
Date: Mon, 15 Aug 2011 14:15:04 -0700
Message-ID: <877h6e2x7r.fsf@intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently log_prefix is testing that the first character of the
log level and facility is less than '0' and greater than '9' (which
is always false).  It should be testing to see if the character
less than '0' or greater than '9' instead.  This patch makes that
change.

The code being changed worked because strtoul bombs out (endp isn't
updated) and 0 is returned anyway.
Signed-off-by: William Douglas <william.douglas@intel.com>
---
 kernel/printk.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/printk.c b/kernel/printk.c
index 37dff34..42080686 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -590,7 +590,7 @@ static size_t log_prefix(const char *p, unsigned int *level, char *special)
 		/* multi digit including the level and facility number */
 		char *endp = NULL;
 
-		if (p[1] < '0' && p[1] > '9')
+		if (p[1] < '0' || p[1] > '9')
 			return 0;
 
 		lev = (simple_strtoul(&p[1], &endp, 10) & 7);
-- 
1.7.6
