Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753854Ab2JMQUE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2012 12:20:04 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:58306
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753764Ab2JMQUB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2012 12:20:01 -0400
Date: Sat, 13 Oct 2012 12:19:51 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Marco Stornelli <marco.stornelli@gmail.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Mark Fasheh <mfasheh@suse.com>,
        Joel Becker <jlbec@evilplan.org>, ocfs2-devel@oss.oracle.com,
        linux-kernel@vger.kernel.org,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 06/22] ocfs2: drop vmtruncate
Message-ID: <20121013161951.GC19899@infradead.org>
References: <506FE92F.2000609@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <506FE92F.2000609@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  	if ((attr->ia_valid & ATTR_SIZE) &&
>  	    attr->ia_size != i_size_read(inode)) {
> -		status = vmtruncate(inode, attr->ia_size);
> +		status = inode_newsize_ok(inode, attr->ia_size);
>  		if (status) {
>  			mlog_errno(status);
>  			goto bail_commit;
>  		}
> +		truncate_setsize(inode, attr->ia_size);

ocfs2 already calls inode_newsize_ok earlier during ocfs2_setattr,
and there's an XXX comment just above the vmtruncate call about
how ocfs2 hacks around this.  I suspect you just want a plain
truncate_setsize here and remove the comment above it, but I'd
like to have the ocfs2 folks confirm that.

