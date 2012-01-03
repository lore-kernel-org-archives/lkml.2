Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756333Ab2ACWld (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 17:41:33 -0500
Received: from cantor2.suse.de ([195.135.220.15]:40374 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756319Ab2ACWl0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 17:41:26 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Jan  3 14:33:23 2012
Message-Id: <20120103223323.181525056@clark.kroah.org>
User-Agent: quilt/0.50-25.1
Date: Tue, 03 Jan 2012 14:32:59 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [26/75] NFS: Fix a regression in nfs_file_llseek()
In-Reply-To: <20120103223332.GA4112@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <Trond.Myklebust@netapp.com>

commit 6c52961743f38747401b47127b82159ab6d8a7a4 upstream.

After commit 06222e491e663dac939f04b125c9dc52126a75c4 (fs: handle
SEEK_HOLE/SEEK_DATA properly in all fs's that define their own llseek)
the behaviour of llseek() was changed so that it always revalidates
the file size. The bug appears to be due to a logic error in the
afore-mentioned commit, which always evaluates to 'true'.

Reported-by: Roel Kluin <roel.kluin@gmail.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/nfs/file.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/nfs/file.c
+++ b/fs/nfs/file.c
@@ -191,7 +191,7 @@ static loff_t nfs_file_llseek(struct fil
 	 * origin == SEEK_END || SEEK_DATA || SEEK_HOLE => we must revalidate
 	 * the cached file length
 	 */
-	if (origin != SEEK_SET || origin != SEEK_CUR) {
+	if (origin != SEEK_SET && origin != SEEK_CUR) {
 		struct inode *inode = filp->f_mapping->host;
 
 		int retval = nfs_revalidate_file_size(inode, filp);


