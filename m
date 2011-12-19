Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752323Ab1LSEFq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Dec 2011 23:05:46 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:45637 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752171Ab1LSEFo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Dec 2011 23:05:44 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
        Mikulas Patocka <mpatocka@redhat.com>
References: <m1aa6pky2r.fsf@fess.ebiederm.org>
	<m14nwxkxyg.fsf@fess.ebiederm.org>
Date: Sun, 18 Dec 2011 20:07:23 -0800
In-Reply-To: <m14nwxkxyg.fsf@fess.ebiederm.org> (Eric W. Biederman's message
	of "Sun, 18 Dec 2011 20:05:43 -0800")
Message-ID: <m1zkepjjb8.fsf_-_@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+iIg41CDtJoArbeGlV9FPiX+7kSi990GA=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  1.5 XMNoVowels Alpha-numberic number with no vowels
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 
X-Spam-Combo: ;Greg Kroah-Hartman <gregkh@suse.de>
X-Spam-Relay-Country: **
Subject: [PATCH 2/4] sysfs: Reduce s_flags to an unsinged short so it packs well with s_mode
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 32bit this reduces sizeof(struct sysfs_dirent) by 2 bytes.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 fs/sysfs/sysfs.h |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index 545a8d4..e10ff98 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -77,7 +77,7 @@ struct sysfs_dirent {
 		struct sysfs_elem_bin_attr	s_bin_attr;
 	};
 
-	unsigned int		s_flags;
+	unsigned short		s_flags;
 	unsigned short		s_mode;
 	ino_t			s_ino;
 	struct sysfs_inode_attrs *s_iattr;
@@ -94,11 +94,11 @@ struct sysfs_dirent {
 #define SYSFS_ACTIVE_REF		(SYSFS_KOBJ_ATTR | SYSFS_KOBJ_BIN_ATTR)
 
 /* identify any namespace tag on sysfs_dirents */
-#define SYSFS_NS_TYPE_MASK		0xff00
+#define SYSFS_NS_TYPE_MASK		0xf00
 #define SYSFS_NS_TYPE_SHIFT		8
 
 #define SYSFS_FLAG_MASK			~(SYSFS_NS_TYPE_MASK|SYSFS_TYPE_MASK)
-#define SYSFS_FLAG_REMOVED		0x020000
+#define SYSFS_FLAG_REMOVED		0x02000
 
 static inline unsigned int sysfs_type(struct sysfs_dirent *sd)
 {
-- 
1.7.2.5

