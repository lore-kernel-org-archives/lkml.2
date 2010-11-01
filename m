Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754543Ab0KAVBw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 17:01:52 -0400
Received: from adelie.canonical.com ([91.189.90.139]:34838 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754377Ab0KAVBu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 17:01:50 -0400
From: Andy Whitcroft <apw@canonical.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andy Whitcroft <apw@canonical.com>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] kconfig: sym_expand_string_value: allow for string termination when reallocing
Date: Mon,  1 Nov 2010 21:01:44 +0000
Message-Id: <1288645304-2794-2-git-send-email-apw@canonical.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1288645304-2794-1-git-send-email-apw@canonical.com>
References: <1288645304-2794-1-git-send-email-apw@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When expanding a parameterised string we may run out of space, this
triggers a realloc.  When computing the new allocation size we do not allow
for the terminating '\0'.  Allow for this when calculating the new length.

Signed-off-by: Andy Whitcroft <apw@canonical.com>
---
 scripts/kconfig/symbol.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scripts/kconfig/symbol.c b/scripts/kconfig/symbol.c
index c0efe10..af6e9f3 100644
--- a/scripts/kconfig/symbol.c
+++ b/scripts/kconfig/symbol.c
@@ -875,7 +875,7 @@ const char *sym_expand_string_value(const char *in)
 			symval = sym_get_string_value(sym);
 		}
 
-		newlen = strlen(res) + strlen(symval) + strlen(src);
+		newlen = strlen(res) + strlen(symval) + strlen(src) + 1;
 		if (newlen > reslen) {
 			reslen = newlen;
 			res = realloc(res, reslen);
-- 
1.7.1

