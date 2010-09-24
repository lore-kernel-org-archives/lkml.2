Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932714Ab0IXQ2e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 12:28:34 -0400
Received: from kroah.org ([198.145.64.141]:38384 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932703Ab0IXQ2b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 12:28:31 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Sep 24 09:26:18 2010
Message-Id: <20100924162618.707924389@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 24 Sep 2010 09:24:32 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Arnd Bergmann <arnd@arndb.de>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [44/80] /proc/vmcore: fix seeking
In-Reply-To: <20100924162706.GA7381@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

commit c227e69028473c7c7994a9b0a2cc0034f3f7e0fe upstream.

Commit 73296bc611 ("procfs: Use generic_file_llseek in /proc/vmcore")
broke seeking on /proc/vmcore.  This changes it back to use default_llseek
in order to restore the original behaviour.

The problem with generic_file_llseek is that it only allows seeks up to
inode->i_sb->s_maxbytes, which is zero on procfs and some other virtual
file systems.  We should merge generic_file_llseek and default_llseek some
day and clean this up in a proper way, but for 2.6.35/36, reverting vmcore
is the safer solution.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Reported-by: CAI Qian <caiqian@redhat.com>
Tested-by: CAI Qian <caiqian@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/proc/vmcore.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/proc/vmcore.c
+++ b/fs/proc/vmcore.c
@@ -163,7 +163,7 @@ static ssize_t read_vmcore(struct file *
 
 static const struct file_operations proc_vmcore_operations = {
 	.read		= read_vmcore,
-	.llseek		= generic_file_llseek,
+	.llseek		= default_llseek,
 };
 
 static struct vmcore* __init get_new_element(void)


