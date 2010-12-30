Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752081Ab0L3HBB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Dec 2010 02:01:01 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:29336 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751752Ab0L3HBA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Dec 2010 02:01:00 -0500
Message-ID: <4D1C2E86.9000004@oracle.com>
Date: Thu, 30 Dec 2010 12:32:30 +0530
From: Gurudas Pai <gurudas.pai@ORACLE.COM>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Hugh Dickins <hughd@google.com>
CC: Miklos Szeredi <miklos@szeredi.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [BUG] kernel BUG at mm/truncate.c:479! on 2.6.37-rc8
References: <4D1AD935.1020504@oracle.com> <alpine.LSU.2.00.1012291137080.6381@sister.anvils>
In-Reply-To: <alpine.LSU.2.00.1012291137080.6381@sister.anvils>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> With 2.6.37-rc8 , run a fio test over nfs, with following jobfile, and we
>> hit kernel bug.
> 
> Have you tried the same test on earlier releases?
> I think the bug is old, yet only recently reported.
I tried with 2.6.36.2 , even there it is panicing.


> This NFS-triggered kernel BUG at mm/truncate.c:479 sounds very like
> the FUSE-triggered kernel BUG at mm/truncate.c:475 on 2.6.36.1 for
> which Miklos posted a patch on 14 December.  Please give his patch
> (below) a try and let us know if it fixes the issue for you - thanks.
Issue fixed with the patch, Thanks :)


So I did some additional testing with different fio jobfiles to run 
tests on nfs, and we got panic, this is not introduced by your patch, 
since this happens even without it. Should I start a different mail 
thread for this ?

------------[ cut here ]------------
kernel BUG at fs/aio.c:554!
invalid opcode: 0000 [#2] SMP
last sysfs file: /sys/devices/system/cpu/cpu3/cache/index2/shared_cpu_map
CPU 1
Modules linked in: nls_utf8 netconsole configfs autofs4 hidp nfs fscache 
nfs_acl auth_rpcgss rfcomm l2cap bluetooth rfkill lockd sunrpc ipv6 
parport_pc lp parport snd_seq_dummy snd_seq_oss snd_seq_midi_event 
snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss snd_pcm snd_timer snd 
soundcore i2c_amd756 tg3 hpwdt i2c_core snd_page_alloc serio_raw 
pata_amd amd_rng amd64_edac_mod pcspkr pata_acpi edac_core k8temp floppy 
ata_generic qla2xxx scsi_transport_fc scsi_tgt cciss shpchp uhci_hcd 
ohci_hcd ehci_hcd [last unloaded: mperf]

Pid: 3063, comm: fio Tainted: G      D     2.6.37-rc8-hugh #2 /ProLiant 
DL585 G1
RIP: 0010:[<ffffffff811419e6>]  [<ffffffff811419e6>] 
__aio_put_req+0x28/0x128
RSP: 0018:ffff880e5a743e28  EFLAGS: 00010086
RAX: 00000000ffffffff RBX: ffff880e4fd26b80 RCX: e440000000000000
RDX: 0000000013111310 RSI: ffff880e4fd26b80 RDI: ffff880e53b18b80
RBP: ffff880e5a743e38 R08: ffff880e980d2c88 R09: ffff880f7d4d4b40
R10: ffffffffa0385950 R11: ffff880f7d4d48c0 R12: ffff880e53b18b40
R13: ffff880f7128dc88 R14: 0000000000000000 R15: ffff880e53b18b40
FS:  00000000425ab940(0063) GS:ffff8800f5480000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00007f972f77f000 CR3: 0000000e9dad2000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process fio (pid: 3063, threadinfo ffff880e5a742000, task ffff880e4fcc4340)
Stack:
  ffff880e53b18b40 ffff880e4fd26b80 ffff880e5a743e68 ffffffff81141b11
  ffff880e5a743e68 ffffffffffffffea ffffffffffffffea ffff880e4fd26b80
  ffff880e5a743f68 ffffffff8114298c ffff880e4fcc4340 00ff880f7f2e6480
Call Trace:
  [<ffffffff81141b11>] aio_put_req+0x2b/0x43
  [<ffffffff8114298c>] do_io_submit+0x506/0x66a
  [<ffffffff81142b00>] sys_io_submit+0x10/0x12
  [<ffffffff8100ac42>] system_call_fastpath+0x16/0x1b
Code: 5c c9 c3 55 48 89 e5 41 54 53 66 66 66 66 90 49 89 fc 48 8d 7f 40 
48 89 f3 e8 59 fc ff ff 8b 43 18 ff c8 83 f8 00 89 43 18 7d 04 <0f> 0b 
eb fe 74 07 31 c0 e9 ee 00 00 00 48 8d 8b b0 00 00 00 48
RIP  [<ffffffff811419e6>] __aio_put_req+0x28/0x128
  RSP <ffff880e5a743e28>
---[ end trace af672efc2fc9c083 ]---



> There's another of these page_mapped truncation BUGs outstanding,
> that we suspect has a different cause: yours doesn't sound like that
> one.  I can't explain why three people now in the space of one month
> should at last hit these ancient bugs!
> 


Thanks,
-Guru
