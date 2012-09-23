Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753593Ab2IWDtq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2012 23:49:46 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:44174 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753470Ab2IWDto (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2012 23:49:44 -0400
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
Date: Sat, 22 Sep 2012 20:49:37 -0700
In-Reply-To: <87txup763i.fsf_-_@xmission.com> (Eric W. Biederman's message of
	"Sat, 22 Sep 2012 20:47:45 -0700")
Message-ID: <87ipb5760e.fsf_-_@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/3Uf5j2h2hNTXNAGIpTd2LVYir0wnK+lU=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_XMDrugObfuBody_14 obfuscated drug references
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Greg Kroah-Hartman <gregkh@linuxfoundation.org>
X-Spam-Relay-Country: 
Subject: [PATCH 2/4] devpts: Set the default permissions of /dev/pts/ptmx and /dev/ptmx to 0666
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


These are difference instances of the same device not so it only
makes sense that they would have the same default permissions.

Move the definitions of DEVPTS_DEEFAULT_PTMX_MODE and PTM_MINOR
into devpts_fs.h so we can use the same definitions throughout.

Acked-by: "Serge E. Hallyn" <serge@hallyn.com>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 drivers/tty/pty.c         |    6 +++---
 drivers/tty/tty_io.c      |    5 +++--
 fs/devpts/inode.c         |    8 --------
 include/linux/devpts_fs.h |    3 +++
 4 files changed, 9 insertions(+), 13 deletions(-)

diff --git a/drivers/tty/pty.c b/drivers/tty/pty.c
index 5505ffc..6beb7e1 100644
--- a/drivers/tty/pty.c
+++ b/drivers/tty/pty.c
@@ -722,10 +722,10 @@ static void __init unix98_pty_init(void)
 	ptmx_fops.open = ptmx_open;
 
 	cdev_init(&ptmx_cdev, &ptmx_fops);
-	if (cdev_add(&ptmx_cdev, MKDEV(TTYAUX_MAJOR, 2), 1) ||
-	    register_chrdev_region(MKDEV(TTYAUX_MAJOR, 2), 1, "/dev/ptmx") < 0)
+	if (cdev_add(&ptmx_cdev, MKDEV(TTYAUX_MAJOR, PTMX_MINOR), 1) ||
+	    register_chrdev_region(MKDEV(TTYAUX_MAJOR, PTMX_MINOR), 1, "/dev/ptmx") < 0)
 		panic("Couldn't register /dev/ptmx driver\n");
-	device_create(tty_class, NULL, MKDEV(TTYAUX_MAJOR, 2), NULL, "ptmx");
+	device_create(tty_class, NULL, MKDEV(TTYAUX_MAJOR, PTMX_MINOR), NULL, "ptmx");
 }
 
 #else
diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index b425c79..6c3a7c2 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -3314,9 +3314,10 @@ static char *tty_devnode(struct device *dev, umode_t *mode)
 {
 	if (!mode)
 		return NULL;
-	if (dev->devt == MKDEV(TTYAUX_MAJOR, 0) ||
-	    dev->devt == MKDEV(TTYAUX_MAJOR, 2))
+	if (dev->devt == MKDEV(TTYAUX_MAJOR, 0))
 		*mode = 0666;
+	if (dev->devt == MKDEV(TTYAUX_MAJOR, PTMX_MINOR))
+		*mode = DEVPTS_DEFAULT_PTMX_MODE;
 	return NULL;
 }
 
diff --git a/fs/devpts/inode.c b/fs/devpts/inode.c
index 5f0d64e..61b54aa 100644
--- a/fs/devpts/inode.c
+++ b/fs/devpts/inode.c
@@ -27,14 +27,6 @@
 #include <linux/seq_file.h>
 
 #define DEVPTS_DEFAULT_MODE 0600
-/*
- * ptmx is a new node in /dev/pts and will be unused in legacy (single-
- * instance) mode. To prevent surprises in user space, set permissions of
- * ptmx to 0. Use 'chmod' or remount with '-o ptmxmode' to set meaningful
- * permissions.
- */
-#define DEVPTS_DEFAULT_PTMX_MODE 0000
-#define PTMX_MINOR	2
 
 /*
  * sysctl support for setting limits on the number of Unix98 ptys allocated.
diff --git a/include/linux/devpts_fs.h b/include/linux/devpts_fs.h
index 5ce0e5f..2d539ae 100644
--- a/include/linux/devpts_fs.h
+++ b/include/linux/devpts_fs.h
@@ -15,6 +15,9 @@
 
 #include <linux/errno.h>
 
+#define DEVPTS_DEFAULT_PTMX_MODE 0666
+#define PTMX_MINOR	2
+
 #ifdef CONFIG_UNIX98_PTYS
 
 int devpts_new_index(struct inode *ptmx_inode);
-- 
1.7.5.4

