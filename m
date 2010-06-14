Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753757Ab0FNTtd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 15:49:33 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:55074 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750888Ab0FNTtb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 15:49:31 -0400
MIME-Version: 1.0
X-Originating-IP: [78.22.161.179]
In-Reply-To: <AANLkTimSPX7dZGFcfiA2VABn212M_pPoiJR7LuqWO7_r@mail.gmail.com>
References: <AANLkTimSPX7dZGFcfiA2VABn212M_pPoiJR7LuqWO7_r@mail.gmail.com>
Date: Mon, 14 Jun 2010 21:49:30 +0200
X-Google-Sender-Auth: 91zlRXrTtEoKY4Q2TPHmVSxkamg
Message-ID: <AANLkTimutyh3WIALv3NIxA8Xt5JtU6tp4EWOnuSqhdyD@mail.gmail.com>
Subject: Fwd: [2.6.34] INFO: task rsync:20019 blocked for more than 120 
	seconds.
From: Jan De Luyck <mailinglists+linuxkernel_20080830@kcore.org>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Folks,

I recently switched over to 2.6.34, and now I'm getting these:
INFO: task rsync:20019 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
rsync D 000000000006a7c6 0 20019 20005 0x00000004
ffff88001dcb9b48 0000000000000082 0000000000004000 0000000000011bc0
ffff88001dcb9fd8 ffff88001dcb9fd8 ffff8800672d5730 0000000000011bc0
0000000000000000 ffffffff81101fac ffff8800672d5730 ffffffff8161b020
Call Trace:
[<ffffffff81101fac>] ? ext4_check_dir_entry+0x38/0xfe
[<ffffffff810b3e91>] ? ll_rw_block+0xe0/0xfe
[<ffffffff812cdea5>] ? _raw_spin_lock_irqsave+0x18/0x34
[<ffffffff810a5710>] ? __wait_on_freeing_inode+0x83/0xa1
[<ffffffff810434b2>] ? wake_bit_function+0x0/0x23
[<ffffffff810a5758>] ? find_inode_fast+0x2a/0x4c
[<ffffffff810a57a2>] ? ifind_fast+0x28/0x81
[<ffffffff810a6475>] ? iget_locked+0x30/0x151
[<ffffffff81105de8>] ? ext4_iget+0x26/0x704
[<ffffffff812cdc5e>] ? _raw_spin_unlock+0x10/0x2c
[<ffffffff8110ec95>] ? ext4_lookup+0x83/0xda
[<ffffffff8109baf5>] ? do_lookup+0xfb/0x1d9
[<ffffffff8109db7b>] ? link_path_walk+0x6cd/0xb25
[<ffffffff8109e12c>] ? path_walk+0x6a/0xe2
[<ffffffff8109e271>] ? do_path_lookup+0x20/0x41
[<ffffffff8109eb83>] ? user_path_at+0x48/0x7f
[<ffffffff810a09b8>] ? filldir+0x0/0xa9
[<ffffffff81097363>] ? cp_new_stat+0xe9/0xfb
[<ffffffff812cdecf>] ? _raw_spin_lock+0xe/0x24
[<ffffffff81097228>] ? vfs_fstatat+0x2c/0x57
[<ffffffff810973b6>] ? sys_newlstat+0x11/0x30
[<ffffffff81001f2b>] ? system_call_fastpath+0x16/0x1b

This did not show up with any 2.6.33.x.
Any fix to try?

Kind regards

Jan
