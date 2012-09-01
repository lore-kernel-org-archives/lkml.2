Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755811Ab2IAXNm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2012 19:13:42 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:35964
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755779Ab2IAXNk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2012 19:13:40 -0400
Date: Sat, 1 Sep 2012 19:13:38 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com, linux-m@kvack.org
Subject: Re: 3.5.2: moving files from xfs/disk -> nfs:
 radix_tree_lookup_slot+0xe/0x10
Message-ID: <20120901231338.GE6896@infradead.org>
References: <CAO9zADzH7mG3Kp1EQ-0MtTE2CdyLmuz9jsaijgTXLSJ9rZ9tiw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAO9zADzH7mG3Kp1EQ-0MtTE2CdyLmuz9jsaijgTXLSJ9rZ9tiw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'd suspect it's something with the actual radix tree code, Ccing
linux-mm in case they know more.

On Mon, Aug 27, 2012 at 11:00:10AM -0400, Justin Piszcz wrote:
> Hi,
> 
> Moving ~276GB of files (mainly large backups) and everything has
> seemed to lockup on the client moving data to the server, it is still
> in this state..
> 
> [75716.705697] INFO: task sync:8790 blocked for more than 120 seconds.
> [75716.705701] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> [75716.705703] sync            D ffff88040ec54830     0  8790   2141 0x00000000
> [75716.705708]  ffff88001fff1d08 0000000000000086 ffffffff81862fc0
> ffff88001fff1fd8
> [75716.705713]  ffff88001fff1fd8 0000000000004000 ffff88041d958670
> ffff88040ec54830
> [75716.705716]  ffff88001fff1c38 ffffffff812dcaee ffff88001fff1c58
> ffff88001fff1d78
> [75716.705720] Call Trace:
> [75716.705729]  [<ffffffff812dcaee>] ? radix_tree_lookup_slot+0xe/0x10
> [75716.705733]  [<ffffffff81082ca6>] ? find_get_pages_tag+0xc6/0x150
> [75716.705738]  [<ffffffff81057980>] ? __enqueue_entity+0x70/0x80
> [75716.705742]  [<ffffffff810e3450>] ? __sync_filesystem+0x90/0x90
> [75716.705747]  [<ffffffff815a3d04>] schedule+0x24/0x70
> [75716.705751]  [<ffffffff815a2549>] schedule_timeout+0x1a9/0x210
> [75716.705755]  [<ffffffff81089550>] ? calc_period_shift+0x60/0x60
> [75716.705760]  [<ffffffff81052ef5>] ? check_preempt_curr+0x75/0xa0
> [75716.705764]  [<ffffffff815a3420>] wait_for_common+0xc0/0x150
> [75716.705767]  [<ffffffff81055af0>] ? try_to_wake_up+0x280/0x280
> [75716.705770]  [<ffffffff810e3450>] ? __sync_filesystem+0x90/0x90
> [75716.705773]  [<ffffffff815a3d78>] wait_for_completion+0x18/0x20
> [75716.705777]  [<ffffffff810dfa47>] writeback_inodes_sb_nr+0x77/0xa0
> [75716.705782]  [<ffffffff810d0101>] ?
> shrink_dcache_for_umount_subtree+0x111/0x1d0
> [75716.705785]  [<ffffffff810dfa99>] writeback_inodes_sb+0x29/0x40
> [75716.705788]  [<ffffffff810e3407>] __sync_filesystem+0x47/0x90
> [75716.705791]  [<ffffffff810e346b>] sync_one_sb+0x1b/0x20
> [75716.705795]  [<ffffffff810bea71>] iterate_supers+0xe1/0xf0
> [75716.705798]  [<ffffffff810e355b>] sys_sync+0x2b/0x60
> [75716.705802]  [<ffffffff815a53a6>] system_call_fastpath+0x1a/0x1f
> [75836.701197] INFO: task sync:8790 blocked for more than 120 seconds.
> 
> Thoughts?
> 
> Justin.
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
---end quoted text---
