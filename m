Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932401Ab0FPUQt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 16:16:49 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:60563 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932220Ab0FPUQr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 16:16:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=jhfs9PrwsY1/vcaBZU6giIRifjiQxWBduZH1xOCqPVrTW22BscPWxBTxyS9s3jXz0r
         q9CFxhFWOnXp1JRYBPY3USECBIBQpIaN2zfg61cJmbMXnKRqBHsMAnbUsEVSHPsH8qCg
         KUEO4hx1bncWAC1EmYFUInd5xgClOvnYIsNXU=
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: Jan De Luyck <mailinglists+linuxkernel_20080830@kcore.org>
Subject: Re: Fwd: [2.6.34] INFO: task rsync:20019 blocked for more than 120 seconds.
Date: Wed, 16 Jun 2010 22:16:42 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.35-rc3; KDE/4.4.4; i686; ; )
Cc: linux-kernel@vger.kernel.org
References: <AANLkTimSPX7dZGFcfiA2VABn212M_pPoiJR7LuqWO7_r@mail.gmail.com> <AANLkTimutyh3WIALv3NIxA8Xt5JtU6tp4EWOnuSqhdyD@mail.gmail.com>
In-Reply-To: <AANLkTimutyh3WIALv3NIxA8Xt5JtU6tp4EWOnuSqhdyD@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201006162216.43010.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On poniedziałek, 14 czerwca 2010 o 21:49:30 Jan De Luyck wrote:
> Hey Folks,
> 
> I recently switched over to 2.6.34, and now I'm getting these:
> INFO: task rsync:20019 blocked for more than 120 seconds.
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> rsync D 000000000006a7c6 0 20019 20005 0x00000004
> ffff88001dcb9b48 0000000000000082 0000000000004000 0000000000011bc0
> ffff88001dcb9fd8 ffff88001dcb9fd8 ffff8800672d5730 0000000000011bc0
> 0000000000000000 ffffffff81101fac ffff8800672d5730 ffffffff8161b020
> Call Trace:
> [<ffffffff81101fac>] ? ext4_check_dir_entry+0x38/0xfe
> [<ffffffff810b3e91>] ? ll_rw_block+0xe0/0xfe
> [<ffffffff812cdea5>] ? _raw_spin_lock_irqsave+0x18/0x34
> [<ffffffff810a5710>] ? __wait_on_freeing_inode+0x83/0xa1
> [<ffffffff810434b2>] ? wake_bit_function+0x0/0x23
> [<ffffffff810a5758>] ? find_inode_fast+0x2a/0x4c
> [<ffffffff810a57a2>] ? ifind_fast+0x28/0x81
> [<ffffffff810a6475>] ? iget_locked+0x30/0x151
> [<ffffffff81105de8>] ? ext4_iget+0x26/0x704
> [<ffffffff812cdc5e>] ? _raw_spin_unlock+0x10/0x2c
> [<ffffffff8110ec95>] ? ext4_lookup+0x83/0xda
> [<ffffffff8109baf5>] ? do_lookup+0xfb/0x1d9
> [<ffffffff8109db7b>] ? link_path_walk+0x6cd/0xb25
> [<ffffffff8109e12c>] ? path_walk+0x6a/0xe2
> [<ffffffff8109e271>] ? do_path_lookup+0x20/0x41
> [<ffffffff8109eb83>] ? user_path_at+0x48/0x7f
> [<ffffffff810a09b8>] ? filldir+0x0/0xa9
> [<ffffffff81097363>] ? cp_new_stat+0xe9/0xfb
> [<ffffffff812cdecf>] ? _raw_spin_lock+0xe/0x24
> [<ffffffff81097228>] ? vfs_fstatat+0x2c/0x57
> [<ffffffff810973b6>] ? sys_newlstat+0x11/0x30
> [<ffffffff81001f2b>] ? system_call_fastpath+0x16/0x1b
> 
> This did not show up with any 2.6.33.x.
> Any fix to try?

I created a Bugzilla entry at 
https://bugzilla.kernel.org/show_bug.cgi?id=16233
for your bug report, please add your address to the CC list in there, thanks!

-- 
Maciej Rutecki
http://www.maciek.unixy.pl
