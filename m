Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753394Ab0DIOCA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 10:02:00 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36398 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753074Ab0DIOBb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 10:01:31 -0400
From: Jan Blunck <jblunck@suse.de>
To: Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
       Alan Cox <alan@linux.intel.com>, Jan Blunck <jblunck@suse.de>,
       Christoph Hellwig <hch@infradead.org>, John Kacur <jkacur@redhat.com>
Subject: [PATCH 12/12] Documentation/filesystems/Locking: Update documentation on llseek() wrt BKL
Date: Fri,  9 Apr 2010 16:00:55 +0200
Message-Id: <1270821655-4368-13-git-send-email-jblunck@suse.de>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1270821655-4368-1-git-send-email-jblunck@suse.de>
References: <1270821655-4368-1-git-send-email-jblunck@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The inode's i_size is not protected by the big kernel lock. Therefore it
does not make sense to recommend taking the BKL in filesystems llseek
operations. Instead it should use the inode's mutex or use just use
i_size_read() instead. Add a note that this is not protecting file->f_pos.

Signed-off-by: Jan Blunck <jblunck@suse.de>
Acked-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: John Kacur <jkacur@redhat.com>
---
 Documentation/filesystems/Locking |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/Documentation/filesystems/Locking b/Documentation/filesystems/Locking
index 06bbbed..3cfe165 100644
--- a/Documentation/filesystems/Locking
+++ b/Documentation/filesystems/Locking
@@ -429,8 +429,9 @@ check_flags:		no
 implementations.  If your fs is not using generic_file_llseek, you
 need to acquire and release the appropriate locks in your ->llseek().
 For many filesystems, it is probably safe to acquire the inode
-semaphore.  Note some filesystems (i.e. remote ones) provide no
-protection for i_size so you will need to use the BKL.
+mutex or just to use i_size_read() instead.
+Note: this does not protect the file->f_pos against concurrent modifications
+since this is something the userspace has to take care about.
 
 Note: ext2_release() was *the* source of contention on fs-intensive
 loads and dropping BKL on ->release() helps to get rid of that (we still
-- 
1.6.4.2

