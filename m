Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751637Ab0CTLTt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Mar 2010 07:19:49 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:49298 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751315Ab0CTLTr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Mar 2010 07:19:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=PW0xFekhLWCofxDcguB0BNISHLADrItK220b/rdzgF3MRD/glvu4eGjrLAm3V2aGNL
         JD3BkTPFnrfOapqJ4wdq2+hEG1AQTv220POUSWsnNdGquRKvZYElrviWnyqvSCi116E5
         8xK3fqI9Tk6pNglDPrMU71cKnEyrxa8HMEz40=
Date: Sat, 20 Mar 2010 14:19:38 +0300
From: Dan Carpenter <error27@gmail.com>
To: David Howells <dhowells@redhat.com>
Cc: linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [patch] afs: potential null dereference
Message-ID: <20100320111938.GT5331@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	David Howells <dhowells@redhat.com>, linux-afs@lists.infradead.org,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It seems clear from the surrounding code that xpermits is allowed to be 
NULL here.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/fs/afs/security.c b/fs/afs/security.c
index 3ef5043..bb4ed14 100644
--- a/fs/afs/security.c
+++ b/fs/afs/security.c
@@ -189,8 +189,9 @@ void afs_cache_permit(struct afs_vnode *vnode, struct key *key, long acl_order)
 	if (!permits)
 		goto out_unlock;
 
-	memcpy(permits->permits, xpermits->permits,
-	       count * sizeof(struct afs_permit));
+	if (xpermits)
+		memcpy(permits->permits, xpermits->permits,
+			count * sizeof(struct afs_permit));
 
 	_debug("key %x access %x",
 	       key_serial(key), vnode->status.caller_access);
