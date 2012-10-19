Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757897Ab2JSDIt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 23:08:49 -0400
Received: from mail.kernel.org ([198.145.19.201]:51868 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757518Ab2JSCsX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 22:48:23 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Malahal Naineni <malahal@us.ibm.com>,
        "J. Bruce Fields" <bfields@redhat.com>
Subject: [ 07/76] NFSD: pass null terminated buf to kstrtouint()
Date: Thu, 18 Oct 2012 19:46:31 -0700
Message-Id: <20121019024351.267009533@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121019024350.087156547@linuxfoundation.org>
References: <20121019024350.087156547@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Malahal Naineni <malahal@us.ibm.com>

commit 9959ba0c241a71c7ed8133401cfbbee2720da0b5 upstream.

The 'buf' is prepared with null termination with intention of using it for
this purpose, but 'name' is passed instead!

Signed-off-by: Malahal Naineni <malahal@us.ibm.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfsd/nfs4idmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/nfsd/nfs4idmap.c
+++ b/fs/nfsd/nfs4idmap.c
@@ -598,7 +598,7 @@ numeric_name_to_id(struct svc_rqst *rqst
 	/* Just to make sure it's null-terminated: */
 	memcpy(buf, name, namelen);
 	buf[namelen] = '\0';
-	ret = kstrtouint(name, 10, id);
+	ret = kstrtouint(buf, 10, id);
 	return ret == 0;
 }
 


