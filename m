Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756662Ab1DLDSV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 23:18:21 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:63609 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756577Ab1DLDSU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 23:18:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=QhKMrGf1jOuO1XpGmkJnqTd8ZGCPOiQ/mdKpaLJLBGURcCYeJGZgtAF44yYXzKbnTz
         eYgf1LDQaWcm+y6EeOXsSs4B2Bd6l4nXrN5+aCrDDkqASECWF2sI/ypCAfMyulyMz9o8
         suM2UadvSMw0vi848ftxveWQYgV4gl8skUd+Y=
Date: Tue, 12 Apr 2011 11:17:39 +0800
From: Harry Wei <jiaweiwei.xiyou@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: tim.gardner@canonical.com, linux-kernel@vger.kernel.org,
        petr@vandrovec.name, viro@zeniv.linux.org.uk, arnd@arndb.de,
        npiggin@kernel.dk, jens.axboe@oracle.com, greg@kroah.com,
        joe@perches.com
Subject: Re: [PATCH]initialize the array of fs/ncpfs/inode.c
Message-ID: <20110412031736.GA3155@gmail.com>
Mail-Followup-To: Andrew Morton <akpm@linux-foundation.org>,
	tim.gardner@canonical.com, linux-kernel@vger.kernel.org,
	petr@vandrovec.name, viro@zeniv.linux.org.uk, arnd@arndb.de,
	npiggin@kernel.dk, jens.axboe@oracle.com, greg@kroah.com,
	joe@perches.com
References: <20110410100816.GB4953@gmail.com>
 <20110411161838.dabbc3f3.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110411161838.dabbc3f3.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 11, 2011 at 04:18:38PM -0700, Andrew Morton wrote:
> On Sun, 10 Apr 2011 18:08:18 +0800
> Harry Wei <jiaweiwei.xiyou@gmail.com> wrote:
> 
> > fs/ncpfs/inode.c: In function 'ncp_fill_super':
> > fs/ncpfs/inode.c:451: warning: 'data.mounted_vol[1u]' may be used 
> 
> It's notabug, but we can easily fix it with a memset().
> 
> Reported-by: Harry Wei <jiaweiwei.xiyou@gmail.com>
> Cc: Petr Vandrovec <petr@vandrovec.name>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  fs/ncpfs/inode.c |    4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
>  
> -	data.wdog_pid = NULL;
> +	memset(data, 0, sizeof(data));
Hi Morton,
	It really need a '&' for data, i think. So i have corrected
your patch like following.

Thanks.
Harry Wei.

Reported-by: Harry Wei <jiaweiwei.xiyou@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Harry Wei <jiaweiwei.xiyou@gmail.com>
---

 fs/ncpfs/inode.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN fs/ncpfs/inode.c~fs-ncpfs-inodec-suppress-used-uninitialised-warning fs/ncpfs/inode.c
--- a/fs/ncpfs/inode.c~fs-ncpfs-inodec-suppress-used-uninitialised-warning
+++ a/fs/ncpfs/inode.c
@@ -461,7 +461,7 @@ static int ncp_fill_super(struct super_b
 #endif
       struct ncp_entry_info finfo;

-      data.wdog_pid = NULL;
+       memset(&data, 0, sizeof(data));
       server = kzalloc(sizeof(struct ncp_server), GFP_KERNEL);
       if (!server)
		return -ENOMEM;
@@ -496,7 +496,6 @@ static int ncp_fill_super(struct super_b
                               struct ncp_mount_data_v4* md = (struct ncp_mount_data_v4*)raw_data;

                               data.flags = md->flags;
-                               data.int_flags = 0;
                               data.mounted_uid = md->mounted_uid;
                               data.wdog_pid = find_get_pid(md->wdog_pid);
                               data.ncp_fd = md->ncp_fd;
@@ -507,7 +506,6 @@ static int ncp_fill_super(struct super_b
                               data.file_mode = md->file_mode;
                               data.dir_mode = md->dir_mode;
                               data.info_fd = -1;
-                               data.mounted_vol[0] = 0;
                       }
                       break;
               default:
_

