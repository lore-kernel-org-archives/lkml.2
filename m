Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932573Ab2JAW75 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 18:59:57 -0400
Received: from 1wt.eu ([62.212.114.60]:35035 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752479Ab2JAW7v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 18:59:51 -0400
Message-Id: <20121001225159.647035935@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 02 Oct 2012 00:52:45 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Jonghwan Choi <jhbird.choi@samsung.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        James Morris <james.l.morris@oracle.com>, Willy Tarreau <w@1wt.eu>
Subject: [ 048/180] security: fix compile error in commoncap.c
In-Reply-To: <6a854f579a99b4fe2efaca1057e8ae22@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Jonghwan Choi <jhbird.choi@samsung.com>

commit 51b79bee627d526199b2f6a6bef8ee0c0739b6d1 upstream

Add missing "personality.h"
security/commoncap.c: In function 'cap_bprm_set_creds':
security/commoncap.c:510: error: 'PER_CLEAR_ON_SETID' undeclared (first use in this function)
security/commoncap.c:510: error: (Each undeclared identifier is reported only once
security/commoncap.c:510: error: for each function it appears in.)

Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
Signed-off-by: James Morris <james.l.morris@oracle.com>
[dannf: adjusted to apply to Debian's 2.6.32]
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 security/commoncap.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/security/commoncap.c b/security/commoncap.c
index 30972d6..ee9d623 100644
--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -27,6 +27,7 @@
 #include <linux/sched.h>
 #include <linux/prctl.h>
 #include <linux/securebits.h>
+#include <linux/personality.h>
 
 /*
  * If a non-root user executes a setuid-root binary in
-- 
1.7.2.1.45.g54fbc



