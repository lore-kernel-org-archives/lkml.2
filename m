Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964859Ab2DKXRb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 19:17:31 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:63303 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964838Ab2DKXR2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 19:17:28 -0400
Message-Id: <20120411231029.862154109@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Wed, 11 Apr 2012 16:11:26 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Sachin Prabhu <sprabhu@redhat.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        Josh Boyer <jwboyer@redhat.com>
Subject: [ 68/78] Fix length of buffer copied in __nfs4_get_acl_uncached
In-Reply-To: <20120411231102.GA6404@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sachin Prabhu <sprabhu@redhat.com>

commit 20e0fa98b751facf9a1101edaefbc19c82616a68 upstream.

_copy_from_pages() used to copy data from the temporary buffer to the
user passed buffer is passed the wrong size parameter when copying
data. res.acl_len contains both the bitmap and acl lenghts while
acl_len contains the acl length after adjusting for the bitmap size.

Signed-off-by: Sachin Prabhu <sprabhu@redhat.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: Josh Boyer <jwboyer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfs/nfs4proc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -3625,7 +3625,7 @@ static ssize_t __nfs4_get_acl_uncached(s
 		if (acl_len > buflen)
 			goto out_free;
 		_copy_from_pages(buf, pages, res.acl_data_offset,
-				res.acl_len);
+				acl_len);
 	}
 	ret = acl_len;
 out_free:


