Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755091Ab0JHJlT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 05:41:19 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:50682 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751916Ab0JHJlS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 05:41:18 -0400
Date: Fri, 8 Oct 2010 10:41:17 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Christoph Hellwig <hch@lst.de>
Cc: Dave Chinner <david@fromorbit.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/18] fs: Factor inode hash operations into functions
Message-ID: <20101008094117.GY19804@ZenIV.linux.org.uk>
References: <1286515292-15882-1-git-send-email-david@fromorbit.com>
 <1286515292-15882-11-git-send-email-david@fromorbit.com>
 <20101008072947.GC7831@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101008072947.GC7831@lst.de>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 08, 2010 at 03:29:47AM -0400, Christoph Hellwig wrote:
> On Fri, Oct 08, 2010 at 04:21:24PM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Before replacing the inode hash locking with a more scalable
> > mechanism, factor the removal of the inode from the hashes rather
> > than open coding it in several places.
> > 
> > Based on a patch originally from Nick Piggin.
> 
> Looks good as an equal transformation, but what code is doing with
> remove_inode_hash looks really buggy.  It's doing a re-hash of a live
> inode which is probably causing enough problems by itself, but should
> at least have locks for it.  Anyway, that's something for the coda folks
> to sort out.

Known problem; nobody got around to fixing it.  But if that's going where
I think it's going, the problem has just got nastier...  We do need locking
around there anyway; current use of BKL to protect lists in psdev stuff
is not good.
