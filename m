Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753023Ab0FKEuR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 00:50:17 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42988 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752896Ab0FKEuN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 00:50:13 -0400
Date: Fri, 11 Jun 2010 14:50:07 +1000
From: Nick Piggin <npiggin@suse.de>
To: Tao Ma <tao.ma@oracle.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Joel Becker <joel.becker@oracle.com>, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v4] ocfs2: Let ocfs2_setattr use new truncate sequence.
Message-ID: <20100611045007.GC16436@laptop>
References: <1276226869-11123-1-git-send-email-tao.ma@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1276226869-11123-1-git-send-email-tao.ma@oracle.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 11, 2010 at 11:27:49AM +0800, Tao Ma wrote:
> Let ocfs2 use the new truncate sequence. The changes include:
> 1. Move inode_change_ok into cluster lock and remove inode_newsize_ok.
> 2. Use truncate_setsize directly since we don't implement our
>    own ->truncate and what we need is "update i_size and
>    truncate_pagecache" which truncate_setsize now does.
> 3. Change some i_size_read to inode->i_size in ocfs2_setattr
>    since we have i_muext held.
> 4. For direct write, ocfs2 actually don't allow write to pass
>    i_size(see ocfs2_prepare_inode_for_write), so we don't have
>    a chance to increase i_size. So remove the bogus check.
> 
> Cc: Joel Becker <joel.becker@oracle.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Nick Piggin <npiggin@suse.de>

The patch looks fine to me. I really appreciate you working on truncate,
thanks.

