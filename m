Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754033Ab2INPLA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 11:11:00 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:38848 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751597Ab2INPK6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 11:10:58 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Jan Kara <jack@suse.cz>
Cc: Fengguang Wu <fengguang.wu@intel.com>, viro@zeniv.linux.org.uk, hch@lst.de,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix queueing work if !bdi_cap_writeback_dirty()
References: <87wr002z39.fsf@devron.myhome.or.jp>
	<20120913063906.GA24974@localhost>
	<871ui6e4tl.fsf@devron.myhome.or.jp>
	<20120914111429.GA19509@localhost>
	<87r4q4n6r1.fsf@devron.myhome.or.jp>
	<20120914131952.GA4952@quack.suse.cz>
	<87ipbgn2gz.fsf@devron.myhome.or.jp>
	<20120914144543.GB4952@quack.suse.cz>
Date: Sat, 15 Sep 2012 00:10:53 +0900
In-Reply-To: <20120914144543.GB4952@quack.suse.cz> (Jan Kara's message of
	"Fri, 14 Sep 2012 16:45:43 +0200")
Message-ID: <878vccmygy.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.2.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Kara <jack@suse.cz> writes:

>> If flusher is working, it clears dirty flags of inode. But if those
>> handers can't flush at the time, we have to do redirty or something to
>> prevent the reclaim.
>   Well, if this is your only problem then I'd see better options than just
> disabling flusher thread. If the inability to write inode is rare, then
> redirtying seems like a reasonable option (despite I agree it's a bit
> ugly). If the inability to write is common, then you'll probably have to do
> the dirty inode tracking yourself in some list and expose inodes to VM when
> they are ready to be written. Or you handle writing of inodes yourself but
> leave writing of pages on flusher thread...

Basically all data can be data-integrity write like data logging, so it
would be more than common. And ->writepages() will also ignore WBC_SYNC_NONE.

> Because when you disable flusher thread completely you have to put all the
> smarts to avoid livelocks, keep fairness among processes, write old data,
> keep number of dirty pages under control into your filesystem which leads
> to a lot of duplication.

I'm not sure what you meant though. What is the difference with ignoring
WBC_SYNC_NONE?

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
