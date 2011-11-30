Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756248Ab1K3N44 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 08:56:56 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:36766 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754038Ab1K3N4v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 08:56:51 -0500
Date: Wed, 30 Nov 2011 16:56:04 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        "Serge E. Hallyn" <serge@hallyn.com>
Cc: Doug Ledford <dledford@redhat.com>, Jiri Slaby <jslaby@suse.cz>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Davidlohr Bueso <dave@gnu.org>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [patch -next] ipc/mqueue: lock() => unlock() typo
Message-ID: <20111130135604.GA2803@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A020206.4ED63611.0093,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There was a double lock typo introduced in b085f4bd6b21 "user namespace:
make signal.c respect user namespaces"

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
I think this patch is only needed in the -mm tree.

diff --git a/ipc/mqueue.c b/ipc/mqueue.c
index 691cfee..c246c83 100644
--- a/ipc/mqueue.c
+++ b/ipc/mqueue.c
@@ -558,7 +558,7 @@ static void __do_notify(struct mqueue_inode_info *info)
 						ns_of_pid(info->notify_owner));
 			sig_i.si_uid = user_ns_map_uid(info->user->user_ns,
 						current_cred(), current_uid());
-			rcu_read_lock();
+			rcu_read_unlock();
 
 			kill_pid_info(info->notify.sigev_signo,
 				      &sig_i, info->notify_owner);
