Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753559Ab1HOVyJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 17:54:09 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:62461 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753235Ab1HOVyH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 17:54:07 -0400
From: William Douglas <william.r.douglas@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCHv2] printk: Remove bounds checking for log_prefix
References: <877h6e2x7r.fsf@intel.com>
Date: Mon, 15 Aug 2011 14:54:04 -0700
In-Reply-To: <877h6e2x7r.fsf@intel.com> (William Douglas's message of "Mon, 15
	Aug 2011 14:15:04 -0700")
Message-ID: <871uwm2ver.fsf@intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently log_prefix is testing that the first character of the
log level and facility is less than '0' and greater than '9' (which
is always false).

Since the code being updated works because strtoul bombs out (endp isn't
updated) and 0 is returned anyway just remove the check and don't change
the behavior of the function.
Signed-off-by: William Douglas <william.douglas@intel.com>
---
 kernel/printk.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/kernel/printk.c b/kernel/printk.c
index 37dff34..4a0d2ed 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -590,9 +590,6 @@ static size_t log_prefix(const char *p, unsigned int *level, char *special)
 		/* multi digit including the level and facility number */
 		char *endp = NULL;
 
-		if (p[1] < '0' && p[1] > '9')
-			return 0;
-
 		lev = (simple_strtoul(&p[1], &endp, 10) & 7);
 		if (endp == NULL || endp[0] != '>')
 			return 0;
-- 
1.7.6

