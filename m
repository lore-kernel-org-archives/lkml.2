Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758766Ab0JFIv6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 04:51:58 -0400
Received: from canuck.infradead.org ([134.117.69.58]:53037 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758571Ab0JFIv4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 04:51:56 -0400
Date: Wed, 6 Oct 2010 04:51:31 -0400
From: Christoph Hellwig <hch@lst.de>
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, dada1@cosmosbay.com,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 15/17] fs: inode per-cpu last_ino allocator
Message-ID: <20101006085131.GA7295@lst.de>
References: <1285762729-17928-1-git-send-email-david@fromorbit.com>
 <1285762729-17928-16-git-send-email-david@fromorbit.com>
 <20100930020759.GC1535@infradead.org>
 <20101006062921.GA32255@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101006062921.GA32255@dastard>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 06, 2010 at 05:29:21PM +1100, Dave Chinner wrote:
> Sounds like a good plan, but I don't really have time right now to
> understand the iget routines of every single filesystem to determine
> which rely on the current new_inode() allocated inode number. I
> think that is best left for a later cleanup, seeing as the
> last_ino scalability problem is easily addressed...

It's fairly easy to do it pessimisticly - all disk based filesystem
don't need it.  Anyway, I can do this ontop of your series later.  It just
seems a bit counter-intuitive to scale something we don't actually need it
most cases.

