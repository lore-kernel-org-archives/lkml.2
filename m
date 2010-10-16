Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751990Ab0JPRJU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 13:09:20 -0400
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:11890 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751063Ab0JPRJT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 13:09:19 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AmQEALN2uUx5LcB2gWdsb2JhbAChMBYBARYiIsAwhUkEj0w
Date: Sun, 17 Oct 2010 04:09:11 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Christoph Hellwig <hch@infradead.org>
Cc: Nick Piggin <npiggin@kernel.dk>, Dave Chinner <david@fromorbit.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/17] fs: icache lock s_inodes list
Message-ID: <20101016170911.GA3240@amd>
References: <1285762729-17928-1-git-send-email-david@fromorbit.com>
 <1285762729-17928-3-git-send-email-david@fromorbit.com>
 <20101001054909.GB32349@infradead.org>
 <20101016075411.GA19147@amd>
 <20101016161210.GA16861@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101016161210.GA16861@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 16, 2010 at 12:12:10PM -0400, Christoph Hellwig wrote:
> On Sat, Oct 16, 2010 at 06:54:11PM +1100, Nick Piggin wrote:
> > Because in the first part of the inode lock series, it is breaking
> > locks in obvious small steps as possible, by adding global locks
> > protecting bits of what inode_lock used to.
> 
> As seen by Dave's respin making it per-sb was just as easy as making
> it global. And it really is the logical synchronization domain.

If you want it to be scalable within a single sb, it needs to be
per cpu. If it is per-cpu it does not need to be per-sb as well
which just adds bloat.

And the entire idea of the first half of the inode series is that
it starts simple and just uses globals to demonstrate the locking
steps. It's obviously not supposed to be a "production" locking
model so I prefer it to be like that.

