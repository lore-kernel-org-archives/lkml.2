Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755486Ab1C2DGo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 23:06:44 -0400
Received: from relay3.sgi.com ([192.48.152.1]:42059 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751505Ab1C2DGm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 23:06:42 -0400
Subject: Re: [xfs-masters] linux-next: manual merge of the xfs tree with 
 Linus' tree
From: Alex Elder <aelder@sgi.com>
Reply-To: aelder@sgi.com
To: Jens Axboe <jaxboe@fusionio.com>
Cc: Christoph Hellwig <hch@lst.de>, Stephen Rothwell <sfr@canb.auug.org.au>,
        David Chinner <david@fromorbit.com>,
        "xfs-masters@oss.sgi.com" <xfs-masters@oss.sgi.com>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <4D9069C1.4080602@fusionio.com>
References: <20110328122148.1b48a742.sfr@canb.auug.org.au>
	 <20110328104753.GA27327@lst.de> <20110328105348.GA27458@lst.de>
	 <4D9069C1.4080602@fusionio.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 28 Mar 2011 21:57:18 -0500
Message-ID: <1301367438.2005.1.camel@doink>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 29 Mar 2011 02:57:19.0006 (UTC) FILETIME=[047C7BE0:01CBEDBD]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-03-28 at 12:58 +0200, Jens Axboe wrote:
> On 2011-03-28 12:53, Christoph Hellwig wrote:
> > On Mon, Mar 28, 2011 at 12:47:53PM +0200, Christoph Hellwig wrote:
> >> What XFS does is to replace blk_run_address_space, which was a wrapper
> >> around blk_run_backing_dev with a direct call to blk_run_backing_dev,
> >> as there change means we don't have the address_space around anymore.
> >>
> >> Jens' tree removes both these functions, and introduces blk_flush_plug
> >> as a sort-of replacement.  Sticking to the variant from Jens' tree / mainline
> >> with blk_flush_plug is the correct thing here for this case.
> >>
> >> Where there more conflicts than just this?
> > 
> > Actually I think we can remove some calls alltogether:  the on-stack
> > plugging already flushes the plug queue when context switching,
> > which we'll always do in xfs_buf_wait_unpin, and if we get the lock
> > without blocking in xfs_buf_lock we don't need to unplug either.
> 
> Yes, in fact all of the blk_flush_plug() calls in XFS can just go away
> now. I tried to keep them for clarity, but they are primarily there
> since XFS was the first conversion/testing I did back when it was hacked
> up.
> 

I sent a fix to Linus but he must not have pulled it in
time for the March 29 build.  He has pulled it now though.
Ought to be fixed tomorrow.

(To be clear, I just did the simple conflict resolution,
I didn't remove the calls--that'll wait.)

					-Alex

