Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752726Ab2CHVbI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 16:31:08 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:59084 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752401Ab2CHVbE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 16:31:04 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Slaby <jirislaby@gmail.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        LKML <linux-kernel@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Maciej Rutecki <maciej.rutecki@gmail.com>
References: <20120130222717.GA6393@kroah.com>
	<m18vkoirv9.fsf@fess.ebiederm.org> <4F27C6EB.2070305@suse.cz>
	<m14nvc82jo.fsf@fess.ebiederm.org>
	<CA+55aFwZNdoAA9iPMiEp8-+ndgV+CtSZO4neSh_L+gd77k7-vg@mail.gmail.com>
	<m1wr87ywex.fsf@fess.ebiederm.org>
	<m1ehueyz20.fsf_-_@fess.ebiederm.org>
	<CA+55aFyNQnXrL7fWhBt4LYBuoHD_x+j=Af-N=ueFMBkymy9Rnw@mail.gmail.com>
	<CA+55aFzZX544ZDN9vN3jWMWZ=_9ZtpZ9cR6gNEzUnx9RCqR5LQ@mail.gmail.com>
	<4F54BFEC.6000206@suse.cz> <20120305160953.GA3870@kroah.com>
Date: Thu, 08 Mar 2012 13:34:22 -0800
In-Reply-To: <20120305160953.GA3870@kroah.com> (Greg Kroah-Hartman's message
	of "Mon, 5 Mar 2012 08:09:53 -0800")
Message-ID: <m1r4x2wzdt.fsf_-_@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+CQ4Dly+6Uxspa18Vbl+6ZiOUMhjxYn8c=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  1.5 XMNoVowels Alpha-numberic number with no vowels
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1]
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
	*  0.0 SUBJ_OBFU_PUNCT_FEW Possible punctuation-obfuscated Subject: header
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 
X-Spam-Combo: ;Greg Kroah-Hartman <gregkh@linuxfoundation.org>
X-Spam-Relay-Country: 
Subject: [PATCH 1/3] sysfs:  Compact sysfs_dirent s_flags into a byte.
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


In an effort to keep sysfs_dirent small used the smallest
basic type I can for sysfs s_flags.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 fs/sysfs/sysfs.h |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index 6289a00..c76c932 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -76,7 +76,7 @@ struct sysfs_dirent {
 		struct sysfs_elem_bin_attr	s_bin_attr;
 	};
 
-	unsigned short		s_flags;
+	unsigned char		s_flags;
 	umode_t 		s_mode;
 	unsigned int		s_ino;
 	struct sysfs_inode_attrs *s_iattr;
@@ -84,7 +84,7 @@ struct sysfs_dirent {
 
 #define SD_DEACTIVATED_BIAS		INT_MIN
 
-#define SYSFS_TYPE_MASK			0x00ff
+#define SYSFS_TYPE_MASK			0x000f
 #define SYSFS_DIR			0x0001
 #define SYSFS_KOBJ_ATTR			0x0002
 #define SYSFS_KOBJ_BIN_ATTR		0x0004
@@ -93,11 +93,11 @@ struct sysfs_dirent {
 #define SYSFS_ACTIVE_REF		(SYSFS_KOBJ_ATTR | SYSFS_KOBJ_BIN_ATTR)
 
 /* identify any namespace tag on sysfs_dirents */
-#define SYSFS_NS_TYPE_MASK		0xf00
-#define SYSFS_NS_TYPE_SHIFT		8
+#define SYSFS_NS_TYPE_MASK		0x70
+#define SYSFS_NS_TYPE_SHIFT		4
 
 #define SYSFS_FLAG_MASK			~(SYSFS_NS_TYPE_MASK|SYSFS_TYPE_MASK)
-#define SYSFS_FLAG_REMOVED		0x02000
+#define SYSFS_FLAG_REMOVED		0x080
 
 static inline unsigned int sysfs_type(struct sysfs_dirent *sd)
 {
-- 
1.7.2.5

