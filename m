Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756760Ab2EUCZL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2012 22:25:11 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:55714 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755985Ab2EUCZH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2012 22:25:07 -0400
X-Nat-Received: from [202.181.97.72]:64084 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1337567101.3031
To: ebiederm@xmission.com
Cc: sfr@canb.auug.org.au, linux-kernel@vger.kernel.org
Subject: Re: Please include user-namespace.git in linux-next
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <m11unyn70b.fsf@fess.ebiederm.org>
	<m1likyz4mh.fsf@fess.ebiederm.org>
In-Reply-To: <m1likyz4mh.fsf@fess.ebiederm.org>
Message-Id: <201205211125.GAF21848.tOFSVFHJLOQFMO@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Mon, 21 May 2012 11:25:01 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.44/RELEASE, bases: 20052012 #8068461, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think something is wrong with commit e1c972b6 "userns: Add negative depends
on entries to avoid building code that is userns unsafe".

With gcc 4.4.6 on CentOS 6.2, "make allnoconfig" where UIDGID_CONVERTED should
become y is showing

Symbol: USER_NS [=n]
Type  : boolean
Prompt: User namespace (EXPERIMENTAL)
  Defined at init/Kconfig:880
  Depends on: NAMESPACES [=y] && EXPERIMENTAL [=n] && UIDGID_CONVERTED [=n]
  Location:
    -> General setup
      -> Namespaces support (NAMESPACES [=y])
  Selects: UIDGID_STRICT_TYPE_CHECKS [=n]

.
I think this commit meant "!FOO" rather than "FOO = n",
othwewise there is no way for linux-next-20120518 to enable USER_NS.
----------------------------------------
PATCH: user_ns: Fix wrong dependency in UIDGID_CONVERTED.

"depends on FOO = n" should be "depends on !FOO".

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SKAURA.ne.jp>
----------
diff --git a/init/Kconfig b/init/Kconfig
index 20f6702..7316ed6 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -917,110 +917,110 @@ config UIDGID_CONVERTED
 
 	# List of kernel pieces that need user namespace work
 	# Features
-	depends on SYSVIPC = n
-	depends on IMA = n
-	depends on EVM = n
-	depends on KEYS = n
-	depends on AUDIT = n
-	depends on AUDITSYSCALL = n
-	depends on TASKSTATS = n
-	depends on TRACING = n
-	depends on FS_POSIX_ACL = n
-	depends on QUOTA = n
-	depends on QUOTACTL = n
-	depends on DEBUG_CREDENTIALS = n
-	depends on BSD_PROCESS_ACCT = n
-	depends on DRM = n
-	depends on PROC_EVENTS = n
+	depends on !SYSVIPC
+	depends on !IMA
+	depends on !EVM
+	depends on !KEYS
+	depends on !AUDIT
+	depends on !AUDITSYSCALL
+	depends on !TASKSTATS
+	depends on !TRACING
+	depends on !FS_POSIX_ACL
+	depends on !QUOTA
+	depends on !QUOTACTL
+	depends on !DEBUG_CREDENTIALS
+	depends on !BSD_PROCESS_ACCT
+	depends on !DRM
+	depends on !PROC_EVENTS
 
 	# Networking
-	depends on NET = n
-	depends on NET_9P = n
-	depends on IPX = n
-	depends on PHONET = n
-	depends on NET_CLS_FLOW = n
-	depends on NETFILTER_XT_MATCH_OWNER = n
-	depends on NETFILTER_XT_MATCH_RECENT = n
-	depends on NETFILTER_XT_TARGET_LOG = n
-	depends on NETFILTER_NETLINK_LOG = n
-	depends on INET = n
-	depends on IPV6 = n
-	depends on IP_SCTP = n
-	depends on AF_RXRPC = n
-	depends on LLC2 = n
-	depends on NET_KEY = n
-	depends on INET_DIAG = n
-	depends on DNS_RESOLVER = n
-	depends on AX25 = n
-	depends on ATALK = n
+	depends on !NET
+	depends on !NET_9P
+	depends on !IPX
+	depends on !PHONET
+	depends on !NET_CLS_FLOW
+	depends on !NETFILTER_XT_MATCH_OWNER
+	depends on !NETFILTER_XT_MATCH_RECENT
+	depends on !NETFILTER_XT_TARGET_LOG
+	depends on !NETFILTER_NETLINK_LOG
+	depends on !INET
+	depends on !IPV6
+	depends on !IP_SCTP
+	depends on !AF_RXRPC
+	depends on !LLC2
+	depends on !NET_KEY
+	depends on !INET_DIAG
+	depends on !DNS_RESOLVER
+	depends on !AX25
+	depends on !ATALK
 
 	# Filesystems
-	depends on USB_DEVICEFS = n
-	depends on USB_GADGETFS = n
-	depends on USB_FUNCTIONFS = n
-	depends on DEVTMPFS = n
-	depends on XENFS = n
-
-	depends on 9P_FS = n
-	depends on ADFS_FS = n
-	depends on AFFS_FS = n
-	depends on AFS_FS = n
-	depends on AUTOFS4_FS = n
-	depends on BEFS_FS = n
-	depends on BFS_FS = n
-	depends on BTRFS_FS = n
-	depends on CEPH_FS = n
-	depends on CIFS = n
-	depends on CODA_FS = n
-	depends on CONFIGFS_FS = n
-	depends on CRAMFS = n
-	depends on DEBUG_FS = n
-	depends on ECRYPT_FS = n
-	depends on EFS_FS = n
-	depends on EXOFS_FS = n
-	depends on FAT_FS = n
-	depends on FUSE_FS = n
-	depends on GFS2_FS = n
-	depends on HFS_FS = n
-	depends on HFSPLUS_FS = n
-	depends on HPFS_FS = n
-	depends on HUGETLBFS = n
-	depends on ISO9660_FS = n
-	depends on JFFS2_FS = n
-	depends on JFS_FS = n
-	depends on LOGFS = n
-	depends on MINIX_FS = n
-	depends on NCP_FS = n
-	depends on NFSD = n
-	depends on NFS_FS = n
-	depends on NILFS2_FS = n
-	depends on NTFS_FS = n
-	depends on OCFS2_FS = n
-	depends on OMFS_FS = n
-	depends on QNX4FS_FS = n
-	depends on QNX6FS_FS = n
-	depends on REISERFS_FS = n
-	depends on SQUASHFS = n
-	depends on SYSV_FS = n
-	depends on UBIFS_FS = n
-	depends on UDF_FS = n
-	depends on UFS_FS = n
-	depends on VXFS_FS = n
-	depends on XFS_FS = n
-
-	depends on !UML || HOSTFS = n
+	depends on !USB_DEVICEFS
+	depends on !USB_GADGETFS
+	depends on !USB_FUNCTIONFS
+	depends on !DEVTMPFS
+	depends on !XENFS
+
+	depends on !9P_FS
+	depends on !ADFS_FS
+	depends on !AFFS_FS
+	depends on !AFS_FS
+	depends on !AUTOFS4_FS
+	depends on !BEFS_FS
+	depends on !BFS_FS
+	depends on !BTRFS_FS
+	depends on !CEPH_FS
+	depends on !CIFS
+	depends on !CODA_FS
+	depends on !CONFIGFS_FS
+	depends on !CRAMFS
+	depends on !DEBUG_FS
+	depends on !ECRYPT_FS
+	depends on !EFS_FS
+	depends on !EXOFS_FS
+	depends on !FAT_FS
+	depends on !FUSE_FS
+	depends on !GFS2_FS
+	depends on !HFS_FS
+	depends on !HFSPLUS_FS
+	depends on !HPFS_FS
+	depends on !HUGETLBFS
+	depends on !ISO9660_FS
+	depends on !JFFS2_FS
+	depends on !JFS_FS
+	depends on !LOGFS
+	depends on !MINIX_FS
+	depends on !NCP_FS
+	depends on !NFSD
+	depends on !NFS_FS
+	depends on !NILFS2_FS
+	depends on !NTFS_FS
+	depends on !OCFS2_FS
+	depends on !OMFS_FS
+	depends on !QNX4FS_FS
+	depends on !QNX6FS_FS
+	depends on !REISERFS_FS
+	depends on !SQUASHFS
+	depends on !SYSV_FS
+	depends on !UBIFS_FS
+	depends on !UDF_FS
+	depends on !UFS_FS
+	depends on !VXFS_FS
+	depends on !XFS_FS
+
+	depends on !UML || !HOSTFS
 
 	# The rare drivers that won't build
-	depends on AIRO = n
-	depends on AIRO_CS = n
-	depends on TUN = n
-	depends on INFINIBAND_QIB = n
-	depends on BLK_DEV_LOOP = n
-	depends on ANDROID_BINDER_IPC = n
+	depends on !AIRO
+	depends on !AIRO_CS
+	depends on !TUN
+	depends on !INFINIBAND_QIB
+	depends on !BLK_DEV_LOOP
+	depends on !ANDROID_BINDER_IPC
 
 	# Security modules
-	depends on SECURITY_TOMOYO = n
-	depends on SECURITY_APPARMOR = n
+	depends on !SECURITY_TOMOYO
+	depends on !SECURITY_APPARMOR
 
 config UIDGID_STRICT_TYPE_CHECKS
 	bool "Require conversions between uid/gids and their internal representation"
