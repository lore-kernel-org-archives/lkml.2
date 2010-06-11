Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756522Ab0FKQby (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 12:31:54 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:50992 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753802Ab0FKQbx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 12:31:53 -0400
Date: Fri, 11 Jun 2010 12:31:51 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, LKML <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 2/2] AFFS: wait for sb synchronization when needed
Message-ID: <20100611163151.GE24707@infradead.org>
References: <1276268720-7398-1-git-send-email-dedekind1@gmail.com>
 <1276268720-7398-3-git-send-email-dedekind1@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1276268720-7398-3-git-send-email-dedekind1@gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 11, 2010 at 06:05:20PM +0300, Artem Bityutskiy wrote:
> From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
> 
> AFFS does not ever wait for superblock synchronization in
> ->put_super(), ->write_super, and ->sync_fs().
> 
> However, it should wait for synchronization in ->put_super() because
> it is about to be unmounted, in ->write_super() because this is
> periodic SB synchronization performed from a separate kernel thread,
> and in ->sync_fs() it should respect the 'wait' flag. This patch fixes
> the situation.
> 
> Also, in ->put_super(), do not write the SB if it is not dirty.

->sync_fs should also wait for the superblock I/O to be completed.

