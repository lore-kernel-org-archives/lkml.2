Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759129Ab2DZVbJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 17:31:09 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:49157 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755347Ab2DZVbH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 17:31:07 -0400
Message-ID: <1335475838.3035.4.camel@localhost>
Subject: Re: [PATCH] GFS2: Return -ENOMEM only if kmalloc fails
From: Emil Goode <emilgoode@gmail.com>
To: Oliver Neukum <oliver@neukum.org>
Cc: swhiteho@redhat.com, cluster-devel@redhat.com,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Date: Thu, 26 Apr 2012 23:30:38 +0200
In-Reply-To: <201204262314.02683.oliver@neukum.org>
References: <1335474778-6252-1-git-send-email-emilgoode@gmail.com>
	 <201204262314.02683.oliver@neukum.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I forgot the braces, embarrassing!
I see your point, thanks.

Best regards, Emil

On Thu, 2012-04-26 at 23:14 +0200, Oliver Neukum wrote:
> Am Donnerstag, 26. April 2012, 23:12:58 schrieb Emil Goode:
> > The error variable should be assigned the value of -ENOMEM
> > after the NULL check and not before.
> > 
> > Signed-off-by: Emil Goode <emilgoode@gmail.com>
> > ---
> >  fs/gfs2/acl.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/fs/gfs2/acl.c b/fs/gfs2/acl.c
> > index 230eb0f..90f6328 100644
> > --- a/fs/gfs2/acl.c
> > +++ b/fs/gfs2/acl.c
> > @@ -174,8 +174,8 @@ int gfs2_acl_chmod(struct gfs2_inode *ip, struct iattr *attr)
> >  
> >  	len = posix_acl_to_xattr(acl, NULL, 0);
> >  	data = kmalloc(len, GFP_NOFS);
> > -	error = -ENOMEM;
> >  	if (data == NULL)
> > +		error = -ENOMEM;
> >  		goto out;
> 
> Hint: read about the syntax of the if statement.
> Secondly, consider how the compiler can optimize the original.
> 
> 	Regards
> 		Oliver


