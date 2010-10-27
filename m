Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761355Ab0J0QOm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 12:14:42 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:49264 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753447Ab0J0QOj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 12:14:39 -0400
Date: Wed, 27 Oct 2010 12:14:32 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Jeff Layton <jlayton@redhat.com>
Cc: Jiri Slaby <jslaby@suse.cz>, sfrench@samba.org,
        linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        linux-cifs@vger.kernel.org
Subject: Re: [PATCH 2/4] FS: cifs, remove unneeded NULL tests
Message-ID: <20101027161431.GA20363@infradead.org>
References: <1288180220-19869-1-git-send-email-jslaby@suse.cz>
 <20101027121338.2984b9d8@corrin.poochiereds.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101027121338.2984b9d8@corrin.poochiereds.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 27, 2010 at 12:13:38PM -0400, Jeff Layton wrote:
> > diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> > index 45af003..db7eaf7 100644
> > --- a/fs/cifs/file.c
> > +++ b/fs/cifs/file.c
> > @@ -1031,7 +1031,7 @@ ssize_t cifs_user_write(struct file *file, const char __user *write_data,
> >  	cifs_stats_bytes_written(pTcon, total_written);
> >  
> >  	/* since the write may have blocked check these pointers again */
> > -	if ((file->f_path.dentry) && (file->f_path.dentry->d_inode)) {
> > +	if (file->f_path.dentry->d_inode) {
> 
> 		^^^^^^
> 	This check is bogus too. An open filp on a negative dentry
> 	isn't possible, right?

Indeed, it's impossible.

