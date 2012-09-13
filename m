Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755878Ab2IMGbo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 02:31:44 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:38297 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755821Ab2IMGbm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 02:31:42 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: viro@zeniv.linux.org.uk, jack@suse.cz, hch@lst.de,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix queueing work if !bdi_cap_writeback_dirty()
References: <87wr002z39.fsf@devron.myhome.or.jp>
	<20120912024249.GB17922@localhost>
	<87sjan3c27.fsf@devron.myhome.or.jp>
	<20120913003337.GA16363@localhost>
	<87a9wueayc.fsf@devron.myhome.or.jp>
	<20120913060351.GA23682@localhost>
Date: Thu, 13 Sep 2012 15:31:37 +0900
In-Reply-To: <20120913060351.GA23682@localhost> (Fengguang Wu's message of
	"Thu, 13 Sep 2012 14:03:51 +0800")
Message-ID: <87627ie8mu.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.2.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fengguang Wu <fengguang.wu@intel.com> writes:

>> >> I tested by custom bdi with BDI_CAP_NO_WRITEBACK - sync(2) blocked
>> >> forever by this reason.
>> >
>> > What's your test script? How do you create/use that custom bdi?
>> 
>> Ah, I wrote my kernel module to test. I guess there is no users in
>> current kernel for now, because it doesn't work.
>
> OK. Got it. So I'd suggest to change the first chunk to a VM_BUG_ON(),
> which should be enough to catch new bad callers. The other two chunks
> look fine.

Hm, if it changed to VM_BUG_ON(), we can't use BDI_CAP_NO_WRITEBACK to
disable the writeback task (but allow inode cache reclaim) after all.

Or you meant we don't allow to disable the writeback task?

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
