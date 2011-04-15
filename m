Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757302Ab1DOVlr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 17:41:47 -0400
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:58442 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757077Ab1DOVlq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 17:41:46 -0400
Date: Fri, 15 Apr 2011 22:41:40 +0100
From: Sitsofe Wheeler <sitsofe@yahoo.com>
To: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Subject: Re: WARNING: at block/genhd.c:1556 disk_clear_events+0xdc/0xf0()
Message-ID: <20110415214140.GB1295@sucs.org>
References: <20110404211604.GB6133@sucs.org> <20110406130423.GE4142@mtj.dyndns.org> <20110406212611.GA5131@sucs.org> <20110406213718.GA14139@mtj.dyndns.org> <20110409093449.GA10016@sucs.org> <20110410145920.GA3408@sucs.org> <20110413200000.GG3987@mtj.dyndns.org> <20110415090118.GA3315@mtj.dyndns.org> <20110415182006.GA15916@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110415182006.GA15916@mtj.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 16, 2011 at 03:20:06AM +0900, Tejun Heo wrote:
> Please try the following patch instead.  Thanks.

I couldn't reproduce the problem with the very latest kernel but here's
the output that appeared with an older kernel with your patch:

------------[ cut here ]------------
WARNING: at block/genhd.c:1561 disk_clear_events+0x164/0x170()
Hardware name: 900
Pid: 10200, comm: blkid Not tainted 2.6.39-rc1-00220-g148086b-dirty #407
Call Trace:
 [<b0127218>] warn_slowpath_common+0x68/0xa0
 [<b0254f24>] ? disk_clear_events+0x164/0x170
 [<b0254f24>] ? disk_clear_events+0x164/0x170
 [<b012726b>] warn_slowpath_null+0x1b/0x20
 [<b0254f24>] disk_clear_events+0x164/0x170
 [<b01c29d5>] check_disk_change+0x25/0x70
 [<b03457e7>] sd_open+0x97/0x180
 [<b0345750>] ? sd_release+0x60/0x60
 [<b01c3aa5>] __blkdev_get+0x265/0x310
 [<b01c2ee7>] ? bdget+0x37/0x100
 [<b01c3a0d>] __blkdev_get+0x1cd/0x310
 [<b01c3b96>] blkdev_get+0x46/0x2c0
 [<b05139dd>] ? _raw_spin_unlock+0x1d/0x20
 [<b01c3e65>] blkdev_open+0x55/0x70
 [<b0193272>] __dentry_open+0x112/0x290
 [<b0193456>] nameidata_to_filp+0x66/0x70
 [<b01c3e10>] ? blkdev_get+0x2c0/0x2c0
 [<b01a050d>] do_last+0x19d/0x770
 [<b01a1740>] path_openat+0x90/0x310
 [<b01a1acd>] do_filp_open+0x5d/0x80
 [<b05139dd>] ? _raw_spin_unlock+0x1d/0x20
 [<b01aec64>] ? alloc_fd+0x164/0x1b0
 [<b0194591>] do_sys_open+0xf1/0x1c0
 [<b01946c9>] sys_open+0x29/0x40
 [<b0514197>] sysenter_do_call+0x12/0x36
---[ end trace e94a40ecc7f65c23 ]---

-- 
Sitsofe | http://sucs.org/~sits/
