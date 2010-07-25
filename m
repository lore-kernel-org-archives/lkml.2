Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752023Ab0GYQL4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jul 2010 12:11:56 -0400
Received: from relay01.mx.bawue.net ([193.7.176.67]:50040 "EHLO
	relay01.mx.bawue.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751206Ab0GYQLS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jul 2010 12:11:18 -0400
Date: Sun, 25 Jul 2010 17:57:31 +0200
From: Nils Radtke <lkml@Think-Future.de>
To: linux-kernel@vger.kernel.org
Subject: WARNING: at fs/buffer.c:1159 mark_buffer_dirty, ext3
Message-ID: <20100725155731.GI31966@localhost>
Reply-To: Nils Radtke <lkml@Think-Future.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Url: http://www.Think-Future.de
X-Editor: Vi it! http://www.vim.org
X-Bkp: p2mi
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi,
  
This is the first time this one hit. Didn't notice this a second time.


Cheers,

  Nils

[1542330.660579] usb 1-3: USB disconnect, address 87
[1542330.660586] usb 1-3.1: USB disconnect, address 88
[1542330.664564] drivers/hid/usbhid/hid-core.c: can't reset device, 0000:00:1a
.7-3.3/input0, status -71
[1542330.664578] usb 1-3: clear tt 1 (0590) error -19
[1542330.665806] usb 1-3.3: USB disconnect, address 89
[1566623.048359] usb 2-1: USB disconnect, address 33
[1566623.048864] sd 121:0:0:0: Device offlined - not ready after error recover
y
[1566623.049033] sd 121:0:0:0: [sdc] Unhandled error code
[1566623.049039] sd 121:0:0:0: [sdc] Result: hostbyte=0x01 driverbyte=0x00
[1566623.049047] sd 121:0:0:0: [sdc] CDB: cdb[0]=0x28: 28 00 01 ce 95 b7 00 00
 08 00
[1566623.049086] end_request: I/O error, dev sdc, sector 30315959
[1566623.049139] Buffer I/O error on device dm-5, logical block 5818911
[1566623.049145] lost page write due to I/O error on dm-5
[1566623.049162] Buffer I/O error on device dm-5, logical block 5818912

[...]

[1566623.049306] Buffer I/O error on device dm-5, logical block 5818920
[1566623.049312] lost page write due to I/O error on dm-5
[1566623.258087] usb 2-1: new high speed USB device using ehci_hcd and address
 34
[1566623.360360] usb 2-1: device descriptor read/64, error -32
[1566623.467383] EXT3-fs error (device dm-5): ext3_get_inode_loc: unable to re
ad inode block - inode=983059, block=3932163
[1566623.467779] EXT3-fs error (device dm-5): ext3_get_inode_loc: unable to re
ad inode block - inode=983060, block=3932163

[...]

[1566623.467800] ------------[ cut here ]------------
[1566623.467807] WARNING: at fs/buffer.c:1159 mark_buffer_dirty+0x80/0xa0()
[1566623.467810] Hardware name: 7666B4G
[1566623.467811] Modules linked in: iwlagn iwlcore xt_TCPMSS ipt_MASQUERADE op
tion usbserial btusb uvcvideo nf_conntrack_netlink vboxdrv ipt_LOG xt_tcpudp x
t_state iptable_filter iptable_mangle iptable_nat nf_nat ip_tables x_tables tp
_smapi thinkpad_ec rtc_cmos e1000e [last unloaded: iwlcore]
[1566623.467837] Pid: 5456, comm: filezilla Tainted: G        W  2.6.32.7 #8
[1566623.467840] Call Trace:
[1566623.467844]  [<c110f5a0>] ? mark_buffer_dirty+0x80/0xa0
[1566623.467848]  [<c110f5a0>] ? mark_buffer_dirty+0x80/0xa0
[1566623.467852]  [<c104723f>] ? warn_slowpath_common+0x6f/0xd0
[1566623.467856]  [<c110f5a0>] ? mark_buffer_dirty+0x80/0xa0
[1566623.467859]  [<c10472b3>] ? warn_slowpath_null+0x13/0x20
[1566623.467863]  [<c110f5a0>] ? mark_buffer_dirty+0x80/0xa0
[1566623.467868]  [<c11691a6>] ? ext3_commit_super+0x46/0x90
[1566623.467871]  [<c116ac37>] ? ext3_handle_error+0x47/0xb0
[1566623.467875]  [<c1743b64>] ? printk+0x17/0x23
[1566623.467879]  [<c116ad64>] ? ext3_error+0x54/0x60
[1566623.467883]  [<c1160a3d>] ? __ext3_get_inode_loc+0x29d/0x2f0
[1566623.467887]  [<c1160af8>] ? ext3_iget+0x68/0x430
[1566623.467891]  [<c10fe9b7>] ? __d_lookup+0xb7/0x120
[1566623.467895]  [<c1167621>] ? ext3_lookup+0x91/0x120
[1566623.467899]  [<c174659d>] ? _spin_lock+0xd/0x30
[1566623.467903]  [<c17469dc>] ? _spin_unlock+0xc/0x30
[1566623.467906]  [<c10fee15>] ? d_alloc+0x125/0x170
[1566623.467910]  [<c10f4a5f>] ? __lookup_hash+0xef/0x110
[1566623.467914]  [<c10f880b>] ? do_filp_open+0x33b/0x9f0
[1566623.467919]  [<c17469dc>] ? _spin_unlock+0xc/0x30
[1566623.467924]  [<c10e9bcd>] ? do_sys_open+0x6d/0x130
[1566623.467928]  [<c1024f1e>] ? do_page_fault+0x12e/0x300
[1566623.467932]  [<c10e9d0c>] ? sys_open+0x2c/0x40
[1566623.467936]  [<c1002ef0>] ? sysenter_do_call+0x12/0x22
[1566623.467939] ---[ end trace 6e995fdd89a1285b ]---

