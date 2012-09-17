Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932308Ab2IQPyM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 11:54:12 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39377 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932093Ab2IQPyK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 11:54:10 -0400
Date: Mon, 17 Sep 2012 17:54:06 +0200
From: Jan Kara <jack@suse.cz>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Jan Kara <jack@suse.cz>, Fengguang Wu <fengguang.wu@intel.com>,
        viro@zeniv.linux.org.uk, hch@lst.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix queueing work if !bdi_cap_writeback_dirty()
Message-ID: <20120917155406.GC9150@quack.suse.cz>
References: <20120914131952.GA4952@quack.suse.cz>
 <87ipbgn2gz.fsf@devron.myhome.or.jp>
 <20120914144543.GB4952@quack.suse.cz>
 <878vccmygy.fsf@devron.myhome.or.jp>
 <20120916214912.GA7503@quack.suse.cz>
 <87wqzt7drb.fsf@devron.myhome.or.jp>
 <20120917084853.GA9150@quack.suse.cz>
 <87627d6lae.fsf@devron.myhome.or.jp>
 <20120917095623.GB9150@quack.suse.cz>
 <87obl55405.fsf@devron.myhome.or.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87obl55405.fsf@devron.myhome.or.jp>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 17-09-12 19:37:46, OGAWA Hirofumi wrote:
> Jan Kara <jack@suse.cz> writes:
> 
> > On Mon 17-09-12 18:39:05, OGAWA Hirofumi wrote:
> >> Jan Kara <jack@suse.cz> writes:
> >> 
> >> >> I think you know how to solve it though. You can add the periodic flush
> >> >> in own task. And you can check bdi->dirty_exceeded in any handlers.
> >> >   Sure, you can have your private thread. That is possible but you will
> >> > have to duplicate flusher logic and you will still get odd behavior e.g.
> >> > when your filesystem is on one partition and another filesystem is on a
> >> > different partition of the same disk.
> >> 
> >> Right. But it is what current FSes are doing more or less.
> >   It's not. Page writeback is respected by all filesystems in most cases
> > AFAIK. Inode writeback is a different issue but that's not so interesting
> > from mm point of view...
> 
> Duplicate flusher - many FSes has own task to flush.  Odd behavior in
> the case of partition - agree, but I'm not sure why metadata is ok, and
> it is not odd behavior.
  Well, because there is much more of data pages then there is metadata. So
when you do strange things (like refuse to write / reclaim) with metadata,
it usually ends up in the noise. But when you start doing similar things
with data pages, people will notice.

> Sorry, I'm not sure your point in latest comment. You are just saying FS
> must flush pages on writepages()?
  Yes.

> And if alternative plan is acceptable, maybe I will not have interest to
> this anymore.
  Yes, the alternative plan looks better to me. But all in all I don't want
to stop you from your experiments :) I mostly just wanted to point out that
disabling flusher thread for a filesystem has a complex consequences which
IMHO bring more bad than good.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
