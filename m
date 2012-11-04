Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753364Ab2KDKtE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2012 05:49:04 -0500
Received: from oproxy11-pub.bluehost.com ([173.254.64.10]:44359 "HELO
	oproxy11-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751154Ab2KDKtC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2012 05:49:02 -0500
Subject: Re: [PATCH 2/16] fs/hfsplus/bnode.c: use WARN
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
From: Vyacheslav Dubeyko <slava@dubeyko.com>
In-Reply-To: <1351940317-14812-3-git-send-email-Julia.Lawall@lip6.fr>
Date: Sun, 4 Nov 2012 14:49:00 +0300
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <FAC63AFE-A6FD-43BB-B34B-3324F930278B@dubeyko.com>
References: <1351940317-14812-1-git-send-email-Julia.Lawall@lip6.fr> <1351940317-14812-3-git-send-email-Julia.Lawall@lip6.fr>
To: Julia Lawall <julia.lawall@lip6.fr>
X-Mailer: Apple Mail (2.1085)
X-Identified-User: {2172:host202.hostmonster.com:dubeykoc:dubeyko.com} {sentby:smtp auth 46.39.244.28 authed with slava@dubeyko.com}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Nov 3, 2012, at 1:58 PM, Julia Lawall wrote:

> From: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> Use WARN rather than printk followed by WARN_ON(1), for conciseness.
> 
> A simplified version of the semantic patch that makes this transformation
> is as follows: (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @@
> expression list es;
> @@
> 
> -printk(
> +WARN(1,
>  es);
> -WARN_ON(1);
> // </smpl>
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> ---
> fs/hfsplus/bnode.c |    3 +--
> 1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/fs/hfsplus/bnode.c b/fs/hfsplus/bnode.c
> index 5c125ce..7a92c2c 100644
> --- a/fs/hfsplus/bnode.c
> +++ b/fs/hfsplus/bnode.c
> @@ -588,8 +588,7 @@ struct hfs_bnode *hfs_bnode_create(struct hfs_btree *tree, u32 num)
> 	node = hfs_bnode_findhash(tree, num);
> 	spin_unlock(&tree->hash_lock);
> 	if (node) {
> -		printk(KERN_CRIT "new node %u already hashed?\n", num);
> -		WARN_ON(1);
> +		WARN(1, KERN_CRIT "new node %u already hashed?\n", num);
> 		return node;
> 	}
> 	node = __hfs_bnode_create(tree, num);
> 

Looks good.

Reviewed-by: Vyacheslav Dubeyko <slava@dubeyko.com>

Thanks,
Vyacheslav Dubeyko.


> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

