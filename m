Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755219Ab2BBD0A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 22:26:00 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:33714 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755075Ab2BBDZ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 22:25:58 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: <linux-kernel@vger.kernel.org>
Cc: <linux-fsdevel@vger.kernel.org>, <netdev@vger.kernel.org>,
        Lucian Adrian Grijincu <lucian.grijincu@gmail.com>,
        Damien Millescamps <damien.millescamps@6wind.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH 1/4] sysctl: An easier to read version of find_subdir
References: <m1pqe5ah3z.fsf@fess.ebiederm.org>
	<m139atx6bs.fsf@fess.ebiederm.org>
Date: Wed, 01 Feb 2012 19:28:40 -0800
In-Reply-To: <m139atx6bs.fsf@fess.ebiederm.org> (Eric W. Biederman's message
	of "Wed, 01 Feb 2012 19:27:51 -0800")
Message-ID: <m1y5slvrpz.fsf_-_@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/HojSE7BIm1RPEXJU7/IFFzW0eIxEgNJ0=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Suggested-by:  Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 fs/proc/proc_sysctl.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/proc/proc_sysctl.c b/fs/proc/proc_sysctl.c
index 27e265b..ebe8b30 100644
--- a/fs/proc/proc_sysctl.c
+++ b/fs/proc/proc_sysctl.c
@@ -833,9 +833,9 @@ static struct ctl_dir *find_subdir(struct ctl_dir *dir,
 	entry = find_entry(&head, dir, name, namelen);
 	if (!entry)
 		return ERR_PTR(-ENOENT);
-	if (S_ISDIR(entry->mode))
-		return container_of(head, struct ctl_dir, header);
-	return ERR_PTR(-ENOTDIR);
+	if (!S_ISDIR(entry->mode))
+		return ERR_PTR(-ENOTDIR);
+	return container_of(head, struct ctl_dir, header);
 }
 
 static struct ctl_dir *new_dir(struct ctl_table_set *set,
-- 
1.7.2.5

