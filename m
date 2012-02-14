Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758594Ab2BNQz0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 11:55:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36184 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758078Ab2BNQzY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 11:55:24 -0500
Date: Tue, 14 Feb 2012 17:48:40 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: apw@canonical.com, arjan@linux.intel.com, fhrbata@redhat.com,
        john.johansen@canonical.com, penguin-kernel@I-love.SAKURA.ne.jp,
        rientjes@google.com, rusty@rustcorp.com.au, tj@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/6] usermodehelper: ____call_usermodehelper() doesn't need
	do_exit()
Message-ID: <20120214164840.GD21185@redhat.com>
References: <20120214164709.GA21178@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120214164709.GA21178@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Minor cleanup. ____call_usermodehelper() can simply return, no need
to call do_exit() explicitely.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/kmod.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/kmod.c b/kernel/kmod.c
index 8341de9..685b246 100644
--- a/kernel/kmod.c
+++ b/kernel/kmod.c
@@ -188,7 +188,7 @@ static int ____call_usermodehelper(void *data)
 	/* Exec failed? */
 fail:
 	sub_info->retval = retval;
-	do_exit(0);
+	return 0;
 }
 
 void call_usermodehelper_freeinfo(struct subprocess_info *info)
-- 
1.5.5.1


