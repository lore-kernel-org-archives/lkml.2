Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753867Ab2JMQWY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2012 12:22:24 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:58320
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753746Ab2JMQWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2012 12:22:23 -0400
Date: Sat, 13 Oct 2012 12:22:21 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Marco Stornelli <marco.stornelli@gmail.com>
Cc: Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Al Viro <viro@ZenIV.linux.org.uk>, Jeff Dike <jdike@addtoit.com>,
        Richard Weinberger <richard@nod.at>,
        user-mode-linux-devel@lists.sourceforge.net,
        user-mode-linux-user@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 14/22] hostfs: drop vmtruncate
Message-ID: <20121013162221.GF19899@infradead.org>
References: <506FEC51.3020205@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <506FEC51.3020205@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +++ b/fs/hostfs/hostfs_kern.c
> @@ -848,9 +848,11 @@ int hostfs_setattr(struct dentry *dentry, struct iattr *attr)
>  	    attr->ia_size != i_size_read(inode)) {
>  		int error;
>  
> -		error = vmtruncate(inode, attr->ia_size);
> -		if (err)
> -			return err;
> +		error = inode_newsize_ok(inode, attr->ia_size);
> +		if (error)
> +			return error;
> +
> +		truncate_setsize(inode, attr->ia_size);

The inode_change_ok call here is superflous, it's already done by
inode_change_ok at the beginning of the function.  Even if that wasn't
done doing it aftet set_attr() would be too late anyway.

