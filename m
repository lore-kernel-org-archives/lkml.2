Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753426Ab0IXR0X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 13:26:23 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:26824 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751814Ab0IXR0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 13:26:21 -0400
Message-ID: <4C9CDEEF.4030304@kernel.org>
Date: Fri, 24 Sep 2010 10:25:03 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100714 SUSE/3.0.6 Thunderbird/3.0.6
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 2.6.32.y] ipmi: Fix hard-code path ipmi exit path panic
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Wing found panic on X4800, after he installed Sun own special version of ipmitool.

Removing ipmi drivers: BUG: unable to handle kernel NULL pointer dereference at 0000000000000030
IP: [<ffffffff8117485e>] sysfs_remove_file+0x9/0x17
PGD 46b467067 PUD 46c9e3067 PMD 0
Oops: 0000 [#1] SMP
last sysfs file: /sys/devices/system/cpu/cpu63/cache/index2/shared_cpu_map
CPU 33
Modules linked in: ipmi_si(-)(U) ipmi_msghandler(U) autofs4(U) hidp(U) rfcomm(U) l2cap(U) bluetooth(U) rfkill(U) lockd(U) sunrpc(U) cpufreq_ondemand(U) acpi_cpufreq(U) freq_table(U) ib_iser(U) rdma_cm(U) ib_cm(U) iw_cm(U) ib_sa(U) ib_mad(U) ib_core(U) ib_addr(U) iscsi_tcp(U) bnx2i(U) cnic(U) uio(U) ipv6(U) cxgb3i(U) cxgb3(U) mdio(U) libiscsi_tcp(U) libiscsi(U) scsi_transport_iscsi(U) video(U) output(U) sbs(U) sbshc(U) parport_pc(U) lp(U) parport(U) joydev(U) e1000e(U) igb(U) dca(U) snd_seq_dummy(U) snd_seq_oss(U) snd_seq_midi_event(U) snd_seq(U) snd_seq_device(U) snd_pcm_oss(U) snd_mixer_oss(U) snd_pcm(U) snd_timer(U) snd(U) soundcore(U) i2c_i801(U) snd_page_alloc(U) i2c_core(U) iTCO_wdt(U) iTCO_vendor_support(U) pcspkr(U) usb_storage(U) qla2xxx(U) lpfc(U) scsi_transport_fc(U) scsi_tgt(U) ahci(U) shpchp(U) megaraid_sas(U) uhci_hcd(U) ohci_hcd(U) ehci_hcd(U) [last unloaded: ipmi_devintf]
Pid: 10243, comm: rmmod Not tainted 2.6.32-100.0.15.el5.x86_64 #1 Sun Fire x4800
RIP: 0010:[<ffffffff8117485e>]  [<ffffffff8117485e>] sysfs_remove_file+0x9/0x17
RSP: 0018:ffff880c6ad85e88  EFLAGS: 00010286
RAX: ffffffffa022b5b8 RBX: ffffffffa022e6a0 RCX: 000000000000003f
RDX: 0000000000000000 RSI: ffffffff816bc2e0 RDI: 0000000000000000
RBP: ffff880c6ad85e88 R08: 0000000000000000 R09: ffffffff8172ce80
R10: ffff880c6d1323b8 R11: ffff880028334ec0 R12: ffffffffa022e708
R13: ffffffffa022e640 R14: 00007fffe925eba0 R15: 0000000000000880
FS:  00007f63d8e306e0(0000) GS:ffff880028320000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000030 CR3: 000000046cb93000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process rmmod (pid: 10243, threadinfo ffff880c6ad84000, task ffff880c6d132380)
Stack:
 ffff880c6ad85e98 ffffffff812e19b5 ffff880c6ad85ec8 ffffffff81246edd
<0> ffff880c6ad85eb8 0000000000000000 ffffffffa022e8c0 0000000000000880
<0> ffff880c6ad85ee8 ffffffffa022b5db ffffffffa022e8c0 0000000000000000
Call Trace:
 [<ffffffff812e19b5>] driver_remove_file+0x17/0x19
 [<ffffffff81246edd>] pci_unregister_driver+0x2f/0xa0
 [<ffffffffa022b5db>] cleanup_ipmi_si+0x23/0x88 [ipmi_si]
 [<ffffffff8108e64d>] sys_delete_module+0x1c3/0x244
 [<ffffffff810a7cfb>] ? audit_syscall_entry+0x103/0x12f
 [<ffffffff81011db2>] system_call_fastpath+0x16/0x1b
Code: 43 d0 48 b8 00 02 20 00 00 00 ad de 48 89 43 d8 e8 0e 35 2c 00 4c 89 e7 e8 25 68 f9 ff 5b 41 5c c9 c3 55 48 89 e5 0f 1f 44 00 00 <48> 8b 7f 30 48 8b 36 e8 c2 f2 ff ff c9 c3 55 48 89 e5 53 48 83
RIP  [<ffffffff8117485e>] sysfs_remove_file+0x9/0x17

it turns out:
Sun's specical ipmitool package will add 
options ipmi_si type="kcs" ports=0xCA2 regspacings="4"
in /etc/modprobe.conf

1. this is needed for 2.6.18 kernel,
   because it can not detect regspacing.
   but our new ast2100 sp based system are using 0xca2/0xca6 instead regular 0xca2/0xca3.
   So install program passing hardcoded value for driver

2. 2.6.32 etc and later can get regspacing from SMBIOS or SPMI.
   so it doesn't need that hard code passing.

3. 2.6.32 kernel module exit for ipmi_si have problem unload hard coded interface

need to check if ipmi_pci_driver is loaded or not.

BTW: mainline have another similar problem.... and need to add pnp_registered...

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

diff --git a/drivers/char/ipmi/ipmi_si_intf.c b/drivers/char/ipmi/ipmi_si_intf.c
index 3a6aa95..cbe1635 100644
--- a/drivers/char/ipmi/ipmi_si_intf.c
+++ b/drivers/char/ipmi/ipmi_si_intf.c
@@ -3401,7 +3401,8 @@ static __exit void cleanup_ipmi_si(void)
 		return;
 
 #ifdef CONFIG_PCI
-	pci_unregister_driver(&ipmi_pci_driver);
+	if (pci_registered)
+		pci_unregister_driver(&ipmi_pci_driver);
 #endif
 
 #ifdef CONFIG_PPC_OF
