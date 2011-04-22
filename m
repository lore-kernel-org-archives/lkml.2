Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756173Ab1DVS4n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 14:56:43 -0400
Received: from smtp-out3.tiscali.nl ([195.241.79.178]:53047 "EHLO
	smtp-out3.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756039Ab1DVS4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 14:56:41 -0400
Subject: [IWL4965] TX Power requested while scanning!
From: Paul Bolle <pebolle@tiscali.nl>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 22 Apr 2011 20:56:22 +0200
Message-ID: <1303498582.2103.15.camel@x61.thuisdomein>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

0) Running v2.6.39-rc4 I ran into this (after a resume):

WARNING: at drivers/net/wireless/iwlegacy/iwl-4965.c:1128 iwl4965_send_tx_power+0x61/0x102 [iwl4965]()
Hardware name: [...]
TX Power requested while scanning!
Modules linked in: tcp_lp fuse cpufreq_ondemand acpi_cpufreq freq_table mperf ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tables ipv6 kvm_intel kvm uinput btusb arc4 snd_hda_codec_analog bluetooth ecb snd_hda_intel snd_hda_codec iwl4965 snd_hwdep snd_seq iwl_legacy snd_seq_device thinkpad_acpi mac80211 cfg80211 rfkill snd_pcm snd_timer iTCO_wdt snd i2c_i801 snd_page_alloc iTCO_vendor_support soundcore e1000e pcspkr microcode sdhci_pci sdhci firewire_ohci mmc_core firewire_core yenta_socket crc_itu_t i915 drm_kms_helper drm i2c_algo_bit i2c_core video [last unloaded: scsi_wait_scan]
Pid: 5723, comm: kworker/u:28 Not tainted 2.6.39-0.rc4.4.fc14.x86_64 #1
Call Trace:
 [<ffffffff8104e27b>] warn_slowpath_common+0x85/0x9d
 [<ffffffffa02782e0>] ? iwl4965_show_temperature+0x49/0x49 [iwl4965]
 [<ffffffff8104e336>] warn_slowpath_fmt+0x46/0x48
 [<ffffffffa027712f>] iwl4965_send_tx_power+0x61/0x102 [iwl4965]
 [<ffffffff81477e05>] ? mutex_lock+0x36/0x50
 [<ffffffffa0278337>] iwl4965_bg_txpower_work+0x57/0x73 [iwl4965]
 [<ffffffff810647f3>] process_one_work+0x18d/0x286
 [<ffffffff81065a5e>] worker_thread+0xfd/0x181
 [<ffffffff81065961>] ? manage_workers.clone.16+0x172/0x172
 [<ffffffff81069036>] kthread+0x82/0x8a
 [<ffffffff81480524>] kernel_thread_helper+0x4/0x10
 [<ffffffff81068fb4>] ? kthread_worker_fn+0x14b/0x14b
 [<ffffffff81480520>] ? gs_change+0x13/0x13

(2.6.39-0.rc4.4.fc14.x86_64 is not a Fedora blessed kernel, but a self
compiled "vanilla" kernel.) I have similar WARNINGs for rc2 and rc3 in
my log too.

1) The thing is that this triggers Fedora's "Automatic Bug Reporting
Tool", and is a bit noisy in dmesg and friends too, but everything seems
to be running just fine after that. I'm posting this from the session
that just triggered this! So why is this warning needed?


Paul Bolle

