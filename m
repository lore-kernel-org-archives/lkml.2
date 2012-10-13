Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753881Ab2JMQUV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2012 12:20:21 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:58312
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753764Ab2JMQUS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2012 12:20:18 -0400
Date: Sat, 13 Oct 2012 12:20:15 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Marco Stornelli <marco.stornelli@gmail.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 07/22] adfs: drop vmtruncate
Message-ID: <20121013162015.GD19899@infradead.org>
References: <506FE958.4070005@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <506FE958.4070005@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> @@ -57,8 +57,9 @@ static int adfs_write_begin(struct file *file, struct address_space *mapping,
>  				&ADFS_I(mapping->host)->mmu_private);
>  	if (unlikely(ret)) {
>  		loff_t isize = mapping->host->i_size;
> -		if (pos + len > isize)
> -			vmtruncate(mapping->host, isize);
> +		if ((pos + len > isize) &&
> +			inode_newsize_ok(mapping->host, isize) == 0)
> +			truncate_setsize(mapping->host, isize);

No need for the inode_newsize_ok check here.

