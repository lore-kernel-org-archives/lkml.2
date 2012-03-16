Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757188Ab2CPN3R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 09:29:17 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:53139 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753570Ab2CPN3P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 09:29:15 -0400
Message-ID: <1331904553.5406.34.camel@joe2Laptop>
Subject: Re: [take 3] pohmelfs: call for inclusion
From: Joe Perches <joe@perches.com>
To: Evgeniy Polyakov <zbr@ioremap.net>
Cc: linux-kernel@vger.kernel.org, greg@kroah.com,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux-fsdevel@vger.kernel.org
Date: Fri, 16 Mar 2012 06:29:13 -0700
In-Reply-To: <20120316121829.GA12685@ioremap.net>
References: <20120316121829.GA12685@ioremap.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-03-16 at 16:18 +0400, Evgeniy Polyakov wrote:
> I'm please to announce new and completely rewritten distributed
> filesystem - POHMELFS

Unfortunately, it doesn't compile against -next.

+static int pohmelfs_fill_super(struct super_block *sb, void *data, int silent)
[]
+	sb->s_root = d_alloc_root(&psb->root->vfs_inode);

	
commit 4f7e69f8eb314b1dd187026cca2bba5245caf75a
Author: Al Viro <viro@zeniv.linux.org.uk>
Date:   Sun Feb 12 22:15:47 2012 -0500

    vfs: d_alloc_root() gone
    
    all callers converted to d_make_root() by now
    
    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

Documentation/filesystems/porting:
[mandatory]
	d_alloc_root() is gone, along with a lot of bugs caused by code
misusing it.  Replacement: d_make_root(inode).  The difference is,
d_make_root() drops the reference to inode if dentry allocation fails.  


