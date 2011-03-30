Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932533Ab1C3OQ2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 10:16:28 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:55343 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754807Ab1C3OQ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 10:16:27 -0400
Date: Wed, 30 Mar 2011 10:16:26 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: Christoph Hellwig <hch@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: merging discard request in the block layer
Message-ID: <20110330141626.GA17914@infradead.org>
References: <20110322194755.GA20122@infradead.org>
 <4D88FE5E.1010204@fusionio.com>
 <4D890EBD.1090103@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D890EBD.1090103@fusionio.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 22, 2011 at 10:03:57PM +0100, Jens Axboe wrote:
> On 2011-03-22 20:54, Jens Axboe wrote:
> > On 2011-03-22 20:47, Christoph Hellwig wrote:
> >> It seems the current block layer wil happily try to merge discard
> >> requests that were split because they are at the max that bi_size
> >> can hold together again.  At least that's what the
> >>
> >> 	blk: request botched
> > 
> > That would seem to indicate a bug in the merging logic instead.
> 
> What kind of max discard size does you device have? If the max discard
> size is smaller than the regular request size, this could help.

I've done some heavier test, and both the extended check for mergeable
requests or your patch with different limits hangs the test box hard
with no way to get a backtrace.  Using my original patch to completely
skip the merging logic seems to work fine.  

