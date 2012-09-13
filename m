Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755557Ab2IMFlm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 01:41:42 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:38269 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753133Ab2IMFlk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 01:41:40 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: viro@zeniv.linux.org.uk, jack@suse.cz, hch@lst.de,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix queueing work if !bdi_cap_writeback_dirty()
References: <87wr002z39.fsf@devron.myhome.or.jp>
	<20120912024249.GB17922@localhost>
	<87sjan3c27.fsf@devron.myhome.or.jp>
	<20120913003337.GA16363@localhost>
Date: Thu, 13 Sep 2012 14:41:31 +0900
In-Reply-To: <20120913003337.GA16363@localhost> (Fengguang Wu's message of
	"Thu, 13 Sep 2012 08:33:37 +0800")
Message-ID: <87a9wueayc.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.2.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fengguang Wu <fengguang.wu@intel.com> writes:

>> If used custom bdi with BDI_CAP_NO_WRITEBACK, wait_for_completion()
>> (e.g. sync_inodes_sb()) will be blocked forever.
>
> The sync(2) block cannot be fixed by this patch?

This patch fixes block problem too.

>> I tested by custom bdi with BDI_CAP_NO_WRITEBACK - sync(2) blocked
>> forever by this reason.
>
> What's your test script? How do you create/use that custom bdi?

Ah, I wrote my kernel module to test. I guess there is no users in
current kernel for now, because it doesn't work.

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
