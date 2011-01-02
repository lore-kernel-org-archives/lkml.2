Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753502Ab1ACCuE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 21:50:04 -0500
Received: from thunk.org ([69.25.196.29]:32960 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751782Ab1ACCuB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 21:50:01 -0500
Date: Sun, 2 Jan 2011 18:21:01 -0500
From: "Ted Ts'o" <tytso@mit.edu>
To: Andreas Gruenbacher <agruen@suse.de>
Cc: Jeff Layton <jlayton@redhat.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        sfrench@us.ibm.com, ffilz@us.ibm.com, adilger@sun.com,
        sandeen@redhat.com, bfields@citi.umich.edu,
        linux-fsdevel@vger.kernel.org, nfsv4@linux-nfs.org,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -V4 08/11] vfs: Add new file and directory create
 permission flags
Message-ID: <20110102232101.GB11955@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Andreas Gruenbacher <agruen@suse.de>,
	Jeff Layton <jlayton@redhat.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	sfrench@us.ibm.com, ffilz@us.ibm.com, adilger@sun.com,
	sandeen@redhat.com, bfields@citi.umich.edu,
	linux-fsdevel@vger.kernel.org, nfsv4@linux-nfs.org,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1285332494-12756-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1285332494-12756-9-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <20100924115423.530813c3@tlielax.poochiereds.net>
 <201009271514.00279.agruen@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201009271514.00279.agruen@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I was going through some old patches in the ext4 patchwork list, and
came across this.  It looks like this patch has never been applied to
mainline.  If it's a "clear improvement", any reason not to submit it?

Regards,

	      	     	    		      - Ted

On Mon, Sep 27, 2010 at 03:14:00PM +0200, Andreas Gruenbacher wrote:
> 
> Ah, you mean this:
> 
> --- a/fs/namei.c
> +++ b/fs/namei.c
> @@ -2450,7 +2450,9 @@ int vfs_link(struct dentry *old_dentry, struct inode *dir, struct dentry *new_de
>  	if (!inode)
>  		return -ENOENT;
>  
> -	error = may_create(dir, new_dentry, S_ISDIR(inode->i_mode));
> +	if (S_ISDIR(inode->i_mode))
> +		return -EPERM;
> +	error = may_create(dir, new_dentry, 0);
>  	if (error)
>  		return error;
>  
> @@ -2464,8 +2466,6 @@ int vfs_link(struct dentry *old_dentry, struct inode *dir, struct dentry *new_de
>  		return -EPERM;
>  	if (!dir->i_op->link)
>  		return -EPERM;
> -	if (S_ISDIR(inode->i_mode))
> -		return -EPERM;
>  
>  	error = security_inode_link(old_dentry, dir, new_dentry);
>  	if (error)
> 
> This is a clear improvement; I don't think it matters that user-space will
> get -EPERM instead of -EXDEV when trying to hard-link a directory across
> devices.
> 
> Thanks,
> Andreas
