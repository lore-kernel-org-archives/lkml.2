Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752968Ab2A3Nka (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 08:40:30 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:17366 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752710Ab2A3Nk2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 08:40:28 -0500
Date: Mon, 30 Jan 2012 16:40:29 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch 2/2] sysctl: fix memset parameters in setup_sysctl_set()
Message-ID: <20120130134029.GC5926@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4F269DC9.00E9,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current code is a nop.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/fs/proc/proc_sysctl.c b/fs/proc/proc_sysctl.c
index 1b1f5b8..27e265b 100644
--- a/fs/proc/proc_sysctl.c
+++ b/fs/proc/proc_sysctl.c
@@ -1547,7 +1547,7 @@ void setup_sysctl_set(struct ctl_table_set *set,
 	struct ctl_table_root *root,
 	int (*is_seen)(struct ctl_table_set *))
 {
-	memset(set, sizeof(*set), 0);
+	memset(set, 0, sizeof(*set));
 	set->is_seen = is_seen;
 	init_header(&set->dir.header, root, set, NULL, root_table);
 }
