Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752829Ab0D0BMr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 21:12:47 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:36508 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751451Ab0D0BMq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 21:12:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=gG6ySDfs15J4p+evKdb7r00vaCetjhT2l45/x0XKFC/kZw07zJ49mmESBSE9iGFMSX
         1GF7flBBRLL5vUWDHZqp12vZHs2wmw7sNdN+Utdb0dfG+ZJOcmvmYcVwI9UxOI9AsVJH
         LMv2vK2SEt19iEOOGGB3Rzii5j3JYwh8sIfts=
Message-ID: <4BD63A0C.7040303@gmail.com>
Date: Mon, 26 Apr 2010 19:12:44 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
CC: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org
Subject: Re: INFO: umount blocked for more than 120 seconds
References: <20100426090142.GB3704@swordfish.minsk.epam.com>
In-Reply-To: <20100426090142.GB3704@swordfish.minsk.epam.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/26/2010 03:01 AM, Sergey Senozhatsky wrote:
> Hello,
> MiniSD card mounted through the USB card reader.
>
> .34-rc5-git6
>
> kernel: [ 5746.170226] scsi12 : usb-storage 2-2:1.0
> kernel: [ 5747.174113] scsi scan: INQUIRY result too short (5), using 36
> kernel: [ 5747.174128] scsi 12:0:0:0: Direct-Access                                    PQ: 0 ANSI: 0
> kernel: [ 5747.180721] sd 12:0:0:0: Attached scsi generic sg2 type 0
> kernel: [ 5747.190490] sd 12:0:0:0: [sdb] 2012160 512-byte logical blocks: (1.03 GB/982 MiB)
> kernel: [ 5747.193398] sd 12:0:0:0: [sdb] Write Protect is off
> kernel: [ 5747.193403] sd 12:0:0:0: [sdb] Mode Sense: 00 06 00 00
> kernel: [ 5747.193406] sd 12:0:0:0: [sdb] Assuming drive cache: write through
> kernel: [ 5747.207116] sd 12:0:0:0: [sdb] Assuming drive cache: write through
> kernel: [ 5747.207125]  sdb: sdb1
> kernel: [ 5747.233099] sd 12:0:0:0: [sdb] Assuming drive cache: write through
> kernel: [ 5747.233112] sd 12:0:0:0: [sdb] Attached SCSI removable disk
> kernel: [ 5758.495211] FAT: utf8 is not a recommended IO charset for FAT filesystems, filesystem will be case sensitive!
> kernel: [ 6360.626229] INFO: task umount:4235 blocked for more than 120 seconds.
> kernel: [ 6360.626237] "echo 0>  /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> kernel: [ 6360.626246] umount        D 0000059e     0  4235   3382 0x00000000
> kernel: [ 6360.626259]  f6e09e38 00000046 38aa246b 0000059e c1610cc0 c12c3880 c1610cc0 c1610cc0
> kernel: [ 6360.626282]  c1610cc0 c1610cc0 f6fa6cd0 c1610cc0 00002d16 00000000 38a9f755 0000059e
> kernel: [ 6360.626304]  f6fa6a40 f6e09e40 f6e09e70 00000000 f6e09e78 f6e09e40 c10b7cf0 f6e09e5c
> kernel: [ 6360.626334] Call Trace:
> kernel: [ 6360.626345]  [<c12c3880>] ? _raw_spin_unlock_irqrestore+0x36/0x5b
> kernel: [ 6360.626353]  [<c10b7cf0>] bdi_sched_wait+0x8/0xc
> kernel: [ 6360.626358]  [<c12c20df>] __wait_on_bit+0x34/0x5b
> kernel: [ 6360.626363]  [<c10b7ce8>] ? bdi_sched_wait+0x0/0xc
> kernel: [ 6360.626368]  [<c12c215d>] out_of_line_wait_on_bit+0x57/0x5f
> kernel: [ 6360.626373]  [<c10b7ce8>] ? bdi_sched_wait+0x0/0xc
> kernel: [ 6360.626379]  [<c103fa75>] ? wake_bit_function+0x0/0x4d
> kernel: [ 6360.626385]  [<c10b84d4>] wait_on_bit.clone.0+0x17/0x23
> kernel: [ 6360.626390]  [<c10b8544>] sync_inodes_sb+0x64/0x10d
> kernel: [ 6360.626397]  [<c10d373f>] ? vfs_quota_sync+0x0/0x1da
> kernel: [ 6360.626402]  [<c10baef6>] __sync_filesystem+0x37/0x62
> kernel: [ 6360.626407]  [<c10bb062>] sync_filesystem+0x3c/0x3f
> kernel: [ 6360.626413]  [<c10a2def>] generic_shutdown_super+0x1c/0xca
> kernel: [ 6360.626418]  [<c10a2eba>] kill_block_super+0x1d/0x31
> kernel: [ 6360.626423]  [<c10a3833>] deactivate_super+0x48/0x5a
> kernel: [ 6360.626429]  [<c10b385c>] mntput_no_expire+0x5e/0x89
> kernel: [ 6360.626434]  [<c10b41cf>] sys_umount+0x277/0x29b
> kernel: [ 6360.626440]  [<c10b4200>] sys_oldumount+0xd/0xf
> kernel: [ 6360.626445]  [<c1002813>] sysenter_do_call+0x12/0x32
> kernel: [ 6360.626450] 1 lock held by umount/4235:
> kernel: [ 6360.626453]  #0:  (&type->s_umount_key#34){++++..}, at: [<c10a382e>] deactivate_super+0x43/0x5a

Is this some super-slow SD card or USB reader that you just wrote a 
bunch of data to? It's not impossible it could take 2 minutes for the 
writeout of all the dirty data to complete on unmount.. did the unmount 
ever complete?
