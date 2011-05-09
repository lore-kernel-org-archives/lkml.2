Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753859Ab1EIOab (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 10:30:31 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:46614 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753404Ab1EIOaa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 10:30:30 -0400
Date: Mon, 9 May 2011 10:30:27 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Lukas Czerner <lczerner@redhat.com>
Cc: Jens Axboe <jaxboe@fusionio.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dmitry Monakhov <dmonakhov@openvz.org>, Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH 1/3] blkdev: Submit discard bio in batches in
 blkdev_issue_discard()
Message-ID: <20110509143027.GA29635@infradead.org>
References: <1304345841-20063-1-git-send-email-lczerner@redhat.com>
 <4DBEDA78.7020502@fusionio.com>
 <alpine.LFD.2.00.1105051717050.3760@dhcp-27-109.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1105051717050.3760@dhcp-27-109.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 05, 2011 at 05:20:40PM +0200, Lukas Czerner wrote:
> > Good results. It'd be more efficient to add the vectored discard support
> > and use it for this too though, and it would get rid of the need to wait
> > on the batches since there'd be just one discard bio for the ranges.
> > 
> 
> Since we do not have vectored discard yet, can this change go in as it
> is ? Also, Christoph thinks that it would not help anyway since the we do
> batch the discard requests only when it exceeds the max range.

I think this patch is orthogonal to vectored discard.  The batching
is important for large ranges which generally come from BLKDISCARD or
FITRIM, while vectored discard is mostly interesting for lots of small
discards at transaction commit time. 

