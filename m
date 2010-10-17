Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932608Ab0JQSyU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Oct 2010 14:54:20 -0400
Received: from mail.perches.com ([173.55.12.10]:2994 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932508Ab0JQSyT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Oct 2010 14:54:19 -0400
Subject: Re: [PATCH 2/3] fs/ceph/xattr.c: Use kasprintf
From: Joe Perches <joe@perches.com>
To: Julia Lawall <julia@diku.dk>
Cc: Sage Weil <sage@newdream.net>, kernel-janitors@vger.kernel.org,
        ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1287341311-11161-3-git-send-email-julia@diku.dk>
References: <1287341311-11161-1-git-send-email-julia@diku.dk>
	 <1287341311-11161-3-git-send-email-julia@diku.dk>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 17 Oct 2010 11:54:17 -0700
Message-ID: <1287341657.20968.61.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-10-17 at 20:48 +0200, Julia Lawall wrote:
> Convert a sequence of kmalloc and memcpy to use kasprintf.  The argument is
> checked for being a string by the presence of a previous call to strlen.
[]
> diff --git a/fs/ceph/xattr.c b/fs/ceph/xattr.c
[]
> @@ -716,10 +716,9 @@ int ceph_setxattr(struct dentry *dentry, const char *name,
>  
>  	/* preallocate memory for xattr name, value, index node */
>  	err = -ENOMEM;
> -	newname = kmalloc(name_len + 1, GFP_NOFS);
> +	newname = kasprintf(GFP_NOFS, "%s", name);

This one is probably better converted to kmemdup
as name_len is already known and is used later
in the routine.

kstrdup is also a possibility.


