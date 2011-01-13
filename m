Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756508Ab1AMAYP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 19:24:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56807 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754892Ab1AMAYO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 19:24:14 -0500
Message-ID: <4D2E4611.90002@redhat.com>
Date: Thu, 13 Jan 2011 01:23:45 +0100
From: Milan Broz <mbroz@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101213 Thunderbird/3.1.7
MIME-Version: 1.0
To: Valdis.Kletnieks@vt.edu
CC: Alexander Viro <viro@zeniv.linux.org.uk>, Neil Brown <neilb@suse.de>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-raid@vger.kernel.org,
        device-mapper development <dm-devel@redhat.com>,
        Tejun Heo <tj@kernel.org>
Subject: Re: linux-next - WARNING: at fs/block_dev.c:824 bd_link_disk_holder+0x92/0x1ac()
References: <16069.1294853673@localhost>
In-Reply-To: <16069.1294853673@localhost>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/12/2011 06:34 PM, Valdis.Kletnieks@vt.edu wrote:
> Seen in a boot of yesterday's linux-next.   The 'W' flag was due to the
> already-reported 'WARNING: at kernel/workqueue.c:1202 worker_enter_idle'.
> Not sure if it's a block_dev or dm/LVM issue, so I'm cc:'ing both groups.  I wonder
> if the fact I still have 'CONFIG_DEVTMPFS=n' is involved (it's apparently ticking off
> dracut before and after the warning).
> 
> [   16.840333] dracut: Found volume group "vg_blackice" using metadata type lvm2
> [   16.892282] dracut: The link /dev/vg_blackice/opt should had been created by udev but it was not found.  Falling back to direct link creation.
> [   16.912627] ------------[ cut here ]------------
> [   16.912635] WARNING: at fs/block_dev.c:824 bd_link_disk_holder+0x92/0x1ac()

That seems to be
WARN_ON_ONCE(!bdev->bd_holder || bdev->bd_holder_disk);
added in patch
http://git.kernel.org/?p=linux/kernel/git/next/linux-next.git;a=commitdiff;h=e09b457bdb7e8d23fc54dcef0930ac697d8de895
"block: simplify holder symlink handling"

dm linear just claims device in table constructor, I don't think it is bug in DM code.

> [   16.912638] Hardware name: Latitude E6500
> [   16.912640] Modules linked in:
> [   16.912644] Pid: 1920, comm: lvm Tainted: G        W   2.6.37-next-20110111 #1
> [   16.912647] Call Trace:
> [   16.912653]  [<ffffffff8103a989>] ? warn_slowpath_common+0x80/0x98
> [   16.912657]  [<ffffffff8103a9b6>] ? warn_slowpath_null+0x15/0x17
> [   16.912660]  [<ffffffff8111fb03>] ? bd_link_disk_holder+0x92/0x1ac
> [   16.912665]  [<ffffffff8139b875>] ? open_dev+0x76/0x9e
> [   16.912668]  [<ffffffff8139bc9d>] ? dm_get_device+0x147/0x1dc
> [   16.912672]  [<ffffffff8139d088>] ? linear_ctr+0x98/0xd4
> [   16.912676]  [<ffffffff8139c289>] ? dm_table_add_target+0x149/0x1d4
> [   16.912679]  [<ffffffff8139e57c>] ? table_load+0xf0/0x27b
> [   16.912683]  [<ffffffff8139e48c>] ? table_load+0x0/0x27b
> [   16.912686]  [<ffffffff8139f326>] ? ctl_ioctl+0x1c6/0x21e
> [   16.912690]  [<ffffffff8139f38c>] ? dm_ctl_ioctl+0xe/0x12
> [   16.912695]  [<ffffffff8110258e>] ? do_vfs_ioctl+0x4c4/0x505
> [   16.912699]  [<ffffffff81102626>] ? sys_ioctl+0x57/0x95
> [   16.912703]  [<ffffffff8100253b>] ? system_call_fastpath+0x16/0x1b
> [   16.912706] ---[ end trace 4eaa2a86a8e2da24 ]---
> [   16.925289] dracut: The link /dev/vg_blackice/src should had been created by udev but it was not found.  Falling back to direct link creation.
> 

Milan
