Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933570Ab3AIV2d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 16:28:33 -0500
Received: from mail.kernel.org ([198.145.19.201]:42544 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933418Ab3AIUjH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 15:39:07 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Nickolai Zeldovich <nickolai@csail.mit.edu>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [ 054/123] nfs: avoid dereferencing null pointer in initiate_bulk_draining
Date: Wed,  9 Jan 2013 12:34:53 -0800
Message-Id: <20130109201505.473704111@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130109201458.392601412@linuxfoundation.org>
References: <20130109201458.392601412@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nickolai Zeldovich <nickolai@csail.mit.edu>

commit ecf0eb9edbb607d74f74b73c14af8b43f3729528 upstream.

Fix an inverted null pointer check in initiate_bulk_draining().

Signed-off-by: Nickolai Zeldovich <nickolai@csail.mit.edu>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfs/callback_proc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/nfs/callback_proc.c
+++ b/fs/nfs/callback_proc.c
@@ -205,7 +205,7 @@ static u32 initiate_bulk_draining(struct
 
 		list_for_each_entry(lo, &server->layouts, plh_layouts) {
 			ino = igrab(lo->plh_inode);
-			if (ino)
+			if (!ino)
 				continue;
 			spin_lock(&ino->i_lock);
 			/* Is this layout in the process of being freed? */


