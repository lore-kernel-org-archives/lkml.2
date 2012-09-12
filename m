Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757232Ab2ILGpd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 02:45:33 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49217 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756225Ab2ILGpa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 02:45:30 -0400
Message-ID: <50502F7D.10307@suse.com>
Date: Wed, 12 Sep 2012 12:15:17 +0530
From: Suresh Jayaraman <sjayaraman@suse.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120825 Thunderbird/15.0
MIME-Version: 1.0
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Trond Myklebust <Trond.Myklebust@netapp.com>,
        Richard Ems <richard.ems@cape-horn-eng.com>
Subject: Re: [ 92/95] NFS: Fix Oopses in nfs_lookup_revalidate and  nfs4_lookup_revalidate
References: <20120909224203.153990066@decadent.org.uk>
In-Reply-To: <20120909224203.153990066@decadent.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10/2012 04:13 AM, Ben Hutchings wrote:
> 3.2-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Trond Myklebust <Trond.Myklebust@netapp.com>
> 
> Fix the following Oops in 3.5.1:
> 
>  BUG: unable to handle kernel NULL pointer dereference at 0000000000000038
>  IP: [<ffffffffa03789cd>] nfs_lookup_revalidate+0x2d/0x480 [nfs]
>  PGD 337c63067 PUD 0
>  Oops: 0000 [#1] SMP
>  CPU 5
>  Modules linked in: nfs fscache nfsd lockd nfs_acl auth_rpcgss sunrpc af_packet binfmt_misc cpufreq_conservative cpufreq_userspace cpufreq_powersave dm_mod acpi_cpufreq mperf coretemp gpio_ich kvm_intel joydev kvm ioatdma hid_generic igb lpc_ich i7core_edac edac_core ptp serio_raw dca pcspkr i2c_i801 mfd_core sg pps_core usbhid crc32c_intel microcode button autofs4 uhci_hcd ttm drm_kms_helper drm i2c_algo_bit sysimgblt sysfillrect syscopyarea ehci_hcd usbcore usb_common scsi_dh_rdac scsi_dh_emc scsi_dh_hp_sw scsi_dh_alua scsi_dh edd fan ata_piix thermal processor thermal_sys
> 
>  Pid: 30431, comm: java Not tainted 3.5.1-2-default #1 Supermicro X8DTT/X8DTT
>  RIP: 0010:[<ffffffffa03789cd>]  [<ffffffffa03789cd>] nfs_lookup_revalidate+0x2d/0x480 [nfs]
>  RSP: 0018:ffff8801b418bd38  EFLAGS: 00010292
>  RAX: 00000000fffffff6 RBX: ffff88032016d800 RCX: 0000000000000020
>  RDX: ffffffff00000000 RSI: 0000000000000000 RDI: ffff8801824a7b00
>  RBP: ffff8801b418bdf8 R08: 7fffff0034323030 R09: fffffffff04c03ed
>  R10: ffff8801824a7b00 R11: 0000000000000002 R12: ffff8801824a7b00
>  R13: ffff8801824a7b00 R14: 0000000000000000 R15: ffff8803201725d0
>  FS:  00002b53a46cb700(0000) GS:ffff88033fc20000(0000) knlGS:0000000000000000
>  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>  CR2: 0000000000000038 CR3: 000000020a426000 CR4: 00000000000007e0
>  DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>  DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
>  Process java (pid: 30431, threadinfo ffff8801b418a000, task ffff8801b5d20600)
>  Stack:
>   ffff8801b418be44 ffff88032016d800 ffff8801b418bdf8 0000000000000000
>   ffff8801824a7b00 ffff8801b418bdd7 ffff8803201725d0 ffffffff8116a9c0
>   ffff8801b5c38dc0 0000000000000007 ffff88032016d800 0000000000000000
>  Call Trace:
>   [<ffffffff8116a9c0>] lookup_dcache+0x80/0xe0
>   [<ffffffff8116aa43>] __lookup_hash+0x23/0x90
>   [<ffffffff8116b4a5>] lookup_one_len+0xc5/0x100
>   [<ffffffffa03869a3>] nfs_sillyrename+0xe3/0x210 [nfs]
>   [<ffffffff8116cadf>] vfs_unlink.part.25+0x7f/0xe0
>   [<ffffffff8116f22c>] do_unlinkat+0x1ac/0x1d0
>   [<ffffffff815717b9>] system_call_fastpath+0x16/0x1b
>   [<00002b5348b5f527>] 0x2b5348b5f526
>  Code: ec 38 b8 f6 ff ff ff 4c 89 64 24 18 4c 89 74 24 28 49 89 fc 48 89 5c 24 08 48 89 6c 24 10 49 89 f6 4c 89 6c 24 20 4c 89 7c 24 30 <f6> 46 38 40 0f 85 d1 00 00 00 e8 c4 c4 df e0 48 8b 58 30 49 89
>  RIP  [<ffffffffa03789cd>] nfs_lookup_revalidate+0x2d/0x480 [nfs]
>   RSP <ffff8801b418bd38>
>  CR2: 0000000000000038
>  ---[ end trace 845113ed191985dd ]---
> 
> This Oops affects 3.5 kernels and older, and is due to lookup_one_len()
> calling down to the dentry revalidation code with a NULL pointer
> to struct nameidata.

Hmm.. in this case which filesystem is calling nfs_lookup_revalidate()
with NULL nd?

A similar patch has already been NACKed by Trond as it could break NFS
exclusive creates. The discussion thread can be found here

   http://www.spinics.net/lists/linux-nfs/msg20932.html



Thanks
Suresh

