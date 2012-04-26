Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755930Ab2DZVUI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 17:20:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60363 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753398Ab2DZVUG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 17:20:06 -0400
Date: Thu, 26 Apr 2012 17:19:57 -0400
From: Dave Jones <davej@redhat.com>
To: Emil Goode <emilgoode@gmail.com>
Cc: swhiteho@redhat.com, cluster-devel@redhat.com,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] GFS2: Return -ENOMEM only if kmalloc fails
Message-ID: <20120426211957.GA9514@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Emil Goode <emilgoode@gmail.com>, swhiteho@redhat.com,
	cluster-devel@redhat.com, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
References: <1335474778-6252-1-git-send-email-emilgoode@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1335474778-6252-1-git-send-email-emilgoode@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 26, 2012 at 11:12:58PM +0200, Emil Goode wrote:
 > The error variable should be assigned the value of -ENOMEM
 > after the NULL check and not before.
 > 
 > Signed-off-by: Emil Goode <emilgoode@gmail.com>
 > ---
 >  fs/gfs2/acl.c |    2 +-
 >  1 file changed, 1 insertion(+), 1 deletion(-)
 > 
 > diff --git a/fs/gfs2/acl.c b/fs/gfs2/acl.c
 > index 230eb0f..90f6328 100644
 > --- a/fs/gfs2/acl.c
 > +++ b/fs/gfs2/acl.c
 > @@ -174,8 +174,8 @@ int gfs2_acl_chmod(struct gfs2_inode *ip, struct iattr *attr)
 >  
 >  	len = posix_acl_to_xattr(acl, NULL, 0);
 >  	data = kmalloc(len, GFP_NOFS);
 > -	error = -ENOMEM;
 >  	if (data == NULL)
 > +		error = -ENOMEM;
 >  		goto out;
 >  	posix_acl_to_xattr(acl, data, len);
 >  	error = gfs2_xattr_acl_chmod(ip, attr, data);

You missed the brackets on the if, introducing a bug that will cause it
to now always fail.

As 'error' gets overwritten in the successful case, there is no reason
to change this afaics.

	Dave
