Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754257Ab2IQKhx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 06:37:53 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:39624 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753189Ab2IQKhw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 06:37:52 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Jan Kara <jack@suse.cz>
Cc: Fengguang Wu <fengguang.wu@intel.com>, viro@zeniv.linux.org.uk, hch@lst.de,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix queueing work if !bdi_cap_writeback_dirty()
References: <20120914111429.GA19509@localhost>
	<87r4q4n6r1.fsf@devron.myhome.or.jp>
	<20120914131952.GA4952@quack.suse.cz>
	<87ipbgn2gz.fsf@devron.myhome.or.jp>
	<20120914144543.GB4952@quack.suse.cz>
	<878vccmygy.fsf@devron.myhome.or.jp>
	<20120916214912.GA7503@quack.suse.cz>
	<87wqzt7drb.fsf@devron.myhome.or.jp>
	<20120917084853.GA9150@quack.suse.cz>
	<87627d6lae.fsf@devron.myhome.or.jp>
	<20120917095623.GB9150@quack.suse.cz>
Date: Mon, 17 Sep 2012 19:37:46 +0900
In-Reply-To: <20120917095623.GB9150@quack.suse.cz> (Jan Kara's message of
	"Mon, 17 Sep 2012 11:56:23 +0200")
Message-ID: <87obl55405.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.2.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Kara <jack@suse.cz> writes:

> On Mon 17-09-12 18:39:05, OGAWA Hirofumi wrote:
>> Jan Kara <jack@suse.cz> writes:
>> 
>> >> I think you know how to solve it though. You can add the periodic flush
>> >> in own task. And you can check bdi->dirty_exceeded in any handlers.
>> >   Sure, you can have your private thread. That is possible but you will
>> > have to duplicate flusher logic and you will still get odd behavior e.g.
>> > when your filesystem is on one partition and another filesystem is on a
>> > different partition of the same disk.
>> 
>> Right. But it is what current FSes are doing more or less.
>   It's not. Page writeback is respected by all filesystems in most cases
> AFAIK. Inode writeback is a different issue but that's not so interesting
> from mm point of view...

Duplicate flusher - many FSes has own task to flush.  Odd behavior in
the case of partition - agree, but I'm not sure why metadata is ok, and
it is not odd behavior.

Sorry, I'm not sure your point in latest comment. You are just saying FS
must flush pages on writepages()?

And if alternative plan is acceptable, maybe I will not have interest to
this anymore.

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
