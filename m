Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752232Ab1CZO5Y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Mar 2011 10:57:24 -0400
Received: from bamccaig1.svc.tomasu.net ([64.85.170.232]:37534 "EHLO
	mail.tomasu.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752077Ab1CZO5W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Mar 2011 10:57:22 -0400
From: Thomas Fjellstrom <thomas@fjellstrom.ca>
Reply-To: thomas@fjellstrom.ca
To: linux-kernel@vger.kernel.org
Subject: Re: BUG: unable to handle kernel NULL pointer dereference
Date: Sat, 26 Mar 2011 08:57:15 -0600
User-Agent: KMail/1.13.5 (Linux/2.6.37.2; KDE/4.5.2; x86_64; svn-1188918; 2010-10-21)
References: <201103260513.52916.tfjellstrom@strangesoft.net>
In-Reply-To: <201103260513.52916.tfjellstrom@strangesoft.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201103260857.16238.thomas@fjellstrom.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On March 26, 2011, Thomas Fjellstrom wrote:
> I was unable to capture the full OOPS/panic message as it was a full panic.
> The kernel switched to a vt first so I could at least take a picture, which
> I've attached.
> 
> This is with 2.6.37.2. A brief snippet from the image is as follows:
> 
> IP: [<ffffffff8110f3a7>] __mark_inode_dirty+0xca/0x1ac
> PGD 9fe96067 PUD 30e34067 PMD 0
> Oops: 0000 [#1] SMP
> ...
> Call Trace:
>  ? touch_atime+0x111/0x13a
>  ? filldir+0x0/0xc3
>  ? vfs_readdir+0x84/0xaa
>  ? sys_getdents+0x7d/0xcd
>  ? page_fault+0x25/0x30
>  ? system_call_fastpath+0x16/0x1b
> 
> This has only happened once so far, and a little while before this OOPS
> happened, X crashed and was restarted.

And here's another possible related problem:

[13082.904110] INFO: task updatedb.mlocat:6215 blocked for more than 120 
seconds.
[13082.904113] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables 
this message.
[13082.904116] updatedb.mloc D ffff88002adf3600     0  6215   6208 0x00000000
[13082.904120]  ffff88002adf3600 0000000000000082 ffff880100000000 ffffffff8160b020
[13082.904124]  00000000000136c0 ffff88002a091fd8 00000000000136c0 
00000000000136c0
[13082.904127]  ffff88002adf38d8 ffff88002adf38e0 ffff88002adf3600 00000000000136c0
[13082.904130] Call Trace:
[13082.904137]  [<ffffffff8111513b>] ? sync_buffer+0x0/0x3f
[13082.904141]  [<ffffffff8131d6f3>] ? io_schedule+0x68/0xa7
[13082.904144]  [<ffffffff81115176>] ? sync_buffer+0x3b/0x3f
[13082.904146]  [<ffffffff8131db3f>] ? __wait_on_bit_lock+0x3c/0x85
[13082.904149]  [<ffffffff8131dbf6>] ? out_of_line_wait_on_bit_lock+0x6e/0x77
[13082.904151]  [<ffffffff8111513b>] ? sync_buffer+0x0/0x3f
[13082.904155]  [<ffffffff810605ab>] ? wake_bit_function+0x0/0x2e
[13082.904164]  [<ffffffff81116033>] ? lock_buffer+0xe/0x2c
[13082.904166]  [<ffffffff811168e5>] ? __bread+0x1d/0x62
[13082.904171]  [<ffffffffa04639b2>] ? fat_get_entry+0x189/0x1ef [fat]
[13082.904175]  [<ffffffffa0463a59>] ? fat_get_short_entry+0x41/0x53 [fat]
[13082.904178]  [<ffffffffa0464b19>] ? fat_subdirs+0x57/0x74 [fat]
[13082.904181]  [<ffffffffa0468e18>] ? fat_build_inode+0x1af/0x402 [fat]
[13082.904184]  [<ffffffff81202020>] ? startup_pirq+0x3a/0x139
[13082.904188]  [<ffffffffa02184cc>] ? vfat_lookup+0x57/0x16f [vfat]
[13082.904191]  [<ffffffff810fbc19>] ? d_alloc_and_lookup+0x4a/0x67
[13082.904193]  [<ffffffff810fbd26>] ? do_lookup+0xaa/0x100
[13082.904196]  [<ffffffff81103590>] ? dput+0x2c/0x12f
[13082.904198]  [<ffffffff810fdb69>] ? link_path_walk+0x2a1/0x3fb
[13082.904201]  [<ffffffff810fddb2>] ? path_walk+0x63/0xd6
[13082.904203]  [<ffffffff810fd406>] ? path_init+0x9a/0x16e
[13082.904205]  [<ffffffff810fdf1b>] ? do_path_lookup+0x20/0x85
[13082.904207]  [<ffffffff810fe9a9>] ? user_path_at+0x46/0x78
[13082.904210]  [<ffffffff810f70dc>] ? cp_new_stat+0xe6/0xfa
[13082.904213]  [<ffffffff810f7183>] ? vfs_fstatat+0x2e/0x5b
[13082.904215]  [<ffffffff810f7208>] ? sys_newlstat+0x11/0x2d
[13082.904218]  [<ffffffff810f2c00>] ? sys_fchdir+0x67/0x6e
[13082.904221]  [<ffffffff81009a12>] ? system_call_fastpath+0x16/0x1b

theres 5-10 of those in dmesg, which started after I started copying some files 
to a new 16GB usb flash drive. The copies them selves have been going for hours 
now, waay too long, and both my CPU cores are pegged in iowait, and anything 
that tries to do too much with /any/ disk seems to hang up, including chromium 
and plain old 'ls'. according to iostat, io is going at about 8-40KB/s to the 
flash drive, and much less to my root drive.

-- 
Thomas Fjellstrom
thomas@fjellstrom.ca
