Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753822Ab0JHHBz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 03:01:55 -0400
Received: from canuck.infradead.org ([134.117.69.58]:44700 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753008Ab0JHHBy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 03:01:54 -0400
Date: Fri, 8 Oct 2010 03:01:54 -0400
From: Christoph Hellwig <hch@lst.de>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/18] fs: keep inode with backing-dev
Message-ID: <20101008070154.GB23595@lst.de>
References: <1286515292-15882-1-git-send-email-david@fromorbit.com>
 <1286515292-15882-4-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1286515292-15882-4-git-send-email-david@fromorbit.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 08, 2010 at 04:21:17PM +1100, Dave Chinner wrote:
> From: Nick Piggin <npiggin@suse.de>
> 
> Having inode on writeback lists of a different bdi than
> inode->i_mapping->backing_dev_info makes it very difficult to do
> per-bdi locking of the writeback lists. Add functions to move these
> inodes over when the mapping backing dev is changed.
> 
> Also, rename i_mapping.backing_dev_info to i_mapping.a_bdi while we're
> here. Succinct is nice, and it catches conversion errors.

NAK.  This is fixed by my patch to always use s_bdi for writeback
purposed that hit Linus' tree two days ago.

