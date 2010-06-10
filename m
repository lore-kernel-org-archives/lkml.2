Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759109Ab0FJOnp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 10:43:45 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:51826 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752048Ab0FJOnm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 10:43:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=GP2tuXwdaya2c22hJoY1ppdYFuXpy8ggIrbwg4epBUpvT1bPOElg66YQhfALmEH3z3
         WeJhjDLACzbXuVaa6+I2+KPQz9GUPqXJx+vqc5BbwfXR/hnLSeZg/7kfFBPSTOxIhy4Y
         kK+RzXxGwXP1IBEGk6CQq7vWmOsDPyrnRvNo8=
MIME-Version: 1.0
Date: Thu, 10 Jun 2010 16:43:40 +0200
Message-ID: <AANLkTilu9_B8M_rcO7p1cUdZF1Hs99B6tpcMoETFrdgA@mail.gmail.com>
Subject: Ooops in iwl3945_bg_request_scan
From: Zdenek Kabelac <zdenek.kabelac@gmail.com>
To: ilw@linux.intel.com
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi


When I've switched  wifi killswitch on - to enable wireless - I've got
following oops:

NetworkManager: <info> WiFi now enabled by radio killswitch
NetworkManager: <info> (wlan0): bringing up device.
ADDRCONF(NETDEV_UP): wlan0: link is not ready
BUG: unable to handle kernel NULL pointer dereference at 0000000000000020
IP: [<ffffffffa029d90d>] iwl3945_bg_request_scan+0x56d/0xf00 [iwl3945]
PGD 11f3c2067 PUD 127c1c067 PMD 0
Oops: 0000 [#1] PREEMPT SMP
last sysfs file: /sys/devices/platform/dock.0/flags
CPU 0
Modules linked in: dm_repl_slink_blockdev dm_repl_log_ringbuffer
dm_replicator dm_registry reiserfs usb_storage dm_snapshot
sysprof_module nfs aes_generic hidp rfcomm sco l2cap tun nfsd lockd
nfs_acl auth_rpcgss exportfs ip6_tables xt_tcpudp bridge stp llc
autofs4 sunrpc ipv6 ipt_REJECT xt_physdev xt_state iptable_filter
ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack
nf_defrag_ipv4 ip_tables x_tables binfmt_misc loop dm_mirror
dm_region_hash dm_log dm_mod kvm_intel kvm i915 drm_kms_helper drm
i2c_algo_bit uinput arc4 ecb snd_hda_codec_analog cryptomgr
crypto_hash aead pcompress crypto_blkcipher crypto_algapi
snd_hda_intel iwl3945 snd_hda_codec iwlcore mac80211 sdhci_pci snd_seq
thinkpad_acpi sdhci btusb rtc_cmos snd_seq_device snd_pcm mmc_core
rtc_core battery iTCO_wdt bluetooth led_class nvram snd_timer cfg80211
psmouse snd iTCO_vendor_support rtc_lib ac i2c_i801 rfkill soundcore
i2c_core serio_raw snd_page_alloc evdev e1000e usbhid hid sr_mod cdr
kernel: om uhci_hcd ehci_hcd usbcore video backlight output button
[last unloaded: scsi_wait_scan]

Pid: 1692, comm: iwl3945 Tainted: G        W  2.6.34-00002-g75254f6
#70 6464CTO/6464CTO
RIP: 0010:[<ffffffffa029d90d>]  [<ffffffffa029d90d>]
iwl3945_bg_request_scan+0x56d/0xf00 [iwl3945]
RSP: 0018:ffff880139b2fcc0  EFLAGS: 00010246
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff8801340a1cd8
RBP: ffff880139b2fdb0 R08: 0000000000000000 R09: 0000000000000001
R10: 0000000000000000 R11: 0000000000000000 R12: ffff88013a2a1d20
R13: ffff88013a2a2830 R14: 0000000000000000 R15: ffff8801340a1800
FS:  0000000000000000(0000) GS:ffff880002600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000020 CR3: 0000000127c86000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process iwl3945 (pid: 1692, threadinfo ffff880139b2e000, task ffff88013b232320)
Stack:
 ffff880139b2fd40 0000000000000046 0000000000000000 ffffffff810cffb0
<0> 0000000000000000 ffff88013b232320 ffffffff81432b85 0000000000000046
<0> 00000000001cffe0 0000000000000002 0000000000000000 0000000000000000
Call Trace:
 [<ffffffff810cffb0>] ? probe_workqueue_execution+0x40/0xa0
 [<ffffffff81432b85>] ? _raw_spin_lock_irqsave+0x25/0x90
 [<ffffffff810683a1>] ? worker_thread+0x1d1/0x460
 [<ffffffffa029d3a0>] ? iwl3945_bg_request_scan+0x0/0xf00 [iwl3945]
 [<ffffffff810683f2>] worker_thread+0x222/0x460
 [<ffffffff810683a1>] ? worker_thread+0x1d1/0x460
 [<ffffffff8106db80>] ? autoremove_wake_function+0x0/0x40
 [<ffffffff810681d0>] ? worker_thread+0x0/0x460
 [<ffffffff8106d596>] kthread+0x96/0xa0
 [<ffffffff81003f14>] kernel_thread_helper+0x4/0x10
 [<ffffffff8103910e>] ? finish_task_switch+0x6e/0xf0
 [<ffffffff8143341b>] ? _raw_spin_unlock_irq+0x3b/0x60
 [<ffffffff81433bc0>] ? restore_args+0x0/0x30
 [<ffffffff8106d500>] ? kthread+0x0/0xa0
 [<ffffffff81003f10>] ? kernel_thread_helper+0x0/0x10
Code: 66 0f 1f 44 00 00 41 ff c6 49 8b 84 24 40 0a 00 00 44 39 70 08
0f 8e 89 05 00 00 49 63 d6 48 8b 00 48 89 d6 48 c1 e6 05 48 01 d6 <80>
7c 30 20 00 74 d4 48 63 c3 ff c3 48 89 c2 48 c1 e2 05 48 8d
RIP  [<ffffffffa029d90d>] iwl3945_bg_request_scan+0x56d/0xf00 [iwl3945]
 RSP <ffff880139b2fcc0>
CR2: 0000000000000020
---[ end trace 3feb2c894fdf394c ]---


My machine is T61, 4GB C2D, using vanilla 2.6.34 released kernel with
15 days uptime.
Maybe it's the fault of tracing enabled in my kernel ?

Zdenek
