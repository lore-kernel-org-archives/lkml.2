Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753526Ab1C1LAm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 07:00:42 -0400
Received: from verein.lst.de ([213.95.11.211]:34968 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753184Ab1C1LAl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 07:00:41 -0400
Date: Mon, 28 Mar 2011 13:00:40 +0200
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: Christoph Hellwig <hch@lst.de>, Stephen Rothwell <sfr@canb.auug.org.au>,
        David Chinner <david@fromorbit.com>,
        "xfs-masters@oss.sgi.com" <xfs-masters@oss.sgi.com>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [xfs-masters] linux-next: manual merge of the xfs tree with
	Linus' tree
Message-ID: <20110328110040.GA27586@lst.de>
References: <20110328122148.1b48a742.sfr@canb.auug.org.au> <20110328104753.GA27327@lst.de> <20110328105348.GA27458@lst.de> <4D9069C1.4080602@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D9069C1.4080602@fusionio.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 28, 2011 at 12:58:09PM +0200, Jens Axboe wrote:
> Yes, in fact all of the blk_flush_plug() calls in XFS can just go away
> now. I tried to keep them for clarity, but they are primarily there
> since XFS was the first conversion/testing I did back when it was hacked
> up.

It seems like the xfsbufd can go away, too indeed.  If we have more
work to do it makes sense not to plug, and if we don't have more
work we are going to sleep.

I think the one in xfs_flush_buftarg actually does make sense to
keep - we really want to flush out all pending I/O before waiting for
it.  But I guess for both of these we just want to add an explicit
plug/unlug pair to optimize the I/O dispatch.

