Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759550Ab2CMMJM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 08:09:12 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:49431
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755944Ab2CMMJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 08:09:07 -0400
Date: Tue, 13 Mar 2012 08:09:06 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, hch@infradead.org,
        Trond.Myklebust@netapp.com, sfrench@samba.org, sage@newdream.net,
        ericvh@gmail.com, mszeredi@suse.cz
Subject: Re: [PATCH 09/25] nfs: remove nfs4 specific create function
Message-ID: <20120313120906.GC27171@infradead.org>
References: <1331155362-11132-1-git-send-email-miklos@szeredi.hu>
 <1331155362-11132-10-git-send-email-miklos@szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331155362-11132-10-git-send-email-miklos@szeredi.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 07, 2012 at 10:22:26PM +0100, Miklos Szeredi wrote:
> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> Make nfs_atomic_open() work for non-open creates.  This is trivial to do and
> allows the NFSv4 specific create code to be removed.
> 
> Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
> ---
>  fs/nfs/dir.c      |   28 ++++++++++++++++++++--------
>  fs/nfs/nfs4proc.c |   31 -------------------------------
>  2 files changed, 20 insertions(+), 39 deletions(-)
> 
> diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
> index 24bf3c9..8627965 100644
> --- a/fs/nfs/dir.c
> +++ b/fs/nfs/dir.c
> @@ -114,10 +114,13 @@ const struct inode_operations nfs3_dir_inode_operations = {
>  static struct file *nfs_atomic_open(struct inode *, struct dentry *,
>  				    struct opendata *, unsigned, umode_t,
>  				    bool *);
> +static struct file *nfs_atomic_open_common(struct inode *, struct dentry *,
> +					   struct opendata *, unsigned,
> +					   umode_t);
>  const struct inode_operations nfs4_dir_inode_operations = {
> -	.create		= nfs_create,
>  	.lookup		= nfs_lookup,
>  	.atomic_open	= nfs_atomic_open,
> +	.atomic_create	= nfs_atomic_open_common, /* called for mknod */

Can you please name the methods after the interface they implement,
e.g. do a s/nfs_atomic_open_common/nfs_atomic_create/g here, and
similar transformations for the other filesystems.
