Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754245Ab0JHH3t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 03:29:49 -0400
Received: from canuck.infradead.org ([134.117.69.58]:51697 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753157Ab0JHH3s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 03:29:48 -0400
Date: Fri, 8 Oct 2010 03:29:47 -0400
From: Christoph Hellwig <hch@lst.de>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/18] fs: Factor inode hash operations into functions
Message-ID: <20101008072947.GC7831@lst.de>
References: <1286515292-15882-1-git-send-email-david@fromorbit.com>
 <1286515292-15882-11-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1286515292-15882-11-git-send-email-david@fromorbit.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 08, 2010 at 04:21:24PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Before replacing the inode hash locking with a more scalable
> mechanism, factor the removal of the inode from the hashes rather
> than open coding it in several places.
> 
> Based on a patch originally from Nick Piggin.

Looks good as an equal transformation, but what code is doing with
remove_inode_hash looks really buggy.  It's doing a re-hash of a live
inode which is probably causing enough problems by itself, but should
at least have locks for it.  Anyway, that's something for the coda folks
to sort out.

Reviewed-by: Christoph Hellwig <hch@lst.de>
