Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752467Ab0FXF4N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 01:56:13 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:47411 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751249Ab0FXF4L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 01:56:11 -0400
Message-ID: <4C22F316.3080009@oracle.com>
Date: Thu, 24 Jun 2010 13:54:30 +0800
From: Tao Ma <tao.ma@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Tao Ma <tao.ma@oracle.com>
CC: Jeff Moyer <jmoyer@redhat.com>, axboe@kernel.dk, vgoyal@redhat.com,
       linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
       Joel Becker <joel.becker@oracle.com>,
       Sunil Mushran <sunil.mushran@oracle.com>,
       "ocfs2-devel@oss.oracle.com" <ocfs2-devel@oss.oracle.com>
Subject: Re: [PATCH 0/3 v5][RFC] ext3/4: enhance fsync performance when using
 CFQ
References: <1277242502-9047-1-git-send-email-jmoyer@redhat.com> <4C21D442.8080703@oracle.com>
In-Reply-To: <4C21D442.8080703@oracle.com>
Content-Type: multipart/mixed;
 boundary="------------030802050803090707050503"
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090206.4C22F36C.010A:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030802050803090707050503
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi Jeff,

On 06/23/2010 05:30 PM, Tao Ma wrote:
> Hi Jeff,
>
> On 06/23/2010 05:34 AM, Jeff Moyer wrote:
>> Hi,
>>
>> Running iozone with the fsync flag, or fs_mark, the performance of CFQ is
>> far worse than that of deadline for enterprise class storage when dealing
>> with file sizes of 8MB or less. I used the following command line as a
>> representative test case:
>>
>> fs_mark -S 1 -D 10000 -N 100000 -d /mnt/test/fs_mark -s 65536 -t 1 -w
>> 4096 -F
>>
>> When run using the deadline I/O scheduler, an average of the first 5
>> numbers
>> will give you 448.4 files / second. CFQ will yield only 106.7. With
>> this patch series applied (and the two patches I sent yesterday), CFQ now
>> achieves 462.5 files / second.
> which 2 patches? Could you paste the link or the subject? Just want to
> make my test env like yours. ;)
> As Joel mentioned in another mail, ocfs2 also use jbd/jbd2, so I'd like
> to give it a try and give you some feedback about the test.
I am sorry to say that the patch make jbd2 locked up when I tested 
fs_mark using ocfs2.
I have attached the log from my netconsole server. After I reverted the 
patch [3/3], the box works again.

Regards,
Tao

--------------030802050803090707050503
Content-Type: text/x-log;
 name="lockup.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="lockup.log"

 BUG: soft lockup - CPU#0 stuck for 61s! [jbd2/sda11-15:5456] 
 Modules linked in:
  ocfs2
  jbd2
  ocfs2_nodemanager
  configfs
  ocfs2_stackglue
  netconsole
  autofs4
  hidp
  rfcomm
  l2cap
  crc16
  bluetooth
  rfkill
  sunrpc
  ib_iser
  rdma_cm
  ib_cm
  iw_cm
  ib_sa
  ib_mad
  ib_core
  ib_addr
  ipv6
  iscsi_tcp
  libiscsi_tcp
  libiscsi
  scsi_transport_iscsi
  dm_mirror
  dm_region_hash
  dm_log
  dm_multipath
  dm_mod
  video
  output
  sbs
  sbshc
  battery
  acpi_memhotplug
  ac
  lp
  sg
  dcdbas
  sr_mod
  cdrom
  option
  usb_wwan
  usbserial
  serio_raw
  rtc_cmos
  rtc_core
  parport_pc
  parport
  rtc_lib
  snd_hda_codec_analog
  tpm_tis
  tpm
  tpm_bios
  button
  snd_hda_intel
  snd_hda_codec
  snd_seq_dummy
  snd_seq_oss
  snd_seq_midi_event
  snd_seq
  e1000
  tg3
  snd_seq_device
  libphy
  i2c_i801
  snd_pcm_oss
  snd_mixer_oss
  i2c_core
  snd_pcm
  snd_timer
  snd
  soundcore
  snd_page_alloc
  shpchp
  pcspkr
  ata_piix
  libata
  sd_mod
  scsi_mod
  ext3
  jbd
  ehci_hcd
  ohci_hcd
  uhci_hcd
  [last unloaded: microcode]
  
 CPU 0 
  
 Modules linked in:
  ocfs2
  jbd2
  ocfs2_nodemanager
  configfs
  ocfs2_stackglue
  netconsole
  autofs4
  hidp
  rfcomm
  l2cap
  crc16
  bluetooth
  rfkill
  sunrpc
  ib_iser
  rdma_cm
  ib_cm
  iw_cm
  ib_sa
  ib_mad
  ib_core
  ib_addr
  ipv6
  iscsi_tcp
  libiscsi_tcp
  libiscsi
  scsi_transport_iscsi
  dm_mirror
  dm_region_hash
  dm_log
  dm_multipath
  dm_mod
  video
  output
  sbs
  sbshc
  battery
  acpi_memhotplug
  ac
  lp
  sg
  dcdbas
  sr_mod
  cdrom
  option
  usb_wwan
  usbserial
  serio_raw
  rtc_cmos
  rtc_core
  parport_pc
  parport
  rtc_lib
  snd_hda_codec_analog
  tpm_tis
  tpm
  tpm_bios
  button
  snd_hda_intel
  snd_hda_codec
  snd_seq_dummy
  snd_seq_oss
  snd_seq_midi_event
  snd_seq
  e1000
  tg3
  snd_seq_device
  libphy
  i2c_i801
  snd_pcm_oss
  snd_mixer_oss
  i2c_core
  snd_pcm
  snd_timer
  snd
  soundcore
  snd_page_alloc
  shpchp
  pcspkr
  ata_piix
  libata
  sd_mod
  scsi_mod
  ext3
  jbd
  ehci_hcd
  ohci_hcd
  uhci_hcd
  [last unloaded: microcode]
  
  
 Pid: 5456, comm: jbd2/sda11-15 Not tainted 2.6.35-rc3+ #4 0MM599/OptiPlex 745                  
 RIP: 0010:[<ffffffff822fcfe7>] 
  [<ffffffff822fcfe7>] _raw_spin_lock+0xe/0x15 
 RSP: 0018:ffff88012780de78  EFLAGS: 00000297 
 RAX: 0000000000001d1c RBX: ffff88012fbb4000 RCX: 0000000000000000 
 RDX: 0000000000000000 RSI: ffff88012fbd9650 RDI: ffff88012fbb4024 
 RBP: ffffffff820031ce R08: ffff88012780c000 R09: 0000000000000000 
 R10: ffff88012fbd8fa8 R11: 0000000000000000 R12: ffff88013a545880 
 R13: ffffffff8202d2b5 R14: 0000000000000000 R15: ffff880001e13640 
 FS:  0000000000000000(0000) GS:ffff880001e00000(0000) knlGS:0000000000000000 
 CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b 
 CR2: 0000000000000000 CR3: 0000000127853000 CR4: 00000000000006f0 
 DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000 
 DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400 
 Process jbd2/sda11-15 (pid: 5456, threadinfo ffff88012780c000, task ffff88012fbd8f60) 
 Stack: 
  ffffffffa027b955
  0000000000000000
  ffff88012fbd8f60
  ffffffff8204de27
  
 
  ffff88012780de98
  ffff88012780de98
  ffff88012fbfbae8
  0000000000000292
  
 
  ffff88012780def8
  ffff88012fbb4000
  ffff88012fbfbae0
  ffffffffa027b7fa
  
 Call Trace: 
  [<ffffffffa027b955>] ? kjournald2+0x15b/0x1cf [jbd2] 
  [<ffffffff8204de27>] ? autoremove_wake_function+0x0/0x2e 
  [<ffffffffa027b7fa>] ? kjournald2+0x0/0x1cf [jbd2] 
  [<ffffffff8204db33>] ? kthread+0x79/0x81 
  [<ffffffff82003614>] ? kernel_thread_helper+0x4/0x10 
  [<ffffffff8204daba>] ? kthread+0x0/0x81 
  [<ffffffff82003610>] ? kernel_thread_helper+0x0/0x10 
 Code: 
 e0 
 8d 
 90 
 00 
 01 
 00 
 00 
 75 
 05 
 3e 
 66 
 0f 
 b1 
 17 
 0f 
 94 
 c2 
 0f 
 b6 
 c2 
 85 
 c0 
 0f 
 95 
 c0 
 0f 
 b6 
 c0 
 c3 
 b8 
 00 
 01 
 00 
 00 
 3e 
 66 
 0f 
 c1 
 07 
 38 
 e0 
 74 
 06 
 f3> 
 90 
 8a 
 07 
 eb 
 f6 
 c3 
 9c 
 58 
 fa 
 ba 
 00 
 01 
 00 
 00 
 3e 
 66 
 0f 
 c1 
 17 
 38 
  
 Call Trace: 
  [<ffffffffa027b955>] ? kjournald2+0x15b/0x1cf [jbd2] 
  [<ffffffff8204de27>] ? autoremove_wake_function+0x0/0x2e 
  [<ffffffffa027b7fa>] ? kjournald2+0x0/0x1cf [jbd2] 
  [<ffffffff8204db33>] ? kthread+0x79/0x81 
  [<ffffffff82003614>] ? kernel_thread_helper+0x4/0x10 
  [<ffffffff8204daba>] ? kthread+0x0/0x81 
  [<ffffffff82003610>] ? kernel_thread_helper+0x0/0x10 

--------------030802050803090707050503--
