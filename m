Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756860Ab1JQXrj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 19:47:39 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:26213 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751473Ab1JQXri convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 19:47:38 -0400
MIME-Version: 1.0
Message-ID: <dd238ce4-fe92-4dc0-a4b6-7f273c386366@default>
Date: Mon, 17 Oct 2011 16:47:17 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: ocfs2-devel@oss.oracle.com
Cc: linux-kernel@vger.kernel.org, Joel Becker <jlbec@evilplan.org>,
        Steven Whitehouse <swhiteho@redhat.com>,
        Sunil Mushran <sunil.mushran@oracle.com>
Subject: [PATCH] ocfs2: send correct UUID to cleancache initialization
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.4.1.0  (410211) [OL
 12.0.6562.5003]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090209.4E9CBE94.003C,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ocfs2: Fix cleancache initialization call to correctly pass uuid

As reported by Steven Whitehouse in https://lkml.org/lkml/2011/5/27/221 
the ocfs2 volume UUID is incorrectly passed to cleancache.
As a result, shared-ephemeral tmem pools will not actually
be created; instead they will be private (unshared) which
misses out on a major benefit of tmem.

Reported-by: Steven Whitehouse <swhiteho@redhat.com>
Signed-off-by: Dan Magenheimer <dan.magenheimer@oracle.com>

diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -2374,7 +2374,7 @@ static int ocfs2_initialize_super(struct super_block *sb,
 		mlog_errno(status);
 		goto bail;
 	}
-	cleancache_init_shared_fs((char *)&uuid_net_key, sb);
+	cleancache_init_shared_fs((char *)&di->id2.i_super.s_uuid, sb);
 
 bail:
 	return status;
