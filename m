Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759723Ab2EDUoH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 16:44:07 -0400
Received: from mail-pz0-f45.google.com ([209.85.210.45]:61380 "EHLO
	mail-pz0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759706Ab2EDUoF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 16:44:05 -0400
Message-Id: <20120504204224.797475373@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 04 May 2012 13:42:29 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Fred Isaman <iisaman@netapp.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [ 05/75] NFS: put open context on error in nfs_flush_multi
In-Reply-To: <20120504204258.GA12552@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fred Isaman <iisaman@netapp.com>

commit 8ccd271f7a3a846ce6f85ead0760d9d12994a611 upstream.

Signed-off-by: Fred Isaman <iisaman@netapp.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfs/write.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/nfs/write.c
+++ b/fs/nfs/write.c
@@ -974,7 +974,7 @@ out_bad:
 	while (!list_empty(res)) {
 		data = list_entry(res->next, struct nfs_write_data, list);
 		list_del(&data->list);
-		nfs_writedata_free(data);
+		nfs_writedata_release(data);
 	}
 	nfs_redirty_request(req);
 	return -ENOMEM;


