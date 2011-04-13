Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932894Ab1DMQ35 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 12:29:57 -0400
Received: from mail.candelatech.com ([208.74.158.172]:45588 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932697Ab1DMQ3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 12:29:54 -0400
Message-ID: <4DA5CF81.4070908@candelatech.com>
Date: Wed, 13 Apr 2011 09:29:53 -0700
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc11 Thunderbird/3.0.4
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: WARNING at libata-core.c:5015 in 2.6.39-rc3-wl+, then lockup.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This on an multi-core Atom based appliance.  Using SSD for hard-drive.
Fedora 14 OS.

2.6.39-rc* has been very flaky for me on this system (haven't tried other
machines yet), and I'm pretty sure I saw similar bugs on earlier 39-rc kernels though
they often crashed on other things as well...

I can provide more info as needed.

This is the warning that hits...
	/*
	 * We guarantee to LLDs that they will have at least one
	 * non-zero sg if the command is a data command.
	 */
	if (WARN_ON_ONCE(ata_is_data(prot) &&
			 (!qc->sg || !qc->n_elem || !qc->nbytes)))
		goto sys_err;

After the warning and the errors below, the system locks hard.
The same system works fine on 2.6.38 kernels.


WARNING: at /home/greearb/git/linux.wireless-testing/drivers/ata/libata-core.c:5015 ata_qc_issue+0x15d/0x296()
Hardware name: To Be Filled By O.E.M.
Modules linked in: fuse macvlan pktgen coretemp hwmon nfs lockd fscache auth_rpcgss nfs_acl sunrpc ipv6 uinput arc4 ath9k snd_hda_codec_realtek mac80]
Pid: 1745, comm: agetty Not tainted 2.6.39-rc3-wl+ #58
Call Trace:
  [<c043a11a>] warn_slowpath_common+0x6a/0x7f
  [<c06a9395>] ? ata_qc_issue+0x15d/0x296
  [<c043a143>] warn_slowpath_null+0x14/0x18
  [<c06a9395>] ata_qc_issue+0x15d/0x296
  [<c06af2c7>] __ata_scsi_queuecmd+0x15b/0x1a0
  [<c06ae9cf>] ? ata_scsiop_mode_sense+0x25c/0x25c
  [<c06af38e>] ata_scsi_queuecmd+0x3c/0x63
  [<c0690dbe>] scsi_dispatch_cmd+0x161/0x1ee
  [<c0695ef8>] scsi_request_fn+0x319/0x44a
  [<c05b5c5e>] __blk_run_queue+0x5d/0x8d
  [<c05b601d>] blk_run_queue+0x22/0x33
  [<c06956d3>] scsi_run_queue+0x28a/0x30e
  [<c0691040>] ? __scsi_put_command+0x59/0x5f
  [<c06961d4>] scsi_next_command+0x2d/0x39
  [<c0696cfd>] scsi_io_completion+0x3e8/0x41f
  [<c069683a>] ? scsi_device_unbusy+0x8c/0x92
  [<c0690b5b>] scsi_finish_command+0xc5/0xcd
  [<c0696e25>] scsi_softirq_done+0xdd/0xe5
  [<c05bb0c2>] blk_done_softirq+0x66/0x73
  [<c043fbda>] __do_softirq+0xb1/0x17c
  [<c043fb29>] ? __local_bh_enable+0x8c/0x8c
  <IRQ>  [<c043f9aa>] ? irq_exit+0x43/0x8e
  [<c0403b43>] ? do_IRQ+0x81/0x95
  [<c07fa92e>] ? common_interrupt+0x2e/0x40
  [<c05b00d8>] ? crypto_shash_show+0x10/0x3f
  [<c0431109>] ? __might_sleep+0x1/0xe4
  [<c0505f20>] ? __getblk+0x30/0x321
  [<c050582e>] ? submit_bh+0xf8/0x107
  [<c0506a4f>] ? ll_rw_block+0x61/0x76
  [<c050710f>] ? __breadahead+0x13/0x3b
  [<c054ab89>] ? __ext4_get_inode_loc+0x29b/0x34e
  [<c054bc11>] ? ext4_iget+0x57/0x6a8
  [<c055216f>] ? ext4_lookup+0x66/0xb8
  [<c04ed4ea>] ? d_alloc_and_lookup+0x3d/0x54
  [<c04eeaed>] ? walk_component+0x138/0x2b7
  [<c04ef1f8>] ? link_path_walk+0x8a/0x394
  [<c04eed69>] ? do_last+0xfd/0x502
  [<c04ef612>] ? path_openat+0x9b/0x28a
  [<c04ef8cc>] ? do_filp_open+0x3d/0x62
  [<c04eaaec>] ? open_exec+0x1d/0x72
  [<c04eb52e>] ? do_execve+0x8c/0x22e
  [<c040830a>] ? sys_execve+0x31/0x54
  [<c07fa452>] ? ptregs_execve+0x12/0x20
  [<c07fa35c>] ? sysenter_do_call+0x12/0x38
---[ end trace 876a5fd18a969c02 ]---
ata1.01: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
ata1.01: failed command: READ DMA
ata1.01: cmd c8/00:18:48:ba:cf/00:00:00:00:00/f0 tag 0 dma 12288 in
          res 50/00:00:28:ba:cf/00:00:00:00:00/f0 Emask 0x40 (internal error)
ata1.01: status: { DRDY }
ata1.01: configured for UDMA/100
sd 0:0:1:0: [sda]  Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
sd 0:0:1:0: [sda]  Sense Key : Aborted Command [current] [descriptor]
Descriptor sense data with sense descriptors (in hex):
         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00
         00 cf ba 28
sd 0:0:1:0: [sda]  Add. Sense: No additional sense information
sd 0:0:1:0: [sda] CDB: Read(10): 28 00 00 cf ba 48 00 00 18 00
end_request: I/O error, dev sda, sector 13613640
ata1: EH complete

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

