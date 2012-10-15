Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753075Ab2JOP6X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 11:58:23 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:15936 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751947Ab2JOP6V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 11:58:21 -0400
Subject: [PATCH v6 01/10] ipc: remove forced assignment of selected message
To: akpm@linux-foundation.org
From: Stanislav Kinsbursky <skinsbursky@parallels.com>
Cc: catalin.marinas@arm.com, will.deacon@arm.com, dhowells@redhat.com,
        manfred@colorfullife.com, hughd@google.com, jmorris@namei.org,
        mtk.manpages@gmail.com, kosaki.motohiro@jp.fujitsu.com,
        paulmck@linux.vnet.ibm.com, sds@tycho.nsa.gov, devel@openvz.org,
        a.p.zijlstra@chello.nl, cmetcalf@tilera.com, linux-driver@qlogic.com,
        ron.mercer@qlogic.com, viro@zeniv.linux.org.uk, eparis@parisplace.org,
        tglx@linutronix.de, jitendra.kalsaria@qlogic.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, ebiederm@xmission.com,
        casey@schaufler-ca.com
Date: Mon, 15 Oct 2012 19:59:41 +0400
Message-ID: <20121015155941.28348.88481.stgit@localhost.localdomain>
In-Reply-To: <20121015155800.28348.23561.stgit@localhost.localdomain>
References: <20121015155800.28348.23561.stgit@localhost.localdomain>
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

