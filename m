Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756916Ab2IMAKx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 20:10:53 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:64318 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932806Ab2ILXjZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 19:39:25 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Bryan Schumaker <bjschuma@netapp.com>,
        William Dauchy <wdauchy@gmail.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [ 29/85] NFS: return -ENOKEY when the upcall fails to map the name
Date: Wed, 12 Sep 2012 16:36:12 -0700
Message-Id: <20120912233544.792293893@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120912233541.747973832@linuxfoundation.org>
References: <20120912233541.747973832@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bryan Schumaker <bjschuma@netapp.com>

commit 12dfd080556124088ed61a292184947711b46cbe upstream.

This allows the normal error-paths to handle the error, rather than
making a special call to complete_request_key() just for this instance.

Signed-off-by: Bryan Schumaker <bjschuma@netapp.com>
Tested-by: William Dauchy <wdauchy@gmail.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfs/idmap.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/fs/nfs/idmap.c
+++ b/fs/nfs/idmap.c
@@ -747,9 +747,8 @@ idmap_pipe_downcall(struct file *filp, c
 	}
 
 	if (!(im.im_status & IDMAP_STATUS_SUCCESS)) {
-		ret = mlen;
-		complete_request_key(cons, -ENOKEY);
-		goto out_incomplete;
+		ret = -ENOKEY;
+		goto out;
 	}
 
 	namelen_in = strnlen(im.im_name, IDMAP_NAMESZ);
@@ -766,7 +765,6 @@ idmap_pipe_downcall(struct file *filp, c
 
 out:
 	complete_request_key(cons, ret);
-out_incomplete:
 	return ret;
 }
 


