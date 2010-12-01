Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755331Ab0LANni (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 08:43:38 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:44600 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1755276Ab0LANnh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 08:43:37 -0500
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX18XPag/0pUXBYAEpgicfIByP6yiFX3ZNIOlbg8RX+
	1vEOUN/MhWJ/09
From: toralf.foerster@gmx.de
To: mingo@redhat.com
Cc: linux-kernel@vger.kernel.org,
        =?UTF-8?q?Toralf=20F=C3=B6rster?= <toralf.foerster@gmx.de>
Subject: =?UTF-8?q?=5BPATCH=5D=20fix=20findings=20from=20checkpatch=2Epl?=
Date: Wed,  1 Dec 2010 14:43:25 +0100
Message-Id: <1291211005-27017-1-git-send-email-toralf.foerster@gmx.de>
X-Mailer: git-send-email 1.7.2.2
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="------------1.7.2.2"
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Toralf FC6rster <toralf.foerster@gmx.de>

This is a multi-part message in MIME format.
--------------1.7.2.2
Content-Type: text/plain; charset=UTF-8; format=fixed
Content-Transfer-Encoding: 8bit

Well, I'll pick some low hanging fruits ...
(http://people.redhat.com/mingo/tip.git/README)

Signed-off-by: Toralf Förster <toralf.foerster@gmx.de>
---
 kernel/user_namespace.c |   14 ++++++--------
 1 files changed, 6 insertions(+), 8 deletions(-)


--------------1.7.2.2
Content-Type: text/x-patch; name="0001-fix-findings-from-checkpatch.pl.patch"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline; filename="0001-fix-findings-from-checkpatch.pl.patch"

diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
index 2591583..29994c8 100644
--- a/kernel/user_namespace.c
+++ b/kernel/user_namespace.c
@@ -95,11 +95,10 @@ uid_t user_ns_map_uid(struct user_namespace *to, const struct cred *cred, uid_t
 	/* Is cred->user the creator of the target user_ns
 	 * or the creator of one of it's parents?
 	 */
-	for ( tmp = to; tmp != &init_user_ns;
-	      tmp = tmp->creator->user_ns ) {
-		if (cred->user == tmp->creator) {
+	for (tmp = to; tmp != &init_user_ns;
+	      tmp = tmp->creator->user_ns) {
+		if (cred->user == tmp->creator)
 			return (uid_t)0;
-		}
 	}
 
 	/* No useful relationship so no mapping */
@@ -116,11 +115,10 @@ gid_t user_ns_map_gid(struct user_namespace *to, const struct cred *cred, gid_t
 	/* Is cred->user the creator of the target user_ns
 	 * or the creator of one of it's parents?
 	 */
-	for ( tmp = to; tmp != &init_user_ns;
-	      tmp = tmp->creator->user_ns ) {
-		if (cred->user == tmp->creator) {
+	for (tmp = to; tmp != &init_user_ns;
+	      tmp = tmp->creator->user_ns) {
+		if (cred->user == tmp->creator)
 			return (gid_t)0;
-		}
 	}
 
 	/* No useful relationship so no mapping */

--------------1.7.2.2--


