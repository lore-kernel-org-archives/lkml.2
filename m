Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754194Ab0L0T4S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Dec 2010 14:56:18 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:61946 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754071Ab0L0T4Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Dec 2010 14:56:16 -0500
Date: Mon, 27 Dec 2010 11:55:08 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, Mark Fasheh <mfasheh@suse.com>,
        Joel Becker <joel.becker@oracle.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        ocfs2-devel@oss.oracle.com
Subject: [PATCH -next] ocfs2: fix build for OCFS2_FS_STATS not enabled
Message-Id: <20101227115508.8136331b.randy.dunlap@oracle.com>
In-Reply-To: <20101227170451.a9a9f873.sfr@canb.auug.org.au>
References: <20101227170451.a9a9f873.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

When CONFIG_OCFS2_FS_STATS is not enabled:

fs/ocfs2/cluster/tcp.c:1254: error: implicit declaration of function 'o2net_update_recv_stats'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc:	Mark Fasheh <mfasheh@suse.com>
Cc:	Joel Becker <joel.becker@oracle.com>
Cc:	ocfs2-devel@oss.oracle.com
---
 fs/ocfs2/cluster/tcp.c |    2 ++
 1 file changed, 2 insertions(+)

--- linux-next-20101227.orig/fs/ocfs2/cluster/tcp.c
+++ linux-next-20101227/fs/ocfs2/cluster/tcp.c
@@ -257,6 +257,8 @@ static void o2net_update_recv_stats(stru
 
 # define o2net_update_send_stats(a, b)
 
+# define o2net_update_recv_stats(sc)
+
 #endif /* CONFIG_OCFS2_FS_STATS */
 
 static inline int o2net_reconnect_delay(void)
