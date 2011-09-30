Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754709Ab1I3E7x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 00:59:53 -0400
Received: from SMTP.ANDREW.CMU.EDU ([128.2.11.95]:47758 "EHLO
	smtp.andrew.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754254Ab1I3E7w convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 00:59:52 -0400
X-Greylist: delayed 1223 seconds by postgrey-1.27 at vger.kernel.org; Fri, 30 Sep 2011 00:59:52 EDT
From: Josh Zimmerman <jzimmerm@andrew.cmu.edu>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Subject: [PATCH] kernel/groups.c: Minor bugfix for overflow in binary search
Date: Fri, 30 Sep 2011 00:39:17 -0400
Message-Id: <1FB729E1-8CAA-4EEF-ABA4-200471843503@andrew.cmu.edu>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
To: akpm@linux-foundation.org, serge.hallyn@canonical.com,
        ebiederm@xmission.com, dhowells@redhat.com, daniel.lezcano@free.fr
Mime-Version: 1.0 (Apple Message framework v1084)
X-Mailer: Apple Mail (2.1084)
X-PMX-Version: 5.5.9.388399, Antispam-Engine: 2.7.2.376379, Antispam-Data: 2011.5.19.222118
X-SMTP-Spam-Clean: 8% (
 BODYTEXTP_SIZE_3000_LESS 0, BODY_SIZE_1000_LESS 0, BODY_SIZE_2000_LESS 0, BODY_SIZE_5000_LESS 0, BODY_SIZE_600_699 0, BODY_SIZE_7000_LESS 0, __ANY_URI 0, __CT 0, __CTE 0, __CT_TEXT_PLAIN 0, __HAS_MSGID 0, __HAS_X_MAILER 0, __MIME_TEXT_ONLY 0, __MIME_VERSION 0, __MIME_VERSION_APPLEMAIL 0, __MSGID_APPLEMAIL 0, __SANE_MSGID 0, __TO_MALFORMED_2 0, __TO_NO_NAME 0, __URI_NO_PATH 0, __URI_NO_WWW 0, __URI_NS , __USER_AGENT_APPLEMAIL 0, __X_MAILER_APPLEMAIL 0)
X-SMTP-Spam-Score: 8%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Josh Zimmerman

Fixed possible unsigned int overflow bug. (2 + 2^(32) - 1)/2 results in overflow; 2 + (2^(32)-1-2)/2 does not.

Signed-off-by: Josh Zimmerman <joshz@cmu.edu>

---

--- kernel/groups.c.orig	2011-09-29 23:58:45.000000000 -0400
+++ kernel/groups.c	2011-09-29 23:59:13.000000000 -0400
@@ -142,7 +142,7 @@ int groups_search(const struct group_inf
 	left = 0;
 	right = group_info->ngroups;
 	while (left < right) {
-		unsigned int mid = (left+right)/2;
+		unsigned int mid = left +  (right - left)/2;
 		if (grp > GROUP_AT(group_info, mid))
 			left = mid + 1;
 		else if (grp < GROUP_AT(group_info, mid))


