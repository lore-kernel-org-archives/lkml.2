Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756837Ab0EJWVn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 18:21:43 -0400
Received: from mail-pz0-f204.google.com ([209.85.222.204]:45065 "EHLO
	mail-pz0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751196Ab0EJWVl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 18:21:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=NAJeNEv5xnDH3wz4mINNAyUiXqPS9/dX7abbSt9fdRYSPMI+R/Pc1a5fB637ZUEldy
         u7MhZb0CdogdkAzMuvCyYiiisoZF71LrbZyG5gF2E0e8YQD6CUVqEyZq0Vsl9Vd5EeKW
         GzMeOCLdU+RmgnuWMscv2F8Pz2aC6LGB5QueU=
Message-ID: <4BE88705.9030105@gmail.com>
Date: Mon, 10 May 2010 15:21:57 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: linux-ext4@vger.kernel.org
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: INFO: task umount:1524 blocked for more than 120 seconds
References: <h2xdd18b0c31005101446pf8201153vaed5b38afe72d7ad@mail.gmail.com>
In-Reply-To: <h2xdd18b0c31005101446pf8201153vaed5b38afe72d7ad@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/10/2010 02:46 PM, Justin Mattock wrote:
> I have a reproduceable problem  happening over here
> with unmount and ext4
> if I sudo cp -R xserver(all libs/apps from git)
> to an external
> SmartDsk FireLite
> then after the cp is done
> sudo umount /dev/sdb1
>
> I get this:
>
>   type=1400 audit(1273526248.814:27): avc:  denied  { unmount } for
> pid=1524 comm="umount" scontext=justin:staff_r:staff_sudo_t:s0
> tcontext=system_u:object_r:fs_t:s0 tclass=filesystem
> [  360.669140] INFO: task umount:1524 blocked for more than 120 seconds.
> [  360.685771] "echo 0>  /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> [  360.702221] umount        D 0000000000000000     0  1524   1472 0x00000080
> [  360.702227]  ffff880080909c88 0000000000000086 ffff880080909da8
> 0000000000000000
> [  360.702233]  ffff880080909fd8 ffff88013845c4a0 0000000000013fc0
> ffff880080909fd8
> [  360.702238]  0000000000013fc0 0000000000013fc0 0000000000013fc0
> 0000000000013fc0
> [  360.702243] Call Trace:
> [  360.702252]  [<ffffffff8106e3f4>] ? spin_unlock_irqrestore+0x9/0xb
> [  360.702266]  [<ffffffff810fb214>] ? bdi_sched_wait+0x0/0xd
> [  360.702270]  [<ffffffff810fb21d>] bdi_sched_wait+0x9/0xd
> [  360.702276]  [<ffffffff813e2126>] __wait_on_bit+0x43/0x76
> [  360.702342]  [<ffffffff813e21c2>] out_of_line_wait_on_bit+0x69/0x74
> [  360.702346]  [<ffffffff810fb214>] ? bdi_sched_wait+0x0/0xd
> [  360.702350]  [<ffffffff8106e3bd>] ? wake_bit_function+0x0/0x2e
> [  360.702356]  [<ffffffff81051599>] ? wake_up_process+0x10/0x12
> [  360.702360]  [<ffffffff810fc00b>] T.732+0x19/0x1b
> [  360.702364]  [<ffffffff810fc06c>] bdi_sync_writeback+0x5f/0x66
> [  360.702368]  [<ffffffff810fc090>] sync_inodes_sb+0x1d/0xde
> [  360.702373]  [<ffffffff810ff04b>] __sync_filesystem+0x47/0x7e
> [  360.702377]  [<ffffffff810ff229>] sync_filesystem+0x47/0x4b
> [  360.702382]  [<ffffffff810e2df4>] generic_shutdown_super+0x22/0xf4
> [  360.702386]  [<ffffffff810e2ee8>] kill_block_super+0x22/0x3a
> [  360.702390]  [<ffffffff810e35f4>] deactivate_super+0x4c/0x64
> [  360.702394]  [<ffffffff810f6221>] mntput_no_expire+0xb0/0xde
> [  360.702397]  [<ffffffff810f679a>] sys_umount+0x2d9/0x304
> [  360.702402]  [<ffffffff810e899e>] ? path_put+0x1d/0x21
> [  360.702408]  [<ffffffff81024502>] system_call_fastpath+0x16/0x1b
> [  400.536564] ieee1394: Node changed: 0-01:1023 ->  0-00:1023
> [  400.536587] ieee1394: Node paused: ID:BUS[0-00:1023]  GUID[00d0010d0001eaa9]
> [  403.551124] ieee1394: Node removed: ID:BUS[0-00:1023]  GUID[00d0010d0001eaa9]
> [  403.551263] end_request: I/O error, dev sdb, sector 54795503
> [  403.564505] Aborting journal on device sdb1-8.
> [  403.577816] JBD2: I/O error detected when updating journal
> superblock for sdb1-8.
> [  403.591168] journal commit I/O error
>
>
> disk just sits there with the light on.
>
> if I disconnect, then re execute mount,cp,umount
> I can get this again:
>
> [  561.219470] type=1400 audit(1273526663.219:46): avc:  denied  {
> create } for  pid=1717 comm="cp" name="libpixman-1.so.0"
> scontext=justin:staff_r:staff_t:s0 tcontext=justin:object_r:mnt_t:s0
> tclass=lnk_file
> [  840.702375] INFO: task umount:1728 blocked for more than 120 seconds.
> [  840.702379] "echo 0>  /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> [  840.702382] umount        D 0000000000000000     0  1728   1676 0x00000080
> [  840.702388]  ffff8800808adc88 0000000000000086 ffff8800808adda8
> 0000000000000000
> [  840.702394]  ffff8800808adfd8 ffff88012abed3e0 0000000000013fc0
> ffff8800808adfd8
> [  840.702399]  0000000000013fc0 0000000000013fc0 0000000000013fc0
> 0000000000013fc0
> [  840.702404] Call Trace:
> [  840.702413]  [<ffffffff810fb214>] ? bdi_sched_wait+0x0/0xd
> [  840.702418]  [<ffffffff810fb21d>] bdi_sched_wait+0x9/0xd
> [  840.702424]  [<ffffffff813e2126>] __wait_on_bit+0x43/0x76
> [  840.702428]  [<ffffffff813e21c2>] out_of_line_wait_on_bit+0x69/0x74
> [  840.702432]  [<ffffffff810fb214>] ? bdi_sched_wait+0x0/0xd
> [  840.702437]  [<ffffffff8106e3bd>] ? wake_bit_function+0x0/0x2e
> [  840.702443]  [<ffffffff81051599>] ? wake_up_process+0x10/0x12
> [  840.702447]  [<ffffffff810fc00b>] T.732+0x19/0x1b
> [  840.702451]  [<ffffffff810fc06c>] bdi_sync_writeback+0x5f/0x66
> [  840.702456]  [<ffffffff810fc090>] sync_inodes_sb+0x1d/0xde
> [  840.702460]  [<ffffffff810ff04b>] __sync_filesystem+0x47/0x7e
> [  840.702465]  [<ffffffff810ff229>] sync_filesystem+0x47/0x4b
> [  840.702469]  [<ffffffff810e2df4>] generic_shutdown_super+0x22/0xf4
> [  840.702473]  [<ffffffff810e2ee8>] kill_block_super+0x22/0x3a
> [  840.702477]  [<ffffffff810e35f4>] deactivate_super+0x4c/0x64
> [  840.702481]  [<ffffffff810f6221>] mntput_no_expire+0xb0/0xde
> [  840.702485]  [<ffffffff810f679a>] sys_umount+0x2d9/0x304
> [  840.702490]  [<ffffffff810e899e>] ? path_put+0x1d/0x21
> [  840.702495]  [<ffffffff81024502>] system_call_fastpath+0x16/0x1b
>
>
> not sure what/when is the last good kernel, but can defiantly
> reset a few to find one, then do a bisect on this.
> (keep in mind I'll be leaving for a few days, so might do this
> until over the weekend or something).
>
>
>


maybe this is cable related i.g.
using a firewire cable from the apple
store($40big ones),on an imac gives this
message., but if I use the
cable from the firewire(slighty thicker), on
a macbook, I can do the above mount,cp,unmount
with the kernel, and hit nothing.(both xserver
and all its libs etc.. and the kernel both seem to
be pretty large to transfer).

Justin P. Mattock
