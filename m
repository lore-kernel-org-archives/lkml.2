Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763025Ab2KBRHv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 13:07:51 -0400
Received: from mail.kernel.org ([198.145.19.201]:33367 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762975Ab2KBRHk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 13:07:40 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        David Zafman <david.zafman@inktank.com>, Sage Weil <sage@inktank.com>
Subject: [ 11/24] ceph: fix dentry reference leak in encode_fh()
Date: Fri,  2 Nov 2012 10:06:59 -0700
Message-Id: <20121102170248.233743588@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc3.16.g8ead1bf
In-Reply-To: <20121102170247.406319110@linuxfoundation.org>
References: <20121102170247.406319110@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Zafman <david.zafman@inktank.com>

commit 52eb5a900a9863a8b77a895f770e5d825c8e02c6 upstream.

Call to d_find_alias() needs a corresponding dput()

This fixes http://tracker.newdream.net/issues/3271

Signed-off-by: David Zafman <david.zafman@inktank.com>
Reviewed-by: Sage Weil <sage@inktank.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ceph/export.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/ceph/export.c
+++ b/fs/ceph/export.c
@@ -90,6 +90,8 @@ static int ceph_encode_fh(struct inode *
 		*max_len = handle_length;
 		type = 255;
 	}
+	if (dentry)
+		dput(dentry);
 	return type;
 }
 


