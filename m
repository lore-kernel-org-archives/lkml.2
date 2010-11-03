Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753405Ab0KCXoa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 19:44:30 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:58448 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752785Ab0KCXo2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 19:44:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=dHLCcwPQGDF4bSSBNbvAlNqK7CDQU3+Zu4QAbHn1TyYVjrkxZr6umlSfGqQzQ3VGWG
         DNOKKxMmTRwEdRyJ79uT5subkd8/KmY5GJ+kr9SpqVuMZovNehZzisEWUuC610wCFZ3M
         ltSxJX5oJ7tipLPUd0OYvHt7Uz/MnaOlFAQqs=
Subject: [PATCH v2]oom-kill: CAP_SYS_RESOURCE should get bonus
From: "Figo.zhang" <figo1802@gmail.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>, Andrew Morton <akpm@osdl.org>,
        "rientjes@google.com" <rientjes@google.com>
In-Reply-To: <1288662213.10103.2.camel@localhost.localdomain>
References: <1288662213.10103.2.camel@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 04 Nov 2010 07:43:24 +0800
Message-ID: <1288827804.2725.0.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


CAP_SYS_RESOURCE also had better get 3% bonus for protection.

Signed-off-by: Figo.zhang <figo1802@gmail.com>
--- 
mm/oom_kill.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 4029583..30b24b9 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -198,7 +198,8 @@ unsigned int oom_badness(struct task_struct *p, struct mem_cgroup *mem,
 	 * Root processes get 3% bonus, just like the __vm_enough_memory()
 	 * implementation used by LSMs.
 	 */
-	if (has_capability_noaudit(p, CAP_SYS_ADMIN))
+	if (has_capability_noaudit(p, CAP_SYS_ADMIN) ||
+	    has_capability_noaudit(p, CAP_SYS_RESOURCE))
 		points -= 30;
 
 	/*


