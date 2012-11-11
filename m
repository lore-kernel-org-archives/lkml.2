Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751799Ab2KJNtm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2012 08:49:42 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:52137 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751562Ab2KJNte (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2012 08:49:34 -0500
From: Luming Yu <luming.yu@gmail.com>
To: arnd@arndb.de, linux-kernel@vger.kernel.org
Cc: Luming Yu <luming.yu@gmail.com>, Jon Masters <jonathan@jonmasters.org>,
        Jon Masters <jcm@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luming Yu <luming.yu@intel.com>
Subject: [PATCH update 3/3] fs: Fix crash caused by write to dummy debugfs interface like HW_latency exposed
Date: Sat, 10 Nov 2012 21:48:22 -0500
Message-Id: <1352602102-2390-4-git-send-email-luming.yu@gmail.com>
X-Mailer: git-send-email 1.7.12.1
In-Reply-To: <1352602102-2390-1-git-send-email-luming.yu@gmail.com>
References: <1352602102-2390-1-git-send-email-luming.yu@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[  141.311906] BUG: unable to handle kernel NULL pointer dereference at 0000000000000008
[  141.314071] IP: [<ffffffff811f8f3c>] simple_attr_write+0x2c/0x100
[  141.316195] PGD c3bd7067 PUD cb41d067 PMD 0
[  141.318287] Oops: 0000 [#1] SMP
[  141.320338] Modules linked in: hw_latency_test lockd sunrpc iptable_mangle nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack rfcomm bnep coretemp kvm arc4 iwldvm mac80211 snd_hda_codec_hdmi snd_hda_codec_realtek option usb_wwan snd_hda_intel snd_hda_codec btusb bluetooth snd_hwdep snd_seq snd_seq_device snd_pcm iwlwifi thinkpad_acpi cfg80211 snd_page_alloc snd_timer crc32c_intel snd e1000e tpm_tis ghash_clmulni_intel tpm tpm_bios soundcore iTCO_wdt rfkill joydev microcode i2c_i801 wmi iTCO_vendor_support mei lpc_ich mfd_core pcspkr uinput i915 usb_storage i2c_algo_bit uas drm_kms_helper sdhci_pci sdhci drm mmc_core i2c_core video
[  141.329446] CPU 2
[  141.329467] Pid: 804, comm: bash Not tainted 3.7.0-rc2+ #5 LENOVO 232045C/232045C
[  141.333922] RIP: 0010:[<ffffffff811f8f3c>]  [<ffffffff811f8f3c>] simple_attr_write+0x2c/0x100
[  141.336173] RSP: 0018:ffff8800cb6c3eb8  EFLAGS: 00010286
[  141.338377] RAX: ffffffff811f8f10 RBX: ffff8800c4549600 RCX: ffff8800cb6c3f50
[  141.340573] RDX: 0000000000000002 RSI: 00007fcbf9ef0000 RDI: ffff8800c4549600
[  141.342744] RBP: ffff8800cb6c3ef8 R08: 000000000000000a R09: 00007fcbf9edd740
[  141.344896] R10: 0000000000000001 R11: 0000000000000246 R12: 0000000000000002
[  141.347017] R13: 00007fcbf9ef0000 R14: ffff8800cb6c3f50 R15: 0000000000000000
[  141.349115] FS:  00007fcbf9edd740(0000) GS:ffff880119200000(0000) knlGS:0000000000000000
[  141.351209] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  141.353314] CR2: 0000000000000008 CR3: 00000000c696c000 CR4: 00000000001407e0
[  141.355457] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  141.357590] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  141.359685] Process bash (pid: 804, threadinfo ffff8800cb6c2000, task ffff8800cb7ccd20)
[  141.361767] Stack:
[  141.363793]  ffff8800c4549600 00007fcbf9ef0000 ffff8800cb6c3ef8 ffff8800c4549600
[  141.365864]  0000000000000002 00007fcbf9ef0000 ffff8800cb6c3f50 0000000000000000
[  141.367905]  ffff8800cb6c3f28 ffffffff811cf27f ffff8800c4549600 00007fcbf9ef0000
[  141.369924] Call Trace:
[  141.371882]  [<ffffffff811cf27f>] vfs_write+0xaf/0x190
[  141.373827]  [<ffffffff811cf5d5>] sys_write+0x55/0xa0
[  141.375745]  [<ffffffff816f0199>] system_call_fastpath+0x16/0x1b
[  141.377661] Code: 1f 44 00 00 55 48 89 e5 48 83 ec 40 48 89 5d d8 4c 89 65 e0 4c 89 6d e8 4c 89 75 f0 4c 89 7d f8 4c 8b bf 28 01 00 00 48 89 75 c8 <49> 83 7f 08 00 0f 84 b1 00 00 00 4d 8d 67 50 31 f6 49 89 d5 4c
[  141.382206] RIP  [<ffffffff811f8f3c>] simple_attr_write+0x2c/0x100
[  141.384326]  RSP <ffff8800cb6c3eb8>
[  141.386401] CR2: 0000000000000008
[  141.388548] ---[ end trace 9c28eee46fcb7871 ]---

Signed-off-by: Luming Yu <luming.yu@intel.com>
---
 fs/libfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/libfs.c b/fs/libfs.c
index 7cc37ca..bc51574 100644
--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -819,7 +819,7 @@ ssize_t simple_attr_write(struct file *file, const char __user *buf,
 	ssize_t ret;
 
 	attr = file->private_data;
-	if (!attr->set)
+	if (!attr || !attr->set)
 		return -EACCES;
 
 	ret = mutex_lock_interruptible(&attr->mutex);
-- 
1.7.12.1

