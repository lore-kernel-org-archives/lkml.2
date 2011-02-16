Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757298Ab1BPAVb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 19:21:31 -0500
Received: from kroah.org ([198.145.64.141]:39278 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757131Ab1BPAVY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:21:24 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:14:36 2011
Message-Id: <20110216001436.855492347@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:12:55 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dave Anderson <anderson@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [118/272] /proc/kcore: fix seeking
In-Reply-To: <20110216001559.GA31413@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dave Anderson <anderson@redhat.com>

commit ceff1a770933e2ca2bf995b453dade4ec47a9878 upstream.

Commit 34aacb2920 ("procfs: Use generic_file_llseek in /proc/kcore") broke
seeking on /proc/kcore.  This changes it back to use default_llseek in
order to restore the original behavior.

The problem with generic_file_llseek is that it only allows seeks up to
inode->i_sb->s_maxbytes, which is 2GB-1 on procfs, where the memory file
offset values in the /proc/kcore PT_LOAD segments may exceed or start
beyond that offset value.

A similar revert was made for /proc/vmcore.

Signed-off-by: Dave Anderson <anderson@redhat.com>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/proc/kcore.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/proc/kcore.c
+++ b/fs/proc/kcore.c
@@ -558,7 +558,7 @@ static int open_kcore(struct inode *inod
 static const struct file_operations proc_kcore_operations = {
 	.read		= read_kcore,
 	.open		= open_kcore,
-	.llseek		= generic_file_llseek,
+	.llseek		= default_llseek,
 };
 
 #ifdef CONFIG_MEMORY_HOTPLUG


