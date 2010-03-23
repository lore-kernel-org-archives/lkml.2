Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752572Ab0CWL0n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 07:26:43 -0400
Received: from mail-fx0-f213.google.com ([209.85.220.213]:46695 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752493Ab0CWL0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 07:26:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=m6aDynvpWeX7+dK2qShFQovo3ZH4ANpLG5GY/lzB35SDWwtff+GaSckJ+8j4uX3Mpf
         8qmxF1bcCaRo37zzYZJv7CB/74xkA5v4h3zldf7w3enSttooP8aYA+0Drfo4BISlpQUQ
         qxEEQJ9ShKBqz3QShTrSmEPJ2od+qbc5gx6bY=
Date: Tue, 23 Mar 2010 14:26:29 +0300
From: Dan Carpenter <error27@gmail.com>
To: David Howells <dhowells@redhat.com>
Cc: Steve Dickson <steved@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
       Trond Myklebust <Trond.Myklebust@netapp.com>,
       Daire Byrne <Daire.Byrne@framestore.com>, linux-cachefs@redhat.com,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] fscache: add missing unlock
Message-ID: <20100323112629.GX21571@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	David Howells <dhowells@redhat.com>,
	Steve Dickson <steved@redhat.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Trond Myklebust <Trond.Myklebust@netapp.com>,
	Daire Byrne <Daire.Byrne@framestore.com>, linux-cachefs@redhat.com,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sparse complained about this missing spin_unlock()

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/fs/fscache/page.c b/fs/fscache/page.c
index c598ea4..6980902 100644
--- a/fs/fscache/page.c
+++ b/fs/fscache/page.c
@@ -881,6 +881,7 @@ submit_failed:
 	goto nobufs;
 
 nobufs_unlock_obj:
+	spin_unlock(&cookie->stores_lock);
 	spin_unlock(&object->lock);
 nobufs:
 	spin_unlock(&cookie->lock);
