Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753659Ab1DJO73 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Apr 2011 10:59:29 -0400
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:41238 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752328Ab1DJO71 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Apr 2011 10:59:27 -0400
Date: Sun, 10 Apr 2011 15:59:20 +0100
From: Sitsofe Wheeler <sitsofe@yahoo.com>
To: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Subject: Re: WARNING: at block/genhd.c:1556 disk_clear_events+0xdc/0xf0()
Message-ID: <20110410145920.GA3408@sucs.org>
References: <20110404211604.GB6133@sucs.org> <20110406130423.GE4142@mtj.dyndns.org> <20110406212611.GA5131@sucs.org> <20110406213718.GA14139@mtj.dyndns.org> <20110409093449.GA10016@sucs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110409093449.GA10016@sucs.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 09, 2011 at 10:34:49AM +0100, Sitsofe Wheeler wrote:
> On Wed, Apr 06, 2011 at 02:37:18PM -0700, Tejun Heo wrote:
> > 
> > The problem would be quite timing dependent.  It would be great if you
> > can prepare a setup where you can reproduce the problem on some
> > regular basis and make sure that the problem goes away with the patch
> > applied.
> 
> Try as I might I cannot even reproduce the problem with the original
> problem kernels. I've tried all sorts (such as plugging in multiple USB

Shortly after saying this the problem reappeared by itself. I've found a
method to reproduce it too: by running
for i in `seq 1 100`; do udevadm trigger --subsystem-match=block ; done
and then waiting at the desktop for a five or so minutes (so the
requests that are backed up drain away) then running it again etc. the
problem will usually trigger. The warning is still here in the most
recent 2.6.39-rc2-00120-g94c8a98 kernel too. Applying the patch to the
first kernel that showed th problem doesn't fix the issue (although it
appears to make the issue a lot more difficult to trigger).

[   40.370083] wlan0: no IPv6 routers present
[ 5217.888074] ------------[ cut here ]------------
[ 5217.888095] WARNING: at block/genhd.c:1553 disk_clear_events+0xdc/0xf0()
[ 5217.888101] Hardware name: 900
[ 5217.888109] Pid: 1740, comm: hald-addon-stor Not tainted 2.6.39-rc1-00220-g148086b-dirty #397
[ 5217.888115] Call Trace:
[ 5217.888127]  [<b0127218>] warn_slowpath_common+0x68/0xa0
[ 5217.888136]  [<b0254e8c>] ? disk_clear_events+0xdc/0xf0
[ 5217.888143]  [<b0254e8c>] ? disk_clear_events+0xdc/0xf0
[ 5217.888152]  [<b012726b>] warn_slowpath_null+0x1b/0x20
[ 5217.888159]  [<b0254e8c>] disk_clear_events+0xdc/0xf0
[ 5217.888169]  [<b01c29d5>] check_disk_change+0x25/0x70
[ 5217.888178]  [<b0345747>] sd_open+0x97/0x180
[ 5217.888185]  [<b03456b0>] ? sd_release+0x60/0x60
[ 5217.888192]  [<b01c3aa5>] __blkdev_get+0x265/0x310
[ 5217.888200]  [<b01c3b96>] blkdev_get+0x46/0x2c0
[ 5217.888209]  [<b051216d>] ? _raw_spin_unlock+0x1d/0x20
[ 5217.888217]  [<b01c3e65>] blkdev_open+0x55/0x70
[ 5217.888226]  [<b0193272>] __dentry_open+0x112/0x290
[ 5217.888234]  [<b0193456>] nameidata_to_filp+0x66/0x70
[ 5217.888242]  [<b01c3e10>] ? blkdev_get+0x2c0/0x2c0
[ 5217.888251]  [<b01a050d>] do_last+0x19d/0x770
[ 5217.888259]  [<b01a1740>] path_openat+0x90/0x310
[ 5217.888267]  [<b01a1acd>] do_filp_open+0x5d/0x80
[ 5217.888274]  [<b051216d>] ? _raw_spin_unlock+0x1d/0x20
[ 5217.888284]  [<b01aec64>] ? alloc_fd+0x164/0x1b0
[ 5217.888292]  [<b0194591>] do_sys_open+0xf1/0x1c0
[ 5217.888301]  [<b0181b0f>] ? might_fault+0x7f/0x90
[ 5217.888308]  [<b01946c9>] sys_open+0x29/0x40
[ 5217.888316]  [<b0512917>] sysenter_do_call+0x12/0x36
[ 5217.888322] ---[ end trace e99fcb86a68da1f4 ]---
[ 5793.762848] [drm:i915_gem_object_bind_to_gtt] *ERROR* Attempting to bind a purgeable object
[ 6153.518126] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[ 6153.519121] ata2.00: BMDMA stat 0x65
[ 6153.519673] ata2.00: cmd c8/00:08:a0:de:77/00:00:00:00:00/e0 tag 0 dma 4096 in
[ 6153.519676]          res 51/44:08:a0:de:77/00:00:00:00:00/e0 Emask 0x9 (media error)

I will note that by EeePC's onboard "gen-0" SSD mysteriously developed
bad blocks after all this so perhaps the above is especially stressful
for disks...

-- 
Sitsofe | http://sucs.org/~sits/
