Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753003Ab0FOGYZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 02:24:25 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:37031 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855Ab0FOGYX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 02:24:23 -0400
Date: Tue, 15 Jun 2010 02:24:22 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, viro@ZenIV.linux.org.uk, josef@redhat.com,
       jeffmerkey@gmail.com
Subject: Re: [PATCH 3/5] fsfreeze: freeze_super and thaw_bdev don't play well
 together
Message-ID: <20100615062422.GA7343@infradead.org>
References: <1276154395-24766-1-git-send-email-david@fromorbit.com>
 <1276154395-24766-4-git-send-email-david@fromorbit.com>
 <20100614152219.GC32354@infradead.org>
 <20100615000107.GJ6590@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100615000107.GJ6590@dastard>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 15, 2010 at 10:01:07AM +1000, Dave Chinner wrote:
> On Mon, Jun 14, 2010 at 11:22:19AM -0400, Christoph Hellwig wrote:
> > This breaks the "feature" that we can freeze a block device that doesn't
> > have a filesystem mounted yet.  For filesystems using get_sb_bdev that
> > prevents a new filesystem to be mounted on them.
> >
> > I'm not sure it's a particularly useful feature, but it's been there
> > since day 1 of the freeze support.  The easiest way to not break it
> > would be to keep the per-sb freeze count only for that case and only
> > check it during mount.
> 
> You mean the per-bdev freeze count, right? So freeze/thaw_bdev would
> have to remain?

Yes.

