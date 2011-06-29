Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757750Ab1F2UMl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 16:12:41 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:52115
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757700Ab1F2UMk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 16:12:40 -0400
Date: Wed, 29 Jun 2011 16:12:34 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>, Curt Wohlgemuth <curtw@google.com>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, fengguang.wu@intel.com
Subject: Re: [PATCH] writeback: Don't wait for completion in
 writeback_inodes_sb_nr
Message-ID: <20110629201234.GA31129@infradead.org>
References: <1309304616-8657-1-git-send-email-curtw@google.com>
 <20110629005422.GQ32466@dastard>
 <BANLkTimKtwVZo3D+w9AB2-C83d08YROcMw@mail.gmail.com>
 <20110629081155.GA5558@infradead.org>
 <20110629165714.GF17590@quack.suse.cz>
 <20110629175534.GA32236@infradead.org>
 <20110629191518.GA23196@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110629191518.GA23196@quack.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 29, 2011 at 09:15:18PM +0200, Jan Kara wrote:
>   True but writeback_single_inode() has in it:
>         if (wbc->sync_mode == WB_SYNC_ALL) {
>                 int err = filemap_fdatawait(mapping);
>                 if (ret == 0)
>                         ret = err;
>         }
>   So we end up waiting much earlier. Probably we should remove this wait
> but that will need some audit I guess.

Uhh, indeed.  We'll need this wait for things like sync_inode, though.

