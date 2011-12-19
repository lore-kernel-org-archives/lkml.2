Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752326Ab1LSEGi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Dec 2011 23:06:38 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:45942 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752146Ab1LSEGg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Dec 2011 23:06:36 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
        Mikulas Patocka <mpatocka@redhat.com>
References: <m1aa6pky2r.fsf@fess.ebiederm.org>
	<m14nwxkxyg.fsf@fess.ebiederm.org>
	<m1zkepjjb8.fsf_-_@fess.ebiederm.org>
Date: Sun, 18 Dec 2011 20:08:16 -0800
In-Reply-To: <m1zkepjjb8.fsf_-_@fess.ebiederm.org> (Eric W. Biederman's
	message of "Sun, 18 Dec 2011 20:07:23 -0800")
Message-ID: <m1ty4xjj9r.fsf_-_@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18k4kqEQANbaAdfvhHZvjDhH9usHP8je3I=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  1.5 XMNoVowels Alpha-numberic number with no vowels
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Greg Kroah-Hartman <gregkh@suse.de>
X-Spam-Relay-Country: 
Subject: [PATCH 3/4] sysfs: Store the sysfs inode in an unsigned int.
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Store the sysfs inode number in an unsided int because
ida inode allocator can return at most a 31 bit number,
reducing the size of struct sysfs_dirent by 8 bytes
on 64bit platforms.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 fs/sysfs/dir.c   |    4 ++--
 fs/sysfs/sysfs.h |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 0daf255..0589c9a 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -224,7 +224,7 @@ static void sysfs_deactivate(struct sysfs_dirent *sd)
 	rwsem_release(&sd->dep_map, 1, _RET_IP_);
 }
 
-static int sysfs_alloc_ino(ino_t *pino)
+static int sysfs_alloc_ino(unsigned int *pino)
 {
 	int ino, rc;
 
@@ -243,7 +243,7 @@ static int sysfs_alloc_ino(ino_t *pino)
 	return rc;
 }
 
-static void sysfs_free_ino(ino_t ino)
+static void sysfs_free_ino(unsigned int ino)
 {
 	spin_lock(&sysfs_ino_lock);
 	ida_remove(&sysfs_ino_ida, ino);
diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index e10ff98..3f23061 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -79,7 +79,7 @@ struct sysfs_dirent {
 
 	unsigned short		s_flags;
 	unsigned short		s_mode;
-	ino_t			s_ino;
+	unsigned int		s_ino;
 	struct sysfs_inode_attrs *s_iattr;
 };
 
-- 
1.7.2.5

