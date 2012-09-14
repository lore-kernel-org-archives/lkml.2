Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755147Ab2INNtZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 09:49:25 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:38813 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752304Ab2INNtY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 09:49:24 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: viro@zeniv.linux.org.uk, jack@suse.cz, hch@lst.de,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix queueing work if !bdi_cap_writeback_dirty()
References: <87wr002z39.fsf@devron.myhome.or.jp>
	<20120913063906.GA24974@localhost>
	<871ui6e4tl.fsf@devron.myhome.or.jp>
	<20120914111429.GA19509@localhost>
	<87r4q4n6r1.fsf@devron.myhome.or.jp>
	<20120914125312.GA20973@localhost>
	<87mx0sn463.fsf@devron.myhome.or.jp>
	<20120914133300.GA22390@localhost>
Date: Fri, 14 Sep 2012 22:49:21 +0900
In-Reply-To: <20120914133300.GA22390@localhost> (Fengguang Wu's message of
	"Fri, 14 Sep 2012 21:33:00 +0800")
Message-ID: <87ehm4n28u.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.2.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fengguang Wu <fengguang.wu@intel.com> writes:

>> > And BDI_CAP_NO_WRITEBACK is expected to be a static/constant flag that
>> > always evaluate to true/false for a given bdi.  There will be
>> > correctness problems if you change the BDI_CAP_NO_WRITEBACK flag
>> > dynamically.
>> 
>> I'm going to use it as static or per-sb by initialized in
>> fill_super(). And it uses always BDI_CAP_NO_WRITEBACK if sb is
>> available. Because own FS task flush instead.
>
> Ah OK, sorry I didn't quite catch your use case.
>
> But then if you set BDI_CAP_NO_WRITEBACK in the beginning, how come
> __bdi_start_writeback() will be called at all?

If we call mark_inode_dirty(inode), inode goes into bdi->wb.b_dirty.
And sync(2) calls __bdi_start_writeback() for all of bdi if bdi->wb.b_*
is not empty.

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
