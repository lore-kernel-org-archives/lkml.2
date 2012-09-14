Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754759Ab2INNoe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 09:44:34 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:38807 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753915Ab2INNoc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 09:44:32 -0400
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
Date: Fri, 14 Sep 2012 22:44:28 +0900
In-Reply-To: <20120914131952.GA4952@quack.suse.cz> (Jan Kara's message of
	"Fri, 14 Sep 2012 15:19:52 +0200")
Message-ID: <87ipbgn2gz.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.2.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Kara <jack@suse.cz> writes:

>> page reclaim and fsync path have FS handler. So, FS can control those.
>> 
>> The modern FS have to control to flush carefully. Many FSes are already
>> ignoring if wbc->sync_mode != WB_SYNC_ALL (e.g. ext3_write_inode,
>> nilfs_writepages), and have own FS task to flush.
>   Out of curiosity, what exactly do you need to control in your filesystem
> that makes flusher thread unusable for you? You still have a lot of
> flexibility with ->write_inode() and ->writepages() callbacks...

If flusher is working, it clears dirty flags of inode. But if those
handers can't flush at the time, we have to do redirty or something to
prevent the reclaim.

This job is nothing benefit to just for workaround of flusher, and is
complex and racy.

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
