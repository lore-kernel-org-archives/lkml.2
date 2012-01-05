Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754929Ab2AECZ3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 21:25:29 -0500
Received: from mga14.intel.com ([143.182.124.37]:33127 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751467Ab2AECZ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 21:25:28 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="92522685"
Date: Thu, 5 Jan 2012 10:25:25 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: 3.2.0-rc5 NULL dereference BUG
Message-ID: <20120105022525.GA9408@localhost>
References: <20111218055359.GA17182@localhost>
 <20111218063054.GA4979@localhost>
 <CAGBYx2bxdnkXcZF+A1iOvnsW=xdtDJR7Fx3Rz-HWeWH5n0ByKg@mail.gmail.com>
 <20111218113237.GA1359@localhost>
 <20120105015609.GA7913@localhost>
 <CAGBYx2ZyiKrbsQmiC3YxB7sKjhEQVeznUM2cGrXMyQuXPZ5o1Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGBYx2ZyiKrbsQmiC3YxB7sKjhEQVeznUM2cGrXMyQuXPZ5o1Q@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 05, 2012 at 10:23:13AM +0800, Yongqiang Yang wrote:
> Hi Fengguang,
> 
> > [  646.051405]  ffff880004ee1978 0000000000000000 0000000000000170 0000000000000000
> > [  646.051405] Call Trace:
> > [  646.051405]  [<ffffffff81099aa3>] ? sched_clock_local+0x12/0x75
> > [  646.051405]  [<ffffffff810a5a16>] lock_acquire+0xdd/0x10a
> > [  646.051405]  [<ffffffff81175de4>] ? create_empty_buffers+0x4a/0xc1
> > [  646.051405]  [<ffffffff8199f623>] _raw_spin_lock+0x36/0x69
> > [  646.051405]  [<ffffffff81175de4>] ? create_empty_buffers+0x4a/0xc1
> > [  646.051405]  [<ffffffff81175de4>] create_empty_buffers+0x4a/0xc1
> > [  646.051405]  [<ffffffff811efd2f>] ext4_discard_partial_page_buffers_no_lock+0x9f/0x406
> > [  646.051405]  [<ffffffff8199ffeb>] ? _raw_spin_unlock+0x2b/0x2f
> > [  646.051405]  [<ffffffff81170c26>] ? __mark_inode_dirty+0x1ac/0x1cc
> > [  646.051405]  [<ffffffff811767f3>] ? generic_write_end+0x6d/0x7f
> > [  646.051405]  [<ffffffff811f15e5>] ext4_da_write_end+0x244/0x2ed
> > [  646.051405]  [<ffffffff810ffeec>] generic_file_buffered_write+0x183/0x22d
> It seems that you are running in to several problems related to
> discard_page_buffers_no_lock in write_end.  The problems had been
> fixed by following patches [ext4: avoid potential hang in
> mpage_submit_io() when blocksize < pagesize], [ext4: correctly handle
> pages w/o buffers in ext4_discard_partial_buffers()] and [ext4: handle
> EOF correctly in ext4_bio_write_page()].   The patches had been merged
> to rc6.

That's great! I'll test rc7+.

Thanks,
Fengguang
