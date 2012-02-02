Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754131Ab2BBUhP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 15:37:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37543 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751176Ab2BBUhN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 15:37:13 -0500
Date: Thu, 2 Feb 2012 15:37:08 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, ctalbott@google.com, rni@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/11] block: relocate elevator initialized test from
 blk_cleanup_queue() to blk_drain_queue()
Message-ID: <20120202203708.GA30258@redhat.com>
References: <1328131156-13290-1-git-send-email-tj@kernel.org>
 <1328131156-13290-3-git-send-email-tj@kernel.org>
 <20120202202042.GC1723@redhat.com>
 <20120202203513.GH19837@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120202203513.GH19837@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 02, 2012 at 12:35:13PM -0800, Tejun Heo wrote:
> Hello,
> 
> On Thu, Feb 02, 2012 at 03:20:42PM -0500, Vivek Goyal wrote:
> > > @@ -359,6 +359,13 @@ EXPORT_SYMBOL(blk_put_queue);
> > >   */
> > >  void blk_drain_queue(struct request_queue *q, bool drain_all)
> > >  {
> > > +	/*
> > > +	 * The caller might be trying to tear down @q before its elevator
> > > +	 * is initialized, in which case we don't want to call into it.
> > > +	 */
> > > +	if (!q->elevator)
> > > +		return;
> > > +
> > 
> > Shouldn't blk_throtl_drain() be called irrespective of the fact whether
> > elevator is initilialized or not? On bio based drivers, there will be
> > no elevator but bios can still be throttled.
> 
> Hmmm... probably, but doesn't that mean the code is already broken for
> bio based drivers using throtl?

Yes looks like it is already broken for bio based drivers. So it is a fix
independent of this patch/patch series.

Thanks
Vivek
