Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753876Ab2JMQXa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2012 12:23:30 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:58332
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753746Ab2JMQX2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2012 12:23:28 -0400
Date: Sat, 13 Oct 2012 12:23:24 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Marco Stornelli <marco.stornelli@gmail.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Petr Vandrovec <petr@vandrovec.name>,
        Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 17/22] ncpfs: drop vmtruncate
Message-ID: <20121013162324.GG19899@infradead.org>
References: <506FECC4.1080907@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <506FECC4.1080907@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  		if (attr->ia_size != i_size_read(inode)) {
> -			result = vmtruncate(inode, attr->ia_size);
> +			result = inode_newsize_ok(inode, attr->ia_size);
>  			if (result)
>  				goto out;
> +
> +			truncate_setsize(inode, attr->ia_size);
>  			mark_inode_dirty(inode);

inode_newsize_ok already is done as part of inode_change_ok earlier on.
