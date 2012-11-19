Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753408Ab2KSFbP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 00:31:15 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:33260 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751770Ab2KSFbO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 00:31:14 -0500
X-Originating-IP: 217.70.178.135
X-Originating-IP: 50.43.39.152
From: Josh Triplett <josh@joshtriplett.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Josh Triplett <josh@joshtriplett.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 34/58] kbuild: kernel/bounds.c: Add prototype for dummy function foo
Date: Sun, 18 Nov 2012 21:28:13 -0800
Message-Id: <1353302917-13995-35-git-send-email-josh@joshtriplett.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1353302917-13995-1-git-send-email-josh@joshtriplett.org>
References: <1353302917-13995-1-git-send-email-josh@joshtriplett.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kernel/bounds.c defines an intentionally unused function foo, just to
slurp out the generated assembly and obtain the values for some
constants.  Add a prototype of this function, to satisfy GCC
(-Wmissing-prototypes) and Sparse (-Wdecl).

kernel/bounds.c:14:6: warning: no previous prototype for ‘foo’ [-Wmissing-prototypes]

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---
 kernel/bounds.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/bounds.c b/kernel/bounds.c
index 0c9b862..cfb4805 100644
--- a/kernel/bounds.c
+++ b/kernel/bounds.c
@@ -11,6 +11,8 @@
 #include <linux/kbuild.h>
 #include <linux/page_cgroup.h>
 
+void foo(void);
+
 void foo(void)
 {
 	/* The enum constants to put into include/generated/bounds.h */
-- 
1.7.10.4

