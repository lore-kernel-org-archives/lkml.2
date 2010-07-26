Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753971Ab0GZI1p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 04:27:45 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:63954 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752127Ab0GZI1n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 04:27:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=UbiAARFGW7eWr/SKLFHgS2zAXDpS1ipXVUuHi+bPtZALPVguKf+rOtxE1OBxo7Hy1U
         WAKq1dq7LG3Xg6yItKD4xZtN503c6+/+87e1RIAYsoX+4IwrdoK4bMpRNaN7FFDOZlu9
         loPA/MNZUHg0yQnYZs5Fjvc0vG+kvA+BqZZrU=
From: Kulikov Vasiliy <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>, Tejun Heo <tj@kernel.org>,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] afs: do not set task state after schedule_timeout()
Date: Mon, 26 Jul 2010 12:27:09 +0400
Message-Id: <1280132829-8224-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

schedule_timeout() sets tast state to TASK_RUNNING, so there's no need
to set it explicitly.

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 fs/afs/vlocation.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/fs/afs/vlocation.c b/fs/afs/vlocation.c
index 9ac260d..21f270d 100644
--- a/fs/afs/vlocation.c
+++ b/fs/afs/vlocation.c
@@ -130,7 +130,6 @@ static int afs_vlocation_access_vl_by_id(struct afs_vlocation *vl,
 					/* second+ BUSY - sleep a little bit */
 					set_current_state(TASK_UNINTERRUPTIBLE);
 					schedule_timeout(1);
-					__set_current_state(TASK_RUNNING);
 				}
 				continue;
 			}
-- 
1.7.0.4

