Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752343Ab0IUSyT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 14:54:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64083 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751450Ab0IUSyS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 14:54:18 -0400
Date: Tue, 21 Sep 2010 14:53:47 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Andreas Gruenbacher <agruen@suse.de>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Christoph Hellwig <hch@infradead.org>, Nick Piggin <npiggin@kernel.dk>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 01/34] VFS: Make clone_mnt() and copy_tree() return error codes
Message-ID: <20100921185347.GA13785@shell>
References: <1284675145-4391-1-git-send-email-vaurora@redhat.com> <1284675145-4391-2-git-send-email-vaurora@redhat.com> <201009202326.43538.agruen@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201009202326.43538.agruen@suse.de>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 20, 2010 at 11:26:42PM +0200, Andreas Gruenbacher wrote:
> collect_mounts() now also returns error pointers instead of NULL upon
> failure:
> 
> diff --git a/kernel/audit_tree.c b/kernel/audit_tree.c
> index 46a57b5..898da28 100644
> --- a/kernel/audit_tree.c
> +++ b/kernel/audit_tree.c
> @@ -579,7 +579,7 @@ void audit_trim_trees(void)
>  
>  		root_mnt = collect_mounts(&path);
>  		path_put(&path);
> -		if (!root_mnt)
> +		if (IS_ERR(root_mnt))
>  			goto skip_it;
>  
>  		spin_lock(&hash_lock);
> @@ -651,8 +651,8 @@ int audit_add_tree_rule(struct audit_krule *rule)
>  		goto Err;
>  	mnt = collect_mounts(&path);
>  	path_put(&path);
> -	if (!mnt) {
> -		err = -ENOMEM;
> +	if (IS_ERR(mnt)) {
> +		err = PTR_ERR(mnt);
>  		goto Err;
>  	}
>  
> @@ -701,8 +701,8 @@ int audit_tag_tree(char *old, char *new)
>  		return err;
>  	tagged = collect_mounts(&path2);
>  	path_put(&path2);
> -	if (!tagged)
> -		return -ENOMEM;
> +	if (IS_ERR(tagged))
> +		return PTR_ERR(tagged);
>  
>  	err = kern_path(old, 0, &path1);
>  	if (err) {

Thanks for the fix, folded in.

-VAL
