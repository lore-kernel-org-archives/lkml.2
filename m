Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756598Ab0KJUiS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 15:38:18 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:43462 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755449Ab0KJUiQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 15:38:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=TLi+jMrSbGDOirWpGVzxF61dowpW4NZ1OljrAD/vnyrQJsn3QYu0gYJj8gCKcmwkjx
         bx2H8CucEMgdpUJOOJZaMuNpC9KuBrNcM4s2wiYMFIRZtkNgC/F3RD68jtfMxYfECEgE
         mXY07CltY+FjCh/A/wl3wMXlp6mLcQZs50s6E=
From: Vasiliy Kulikov <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        =?UTF-8?q?Andr=C3=A9=20Goddard=20Rosa?= <andre.goddard@gmail.com>,
        Joe Perches <joe@perches.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Bjorn Helgaas <bjorn.helgaas@hp.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] lib: vsprintf: fix invalid arg check
Date: Wed, 10 Nov 2010 23:38:08 +0300
Message-Id: <1289421490-23950-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"size" is size_t.  If we want to check whether it was underflowed
then we should cast it to ssize_t instead of int.  When
sizeof(size_t) > sizeof(int) the code sees UINT_MAX as underflow,
but it is not.

Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
---
 Compile tested.

 lib/vsprintf.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index c150d3d..e7cf674 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -1290,7 +1290,7 @@ int vsnprintf(char *buf, size_t size, const char *fmt, va_list args)
 
 	/* Reject out-of-range values early.  Large positive sizes are
 	   used for unknown buffer sizes. */
-	if (WARN_ON_ONCE((int) size < 0))
+	if (WARN_ON_ONCE((ssize_t) size < 0))
 		return 0;
 
 	str = buf;
-- 
1.7.0.4

