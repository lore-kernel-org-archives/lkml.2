Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754000Ab0DUKax (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 06:30:53 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:59013 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753952Ab0DUKav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 06:30:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=EYxP//fpVQUhqIf/yYC7mquqOw+obLkgBcZZrXvP3RKhcQiQGEf3swzS3Ipyw3Ipr9
         I7CnaaNTeU3Uirb9ZlvUqfiTpGtZTo4PYA2e64Nt/sQvrCm/PKbUAQ+4z5LdVTuRRCAn
         vgeoPheNe5QhxkjTtJQBWzz3IJIlgTUrH+DAs=
Date: Wed, 21 Apr 2010 12:30:32 +0200
From: Dan Carpenter <error27@gmail.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [patch] fs/sysv: dereferencing ERR_PTR()
Message-ID: <20100421103032.GB29647@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Christoph Hellwig <hch@infradead.org>,
	Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I moved the dir_put_page() inside the if condition so we don't dereference
"page", if it's an ERR_PTR().

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/fs/sysv/dir.c b/fs/sysv/dir.c
index 4e50286..1dabed2 100644
--- a/fs/sysv/dir.c
+++ b/fs/sysv/dir.c
@@ -164,8 +164,8 @@ struct sysv_dir_entry *sysv_find_entry(struct dentry *dentry, struct page **res_
 							name, de->name))
 					goto found;
 			}
+			dir_put_page(page);
 		}
-		dir_put_page(page);
 
 		if (++n >= npages)
 			n = 0;
