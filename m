Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753839Ab2JMQRR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2012 12:17:17 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:58288
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753746Ab2JMQRQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2012 12:17:16 -0400
Date: Sat, 13 Oct 2012 12:17:06 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Marco Stornelli <marco.stornelli@gmail.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Evgeniy Dushistov <dushistov@mail.ru>,
        linux-kernel@vger.kernel.org,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 01/22] ufs: drop vmtruncate
Message-ID: <20121013161706.GA19899@infradead.org>
References: <506FE786.1030507@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <506FE786.1030507@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> @@ -536,8 +536,9 @@ static int ufs_write_begin(struct file *file, struct address_space *mapping,
>  				ufs_getfrag_block);
>  	if (unlikely(ret)) {
>  		loff_t isize = mapping->host->i_size;
> -		if (pos + len > isize)
> -			vmtruncate(mapping->host, isize);
> +		if ((pos + len > isize) &&
> +			inode_newsize_ok(mapping->host, isize) == 0)
> +			truncate_setsize(mapping->host, isize);

write_begin always truncates down, so there should be no call to
inode_newsize_ok here.
