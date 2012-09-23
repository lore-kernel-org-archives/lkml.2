Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753568Ab2IWDtB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2012 23:49:01 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:43435 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753525Ab2IWDsv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2012 23:48:51 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Kay Sievers <kay.sievers@vrfy.org>, "Serge E. Hallyn" <serge@hallyn.com>,
        containers@lists.linux-foundation.org,
        Dave Hansen <haveblue@us.ibm.com>, linux-kernel@vger.kernel.org,
        Andy Whitcroft <apw@canonical.com>, sukadev@linux.vnet.ibm.com,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Serge Hallyn <serge.hallyn@canonical.com>
References: <20120124000517.GA28878@sergelap>
	<CA+55aFz9ofF+Ey8VCDS8UEf2XSw36kj2RhkHfFScuzLXMeNrkA@mail.gmail.com>
	<20120124002555.GA29534@sergelap>
	<CA+55aFzwOU137V6wtyBjessx05NJo2G4KV0rvTKWvC79A+o9iQ@mail.gmail.com>
	<20120124010758.GJ23916@ZenIV.linux.org.uk>
	<m1k44gj1cu.fsf@fess.ebiederm.org> <20120124220247.GA26353@hallyn.com>
	<CAPXgP13_gczQmG_USAp0p2AuTfxkzAvzHvjbZY_rbbLH-4rDyg@mail.gmail.com>
	<20120124231601.GA4470@sergelap>
	<CAPXgP12REAwmDORzdGJhsxZKU8nhiauCxoVdKa8Eifw4MWWtgA@mail.gmail.com>
	<20120128195103.GA11299@sergelap> <87txup763i.fsf_-_@xmission.com>
Date: Sat, 22 Sep 2012 20:48:44 -0700
In-Reply-To: <87txup763i.fsf_-_@xmission.com> (Eric W. Biederman's message of
	"Sat, 22 Sep 2012 20:47:45 -0700")
Message-ID: <87obkx761v.fsf_-_@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18CaOQfhXMCXSgCQ0AHevpK5XDtR/HbgmA=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.5 XMGappySubj_01 Very gappy subject
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	* -0.0 BAYES_20 BODY: Bayes spam probability is 5 to 20%
	*      [score: 0.1701]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *;Greg Kroah-Hartman <gregkh@linuxfoundation.org>
X-Spam-Relay-Country: 
Subject: [PATCH 1/4] devpts: Remove CONFIG_DEVPTS_MULTIPLE_INSTANCES
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This compile option just makes the code more complicated and makes
it more difficult to transition to a time when we take advantage
of the new features that DEVPTS_MULTIPLE_INSTANCES allows.

Acked-by: "Serge E. Hallyn" <serge@hallyn.com>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 Documentation/filesystems/devpts.txt |   36 ++++++++++++---------------------
 drivers/tty/Kconfig                  |   11 ----------
 fs/devpts/inode.c                    |   28 --------------------------
 3 files changed, 13 insertions(+), 62 deletions(-)

diff --git a/Documentation/filesystems/devpts.txt b/Documentation/filesystems/devpts.txt
index 68dffd8..260cf6d 100644
--- a/Documentation/filesystems/devpts.txt
+++ b/Documentation/filesystems/devpts.txt
@@ -6,33 +6,23 @@ allocated in other instances of devpts.
 To preserve backward compatibility, this support for multiple instances is
 enabled only if:
 
-	- CONFIG_DEVPTS_MULTIPLE_INSTANCES=y, and
 	- '-o newinstance' mount option is specified while mounting devpts
 
 IOW, devpts now supports both single-instance and multi-instance semantics.
 
-If CONFIG_DEVPTS_MULTIPLE_INSTANCES=n, there is no change in behavior and
-this referred to as the "legacy" mode. In this mode, the new mount options
-(-o newinstance and -o ptmxmode) will be ignored with a 'bogus option' message
-on console.
-
-If CONFIG_DEVPTS_MULTIPLE_INSTANCES=y and devpts is mounted without the
-'newinstance' option (as in current start-up scripts) the new mount binds
-to the initial kernel mount of devpts. This mode is referred to as the
-'single-instance' mode and the current, single-instance semantics are
-preserved, i.e PTYs are common across the system.
-
-The only difference between this single-instance mode and the legacy mode
-is the presence of new, '/dev/pts/ptmx' node with permissions 0000, which
-can safely be ignored.
-
-If CONFIG_DEVPTS_MULTIPLE_INSTANCES=y and 'newinstance' option is specified,
-the mount is considered to be in the multi-instance mode and a new instance
-of the devpts fs is created. Any ptys created in this instance are independent
-of ptys in other instances of devpts. Like in the single-instance mode, the
-/dev/pts/ptmx node is present. To effectively use the multi-instance mode,
-open of /dev/ptmx must be a redirected to '/dev/pts/ptmx' using a symlink or
-bind-mount.
+If devpts is mounted without the 'newinstance' option (as in current
+start-up scripts) the new mount binds to the initial kernel mount of
+devpts. This mode is referred to as the 'single-instance' mode and the
+current, single-instance semantics are preserved, i.e PTYs are common
+across the system.
+
+If 'newinstance' option is specified, the mount is considered to be in
+the multi-instance mode and a new instance of the devpts fs is
+created. Any ptys created in this instance are independent of ptys in
+other instances of devpts. Like in the single-instance mode, the
+/dev/pts/ptmx node is present. To effectively use the multi-instance
+mode, open of /dev/ptmx must be a redirected to '/dev/pts/ptmx' using
+a symlink or bind-mount.
 
 Eg: A container startup script could do the following:
 
diff --git a/drivers/tty/Kconfig b/drivers/tty/Kconfig
index 830cd62..5e5cd3e 100644
--- a/drivers/tty/Kconfig
+++ b/drivers/tty/Kconfig
@@ -109,17 +109,6 @@ config UNIX98_PTYS
 	  All modern Linux systems use the Unix98 ptys.  Say Y unless
 	  you're on an embedded system and want to conserve memory.
 
-config DEVPTS_MULTIPLE_INSTANCES
-	bool "Support multiple instances of devpts"
-	depends on UNIX98_PTYS
-	default n
-	---help---
-	  Enable support for multiple instances of devpts filesystem.
-	  If you want to have isolated PTY namespaces (eg: in containers),
-	  say Y here.  Otherwise, say N. If enabled, each mount of devpts
-	  filesystem with the '-o newinstance' option will create an
-	  independent PTY namespace.
-
 config LEGACY_PTYS
 	bool "Legacy (BSD) PTY support"
 	default y
diff --git a/fs/devpts/inode.c b/fs/devpts/inode.c
index 14afbab..5f0d64e 100644
--- a/fs/devpts/inode.c
+++ b/fs/devpts/inode.c
@@ -115,11 +115,9 @@ static const match_table_t tokens = {
 	{Opt_uid, "uid=%u"},
 	{Opt_gid, "gid=%u"},
 	{Opt_mode, "mode=%o"},
-#ifdef CONFIG_DEVPTS_MULTIPLE_INSTANCES
 	{Opt_ptmxmode, "ptmxmode=%o"},
 	{Opt_newinstance, "newinstance"},
 	{Opt_max, "max=%d"},
-#endif
 	{Opt_err, NULL}
 };
 
@@ -136,10 +134,8 @@ static inline struct pts_fs_info *DEVPTS_SB(struct super_block *sb)
 
 static inline struct super_block *pts_sb_from_inode(struct inode *inode)
 {
-#ifdef CONFIG_DEVPTS_MULTIPLE_INSTANCES
 	if (inode->i_sb->s_magic == DEVPTS_SUPER_MAGIC)
 		return inode->i_sb;
-#endif
 	return devpts_mnt->mnt_sb;
 }
 
@@ -206,7 +202,6 @@ static int parse_mount_options(char *data, int op, struct pts_mount_opts *opts)
 				return -EINVAL;
 			opts->mode = option & S_IALLUGO;
 			break;
-#ifdef CONFIG_DEVPTS_MULTIPLE_INSTANCES
 		case Opt_ptmxmode:
 			if (match_octal(&args[0], &option))
 				return -EINVAL;
@@ -223,7 +218,6 @@ static int parse_mount_options(char *data, int op, struct pts_mount_opts *opts)
 				return -EINVAL;
 			opts->max = option;
 			break;
-#endif
 		default:
 			printk(KERN_ERR "devpts: called with bogus options\n");
 			return -EINVAL;
@@ -233,7 +227,6 @@ static int parse_mount_options(char *data, int op, struct pts_mount_opts *opts)
 	return 0;
 }
 
-#ifdef CONFIG_DEVPTS_MULTIPLE_INSTANCES
 static int mknod_ptmx(struct super_block *sb)
 {
 	int mode;
@@ -291,12 +284,6 @@ static void update_ptmx_mode(struct pts_fs_info *fsi)
 		inode->i_mode = S_IFCHR|fsi->mount_opts.ptmxmode;
 	}
 }
-#else
-static inline void update_ptmx_mode(struct pts_fs_info *fsi)
-{
-       return;
-}
-#endif
 
 static int devpts_remount(struct super_block *sb, int *flags, char *data)
 {
@@ -327,11 +314,9 @@ static int devpts_show_options(struct seq_file *seq, struct dentry *root)
 	if (opts->setgid)
 		seq_printf(seq, ",gid=%u", from_kgid_munged(&init_user_ns, opts->gid));
 	seq_printf(seq, ",mode=%03o", opts->mode);
-#ifdef CONFIG_DEVPTS_MULTIPLE_INSTANCES
 	seq_printf(seq, ",ptmxmode=%03o", opts->ptmxmode);
 	if (opts->max < NR_UNIX98_PTY_MAX)
 		seq_printf(seq, ",max=%d", opts->max);
-#endif
 
 	return 0;
 }
@@ -392,7 +377,6 @@ fail:
 	return -ENOMEM;
 }
 
-#ifdef CONFIG_DEVPTS_MULTIPLE_INSTANCES
 static int compare_init_pts_sb(struct super_block *s, void *p)
 {
 	if (devpts_mnt)
@@ -467,18 +451,6 @@ out_undo_sget:
 	return ERR_PTR(error);
 }
 
-#else
-/*
- * This supports only the legacy single-instance semantics (no
- * multiple-instance semantics)
- */
-static struct dentry *devpts_mount(struct file_system_type *fs_type, int flags,
-		const char *dev_name, void *data)
-{
-	return mount_single(fs_type, flags, data, devpts_fill_super);
-}
-#endif
-
 static void devpts_kill_sb(struct super_block *sb)
 {
 	struct pts_fs_info *fsi = DEVPTS_SB(sb);
-- 
1.7.5.4

