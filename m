Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752228Ab0KFSKv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Nov 2010 14:10:51 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:49495 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751873Ab0KFSKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Nov 2010 14:10:50 -0400
Date: Sat, 6 Nov 2010 14:10:48 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Alessio Igor Bogani <abogani@texware.it>
Cc: Jan Kara <jack@suse.cz>, Arnd Bergmann <arnd@arndb.de>,
        Christoph Hellwig <hch@infradead.org>, Tim Bird <tim.bird@am.sony.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/4] udf: Replace bkl with a mutex for protect
 udf_inode_info struct
Message-ID: <20101106181048.GD13315@infradead.org>
References: <1289065631-2256-1-git-send-email-abogani@texware.it>
 <1289065631-2256-3-git-send-email-abogani@texware.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289065631-2256-3-git-send-email-abogani@texware.it>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  	struct inode vfs_inode;
> +
> +	/* Serialize writer access, replace the old bkl */
> +	struct mutex lock;

mentioning that it replaces bkl is not very useful for someone looking
at the code.  Neither is "Seriazlize writer access".  What would be
more useful is to document what exact fields are supposed to
be protected by this field.  Take a look at hfsplus_inode_info, where
I documented the locking as part of the BKL removal during the 2.6.37
cycle.  


