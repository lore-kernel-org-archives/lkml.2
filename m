Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757479Ab2JXPdx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 11:33:53 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:45494 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755976Ab2JXPdv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 11:33:51 -0400
Subject: [PATCH v8 1/5] ipc: remove forced assignment of selected message
To: akpm@linux-foundation.org
From: Stanislav Kinsbursky <skinsbursky@parallels.com>
Cc: serge.hallyn@canonical.com, ebiederm@xmission.com,
        linux-kernel@vger.kernel.org, xemul@parallels.com,
        catalin.marinas@arm.com, will.deacon@arm.com, jmorris@namei.org,
        cmetcalf@tilera.com, joe.korty@ccur.com, dhowells@redhat.com,
        dledford@redhat.com, viro@zeniv.linux.org.uk,
        kosaki.motohiro@jp.fujitsu.com, linux-api@vger.kernel.org,
        serue@us.ibm.com, tglx@linutronix.de, paulmck@linux.vnet.ibm.com,
        devel@openvz.org, mtk.manpages@gmail.com
Date: Wed, 24 Oct 2012 19:35:04 +0400
Message-ID: <20121024153504.5642.18778.stgit@localhost.localdomain>
In-Reply-To: <20121024151555.5642.79086.stgit@localhost.localdomain>
References: <20121024151555.5642.79086.stgit@localhost.localdomain>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a cleanup patch. The assignment is redundant.

Signed-off-by: Stanislav Kinsbursky <skinsbursky@parallels.com>
---
 ipc/msg.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/ipc/msg.c b/ipc/msg.c
index a71af5a..2f272fa 100644
--- a/ipc/msg.c
+++ b/ipc/msg.c
@@ -793,12 +793,9 @@ long do_msgrcv(int msqid, long *pmtype, void __user *mtext,
 				msg = walk_msg;
 				if (mode == SEARCH_LESSEQUAL &&
 						walk_msg->m_type != 1) {
-					msg = walk_msg;
 					msgtyp = walk_msg->m_type - 1;
-				} else {
-					msg = walk_msg;
+				} else
 					break;
-				}
 			}
 			tmp = tmp->next;
 		}

