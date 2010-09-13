Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752637Ab0IMOvS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 10:51:18 -0400
Received: from relay01.mx.bawue.net ([193.7.176.67]:43501 "EHLO
	relay01.mx.bawue.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752540Ab0IMOvR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 10:51:17 -0400
Date: Mon, 13 Sep 2010 16:21:56 +0200
From: Nils Radtke <lkml@Think-Future.de>
To: Linux Kernel-Liste <linux-kernel@vger.kernel.org>
Subject: Option, pppd: Oops + page rq failure
Message-ID: <20100913142155.GG25129@localhost>
Reply-To: Nils Radtke <lkml@Think-Future.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Bkp: p2mi
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  
    Hi,

    Upon pulling the umts usb stick using the option driver 
    pppd/option oopsed.

  
Message from syslogd@localhost at Aug 17 15:01:36 ...
kernel:[782948.191180] Oops: 0000 [#2] PREEMPT SMP 
kernel:[782948.191189] last sysfs file: /sys/devices/pci0000:00/0000:00:1d.7/usb2/idVendor
kernel:[782948.191295] Process pppd (pid: 19294, ti=d403a000 task=f4358a90 task.ti=d403a000)
kernel:[782948.191295] Stack:
kernel:[782948.191295] Call Trace:
kernel:[782948.191295] Code: 09 d0 c3 eb 0d 90 90 90 90 90 90 90 90 90 90 90 90 90 83 ec 24 89 74 24 1c 89 c6 89 5c 24 18 89 7c 24 20 8b 18 8b 43 08 8b 40 04 <0f> b6 78 02 a1 28 15 de fc 85 c0 75 75 8d 86 00 01 00 00 e8 0f 
kernel:[782948.191295] EIP: [<fcddd2f9>] option_send_setup+0x19/0xc0 [option] SS:ESP 0068:d403bd14
kernel:[782948.191295] CR2: 0000000067754140

[782948.176189] usb 2-2: USB disconnect, address 62
[782948.176280] option: option_instat_callback: error -108
[782948.176994] option: option_instat_callback: error -108
[782948.178050] option1 ttyUSB0: GSM modem (1-port) converter now disconnected from ttyUSB0
[782948.178076] option 2-2:1.0: device disconnected
[782948.178424] option1 ttyUSB1: GSM modem (1-port) converter now disconnected from ttyUSB1
[782948.178456] option 2-2:1.1: device disconnected
[782948.178780] option1 ttyUSB2: GSM modem (1-port) converter now disconnected from ttyUSB2
[782948.178816] option 2-2:1.2: device disconnected
[782948.181553] option1 ttyUSB3: GSM modem (1-port) converter now disconnected from ttyUSB3
[782948.181709] option 2-2:1.3: device disconnected
[782948.182725] option1 ttyUSB4: GSM modem (1-port) converter now disconnected from ttyUSB4
[782948.182875] option 2-2:1.4: device disconnected
[782948.191145] BUG: unable to handle kernel paging request at 67754140
[782948.191156] IP: [<fcddd2f9>] option_send_setup+0x19/0xc0 [option]
[782948.191171] *pdpt = 0000000020994001 *pde = 0000000000000000 
[782948.191180] Oops: 0000 [#2] PREEMPT SMP 
[782948.191189] last sysfs file: /sys/devices/pci0000:00/0000:00:1d.7/usb2/idVendor
[782948.191196] Modules linked in: iwlagn btusb act_police vboxdrv(+) bridge stp option usbserial ipt_MASQUERADE xt_TCPMSS iptable_nat nf_nat iptable_mangle ipt_LOG xt_physdev xt_tcpudp xt_state iptable_filter ip_tables x_tables e1000e iwlcore mac80211 uvcvideo wmi cfg80211 btrfs atl1c uhci_hcd usb_storage [last unloaded: iwlagn]
[782948.191251] 
[782948.191258] Pid: 19294, comm: pppd Tainted: G      D    2.6.33.6 #2 Aspire 1810T
[782948.191265] EIP: 0060:[<fcddd2f9>] EFLAGS: 00210286 CPU: 1
[782948.191273] EIP is at option_send_setup+0x19/0xc0 [option]
[782948.191279] EAX: 6775413e EBX: e0767b40 ECX: 00000000 EDX: c7c7e400
[782948.191284] ESI: ef07d000 EDI: e0767b40 EBP: ed1d6ec0 ESP: d403bd14
[782948.191290]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[782948.191295] Process pppd (pid: 19294, ti=d403a000 task=f4358a90 task.ti=d403a000)
[782948.191295] Stack:
[782948.191295]  f4851e48 c102e547 000000c1 f4851e54 00000001 00000001 ef07d000 e0767b78
[782948.191295] <0> e0767b40 fcddd3f3 d57d5000 c16f60de c13b1674 00000000 ef07d000 d57d5000
[782948.191295] <0> 08000000 ef273f40 fcd87068 ef07d004 c13b174e c13b1953 ef273f40 d57d5000
[782948.191295] Call Trace:
[782948.191295]  [<c102e547>] ? __wake_up_common+0x47/0x70
[782948.191295]  [<fcddd3f3>] ? option_dtr_rts+0x53/0xa0 [option]
[782948.191295]  [<c16f60de>] ? _raw_spin_unlock_irqrestore+0xe/0x30
[782948.191295]  [<c13b1674>] ? tty_buffer_flush+0x54/0xe0
[782948.191295]  [<fcd87068>] ? serial_dtr_rts+0x18/0x20 [usbserial]
[782948.191295]  [<c13b174e>] ? tty_port_lower_dtr_rts+0xe/0x10
[782948.191295]  [<c13b1953>] ? tty_port_close_start+0xf3/0x1a0
[782948.191295]  [<c13b1e33>] ? tty_port_close+0x13/0x60
[782948.191295]  [<c13ab05f>] ? tty_release+0xff/0x5c0
[782948.191295]  [<c15adb01>] ? sock_sendmsg+0xf1/0x110
[782948.191295]  [<c10fe2ba>] ? __d_lookup+0x10a/0x120
[782948.191295]  [<fcd87712>] ? serial_activate+0x52/0x70 [usbserial]
[782948.191295]  [<c13b1dfa>] ? tty_port_open+0xaa/0xd0
[782948.191295]  [<c13abd6a>] ? tty_open+0x48a/0x540
[782948.191295]  [<c10ef08a>] ? chrdev_open+0x10a/0x240
[782948.191295]  [<c16f63cd>] ? _raw_spin_lock+0xd/0x30
[782948.191295]  [<c10ea0fa>] ? __dentry_open+0x11a/0x310
[782948.191295]  [<c12e7135>] ? devcgroup_inode_permission+0x115/0x150
[782948.191295]  [<c10ea3e1>] ? nameidata_to_filp+0x51/0x70
[782948.191295]  [<c10eef80>] ? chrdev_open+0x0/0x240
[782948.191295]  [<c10f8b2f>] ? do_filp_open+0x7ff/0xbc0
[782948.191295]  [<c112326b>] ? do_lock_file_wait+0x4b/0xd0
[782948.191295]  [<c16f610c>] ? _raw_spin_unlock+0xc/0x20
[782948.191295]  [<c1101e9d>] ? alloc_fd+0xbd/0x100
[782948.191295]  [<c10e9e48>] ? do_sys_open+0x58/0x130
[782948.191295]  [<c10e9f9c>] ? sys_open+0x2c/0x40
[782948.191295]  [<c1002c8c>] ? sysenter_do_call+0x12/0x22
[782948.191295] Code: 09 d0 c3 eb 0d 90 90 90 90 90 90 90 90 90 90 90 90 90 83 ec 24 89 74 24 1c 89 c6 89 5c 24 18 89 7c 24 20 8b 18 8b 43 08 8b 40 04 <0f> b6 78 02 a1 28 15 de fc 85 c0 75 75 8d 86 00 01 00 00 e8 0f 
[782948.191295] EIP: [<fcddd2f9>] option_send_setup+0x19/0xc0 [option] SS:ESP 0068:d403bd14
[782948.191295] CR2: 0000000067754140
[782948.191736] ---[ end trace c24b975bf52b5bd7 ]---

### EOF 
### vim:tw=256:et:sts=2:st=2:sw=2:com+=b\:###:fo+=cqtr:tags=ctags:


        Cheers,

              Nils

