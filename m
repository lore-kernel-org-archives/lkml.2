Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934754Ab1KJD0w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 22:26:52 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42308 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934739Ab1KJD0p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:26:45 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:27:10 2011
Message-Id: <20111109212710.409160780@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:27:00 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Bryan Schumaker <bjschuma@netapp.com>,
        Christoph Hellwig <hch@lst.de>
Subject: [098/262] vfs: add "device" tag to /proc/self/mountstats
In-Reply-To: <20111109212847.GA20838@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bryan Schumaker <bjschuma@netapp.com>

commit a877ee03ac010ded434b77f7831f43cbb1fcc60f upstream.

nfsiostat was failing to find mounted filesystems on kernels after
2.6.38 because of changes to show_vfsstat() by commit
c7f404b40a3665d9f4e9a927cc5c1ee0479ed8f9.  This patch adds back the
"device" tag before the nfs server entry so scripts can parse the
mountstats file correctly.

Signed-off-by: Bryan Schumaker <bjschuma@netapp.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/namespace.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -1109,6 +1109,7 @@ static int show_vfsstat(struct seq_file
 
 	/* device */
 	if (mnt->mnt_sb->s_op->show_devname) {
+		seq_puts(m, "device ");
 		err = mnt->mnt_sb->s_op->show_devname(m, mnt);
 	} else {
 		if (mnt->mnt_devname) {


