Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753404Ab2FLOX4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 10:23:56 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:36039
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751836Ab2FLOXy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 10:23:54 -0400
Date: Tue, 12 Jun 2012 10:23:47 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Alex Elder <elder@kernel.org>,
        linux-fsdevel@suse.cz, LKML <linux-kernel@vger.kernel.org>,
        xfs@oss.sgi.com, Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 18/27] xfs: Convert to new freezing code
Message-ID: <20120612142346.GA25132@infradead.org>
References: <1339510848-16992-1-git-send-email-jack@suse.cz>
 <1339510848-16992-19-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339510848-16992-19-git-send-email-jack@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +	 * We will pass freeze protection with a transaction.  So tell lockdep
> +	 * we released it.
> +	 */
> +	rwsem_release(&ioend->io_inode->i_sb->s_writers.lock_map[SB_FREEZE_FS-1],
> +		      1, _THIS_IP_);

I'll need some time to get through the whole series, but repeated use
of constructs like this really screams for a helper abstracting it out
and documenting it.

