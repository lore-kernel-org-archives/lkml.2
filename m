Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755107Ab1LVKvB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 05:51:01 -0500
Received: from 72.155.broadband6.iol.cz ([88.101.155.72]:49663 "EHLO
	eagle.danny.cz" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752416Ab1LVKu6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 05:50:58 -0500
X-Greylist: delayed 1578 seconds by postgrey-1.27 at vger.kernel.org; Thu, 22 Dec 2011 05:50:58 EST
From: =?UTF-8?q?Dan=20Hor=C3=A1k?= <dan@danny.cz>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] prefetch() not declared in net/ipv4/route.c on s390x
Date: Thu, 22 Dec 2011 11:50:56 +0100
Message-Id: <1324551056-28486-1-git-send-email-dan@danny.cz>
X-Mailer: git-send-email 1.7.4.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The recent commit (9f28a2fc0bd77511f649c0a788c7bf9a5fd04edb) to route.c
breaks build on s390x because it leaves prefetch() undeclared.

net/ipv4/route.c: In function 'rt_check_expire':
net/ipv4/route.c:874:4: error: implicit declaration of function 'prefetch' [-Werror=implicit-function-declaration]
cc1: some warnings being treated as errors
make[2]: *** [net/ipv4/route.o] Error 1

Signed-off-by: Dan Horák <dan@danny.cz>
---
 net/ipv4/route.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 252c512..85cc053 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -91,6 +91,7 @@
 #include <linux/rcupdate.h>
 #include <linux/times.h>
 #include <linux/slab.h>
+#include <linux/prefetch.h>
 #include <net/dst.h>
 #include <net/net_namespace.h>
 #include <net/protocol.h>
-- 
1.7.4.4

