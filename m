Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761329Ab0HFNAx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 09:00:53 -0400
Received: from www17.your-server.de ([213.133.104.17]:54482 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756740Ab0HFNAt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 09:00:49 -0400
From: Thomas Meyer <thomas@m3y3r.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: 2.6.35-03797-gfc1caf6: WARNING at iwl_free_tfds_in_queue+ iwlagn_txq_check_empty
Date: Fri, 6 Aug 2010 14:59:34 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35-03797-gfc1caf6; KDE/4.4.5; i686; ; )
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201008061459.34530.thomas@m3y3r.de>
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

with 2.6.35-03797-gfc1caf6 my kernel log seems to consists only of these two WARNINGs:

[ 3032.962431] ------------[ cut here ]------------
[ 3032.962448] WARNING: at drivers/net/wireless/iwlwifi/iwl-agn-tx.c:1120 iwlagn_txq_check_empty+0x44/0x230 [iwlagn]()
[ 3032.962453] Hardware name: Aspire 1810T
[ 3032.962457] Modules linked in: tcp_lp fuse cpufreq_stats cpufreq_ondemand acpi_cpufreq mperf ip6t_REJECT nf_conntrack_ipv6 ip6table_filter ip6_tables ipv6 sha256_generic aes_i586 aes_generic cbc dm_crypt kvm_intel kvm uinput arc4 ecb snd_hda_codec_intelhdmi iwlagn iwlcore snd_hda_codec_realtek snd_hda_intel snd_hda_codec mac80211 snd_hwdep snd_seq snd_seq_device cfg80211 snd_pcm iTCO_wdt snd_timer uvcvideo videodev v4l1_compat wmi rfkill iTCO_vendor_support serio_raw snd pcspkr joydev i2c_i801 soundcore snd_page_alloc [last unloaded: scsi_wait_scan]
[ 3032.962524] Pid: 2775, comm: queue20:src Tainted: G        W I 2.6.35-03797-gfc1caf6 #133
[ 3032.962529] Call Trace:
[ 3032.962537]  [<c042bd88>] ? warn_slowpath_common+0x78/0xb0
[ 3032.962554]  [<f91484e4>] ? iwlagn_txq_check_empty+0x44/0x230 [iwlagn]
[ 3032.962569]  [<f91484e4>] ? iwlagn_txq_check_empty+0x44/0x230 [iwlagn]
[ 3032.962577]  [<c042bddb>] ? warn_slowpath_null+0x1b/0x20
[ 3032.962593]  [<f91484e4>] ? iwlagn_txq_check_empty+0x44/0x230 [iwlagn]
[ 3032.962601]  [<c042bddb>] ? warn_slowpath_null+0x1b/0x20
[ 3032.962618]  [<f914d7ac>] ? iwl_free_tfds_in_queue+0x2c/0xf0 [iwlagn]
[ 3032.962625]  [<c0425d7b>] ? check_preempt_wakeup+0xeb/0x170
[ 3032.962641]  [<f914f5a8>] ? iwlagn_rx_reply_tx+0x198/0xb60 [iwlagn]
[ 3032.962656]  [<f913519d>] ? iwl_rx_handle+0xfd/0x4a0 [iwlagn]
[ 3032.962664]  [<c06f4ae7>] ? scsi_run_queue+0xc7/0x200
[ 3032.962670]  [<c06ef929>] ? __scsi_put_command+0x29/0x60
[ 3032.962677]  [<c06ef929>] ? __scsi_put_command+0x29/0x60
[ 3032.962685]  [<c06f5840>] ? scsi_next_command+0x30/0x50
[ 3032.962699]  [<f913a824>] ? iwl_irq_tasklet+0x2a4/0xd60 [iwlagn]
[ 3032.962706]  [<c043091f>] ? tasklet_action+0x5f/0x70
[ 3032.962712]  [<c0430c7f>] ? __do_softirq+0x6f/0xf0
[ 3032.962718]  [<c047766d>] ? handle_IRQ_event+0x2d/0xc0
[ 3032.962725]  [<c0430d2d>] ? do_softirq+0x2d/0x40
[ 3032.962731]  [<c0430e4d>] ? irq_exit+0x5d/0x70
[ 3032.962737]  [<c0403e53>] ? do_IRQ+0x43/0xb0
[ 3032.962744]  [<c04032b0>] ? common_interrupt+0x30/0x38
[ 3032.962751]  [<c0840000>] ? netlbl_cipsov4_add+0x5b0/0x610
[ 3032.962756] ---[ end trace a7919e7f17c15a58 ]---
[ 3033.171146] ------------[ cut here ]------------
[ 3033.171168] WARNING: at drivers/net/wireless/iwlwifi/iwl-agn-lib.c:1432 iwl_free_tfds_in_queue+0x2c/0xf0 [iwlagn]()
[ 3033.171171] Hardware name: Aspire 1810T
[ 3033.171173] Modules linked in: tcp_lp fuse cpufreq_stats cpufreq_ondemand acpi_cpufreq mperf ip6t_REJECT nf_conntrack_ipv6 ip6table_filter ip6_tables ipv6 sha256_generic aes_i586 aes_generic cbc dm_crypt kvm_intel kvm uinput arc4 ecb snd_hda_codec_intelhdmi iwlagn iwlcore snd_hda_codec_realtek snd_hda_intel snd_hda_codec mac80211 snd_hwdep snd_seq snd_seq_device cfg80211 snd_pcm iTCO_wdt snd_timer uvcvideo videodev v4l1_compat wmi rfkill iTCO_vendor_support serio_raw snd pcspkr joydev i2c_i801 soundcore snd_page_alloc [last unloaded: scsi_wait_scan]
[ 3033.171213] Pid: 2775, comm: queue20:src Tainted: G        W I 2.6.35-03797-gfc1caf6 #133
[ 3033.171216] Call Trace:
[ 3033.171226]  [<c042bd88>] ? warn_slowpath_common+0x78/0xb0
[ 3033.171236]  [<f914d7ac>] ? iwl_free_tfds_in_queue+0x2c/0xf0 [iwlagn]
[ 3033.171245]  [<f914d7ac>] ? iwl_free_tfds_in_queue+0x2c/0xf0 [iwlagn]
[ 3033.171250]  [<c042bddb>] ? warn_slowpath_null+0x1b/0x20
[ 3033.171260]  [<f914d7ac>] ? iwl_free_tfds_in_queue+0x2c/0xf0 [iwlagn]
[ 3033.171264]  [<c0425d7b>] ? check_preempt_wakeup+0xeb/0x170
[ 3033.171274]  [<f914f588>] ? iwlagn_rx_reply_tx+0x178/0xb60 [iwlagn]
[ 3033.171282]  [<f913519d>] ? iwl_rx_handle+0xfd/0x4a0 [iwlagn]
[ 3033.171288]  [<c06f4ae7>] ? scsi_run_queue+0xc7/0x200
[ 3033.171292]  [<c06ef929>] ? __scsi_put_command+0x29/0x60
[ 3033.171296]  [<c06ef929>] ? __scsi_put_command+0x29/0x60
[ 3033.171300]  [<c06f5840>] ? scsi_next_command+0x30/0x50
[ 3033.171309]  [<f913a824>] ? iwl_irq_tasklet+0x2a4/0xd60 [iwlagn]
[ 3033.171313]  [<c043091f>] ? tasklet_action+0x5f/0x70
[ 3033.171317]  [<c0430c7f>] ? __do_softirq+0x6f/0xf0
[ 3033.171321]  [<c047766d>] ? handle_IRQ_event+0x2d/0xc0
[ 3033.171325]  [<c0430d2d>] ? do_softirq+0x2d/0x40
[ 3033.171328]  [<c0430e4d>] ? irq_exit+0x5d/0x70
[ 3033.171333]  [<c0403e53>] ? do_IRQ+0x43/0xb0
[ 3033.171336]  [<c04032b0>] ? common_interrupt+0x30/0x38
[ 3033.171342]  [<c0840000>] ? netlbl_cipsov4_add+0x5b0/0x610
[ 3033.171345] ---[ end trace a7919e7f17c15a59 ]---
[ 3033.171348] ------------[ cut here ]------------
[ 3033.171358] WARNING: at drivers/net/wireless/iwlwifi/iwl-agn-tx.c:1120 iwlagn_txq_check_empty+0x44/0x230 [iwlagn]()
[ 3033.171362] Hardware name: Aspire 1810T
[ 3033.171363] Modules linked in: tcp_lp fuse cpufreq_stats cpufreq_ondemand acpi_cpufreq mperf ip6t_REJECT nf_conntrack_ipv6 ip6table_filter ip6_tables ipv6 sha256_generic aes_i586 aes_generic cbc dm_crypt kvm_intel kvm uinput arc4 ecb snd_hda_codec_intelhdmi iwlagn iwlcore snd_hda_codec_realtek snd_hda_intel snd_hda_codec mac80211 snd_hwdep snd_seq snd_seq_device cfg80211 snd_pcm iTCO_wdt snd_timer uvcvideo videodev v4l1_compat wmi rfkill iTCO_vendor_support serio_raw snd pcspkr joydev i2c_i801 soundcore snd_page_alloc [last unloaded: scsi_wait_scan]
[ 3033.171400] Pid: 2775, comm: queue20:src Tainted: G        W I 2.6.35-03797-gfc1caf6 #133
[ 3033.171402] Call Trace:
[ 3033.171407]  [<c042bd88>] ? warn_slowpath_common+0x78/0xb0
[ 3033.171416]  [<f91484e4>] ? iwlagn_txq_check_empty+0x44/0x230 [iwlagn]
[ 3033.171425]  [<f91484e4>] ? iwlagn_txq_check_empty+0x44/0x230 [iwlagn]
[ 3033.171430]  [<c042bddb>] ? warn_slowpath_null+0x1b/0x20
[ 3033.171439]  [<f91484e4>] ? iwlagn_txq_check_empty+0x44/0x230 [iwlagn]
[ 3033.171444]  [<c042bddb>] ? warn_slowpath_null+0x1b/0x20
[ 3033.171453]  [<f914d7ac>] ? iwl_free_tfds_in_queue+0x2c/0xf0 [iwlagn]
[ 3033.171457]  [<c0425d7b>] ? check_preempt_wakeup+0xeb/0x170
[ 3033.171468]  [<f914f5a8>] ? iwlagn_rx_reply_tx+0x198/0xb60 [iwlagn]
[ 3033.171476]  [<f913519d>] ? iwl_rx_handle+0xfd/0x4a0 [iwlagn]
[ 3033.171480]  [<c06f4ae7>] ? scsi_run_queue+0xc7/0x200
[ 3033.171484]  [<c06ef929>] ? __scsi_put_command+0x29/0x60
[ 3033.171488]  [<c06ef929>] ? __scsi_put_command+0x29/0x60
[ 3033.171493]  [<c06f5840>] ? scsi_next_command+0x30/0x50
[ 3033.171500]  [<f913a824>] ? iwl_irq_tasklet+0x2a4/0xd60 [iwlagn]
[ 3033.171505]  [<c043091f>] ? tasklet_action+0x5f/0x70
[ 3033.171508]  [<c0430c7f>] ? __do_softirq+0x6f/0xf0
[ 3033.171512]  [<c047766d>] ? handle_IRQ_event+0x2d/0xc0
[ 3033.171515]  [<c0430d2d>] ? do_softirq+0x2d/0x40
[ 3033.171519]  [<c0430e4d>] ? irq_exit+0x5d/0x70
[ 3033.171522]  [<c0403e53>] ? do_IRQ+0x43/0xb0
[ 3033.171526]  [<c04032b0>] ? common_interrupt+0x30/0x38
[ 3033.171531]  [<c0840000>] ? netlbl_cipsov4_add+0x5b0/0x610
[ 3033.171533] ---[ end trace a7919e7f17c15a5a ]---
[ 3033.201691] ------------[ cut here ]------------
[ 3033.201727] WARNING: at drivers/net/wireless/iwlwifi/iwl-agn-lib.c:1432 iwl_free_tfds_in_queue+0x2c/0xf0 [iwlagn]()
[ 3033.201733] Hardware name: Aspire 1810T
[ 3033.201737] Modules linked in: tcp_lp fuse cpufreq_stats cpufreq_ondemand acpi_cpufreq mperf ip6t_REJECT nf_conntrack_ipv6 ip6table_filter ip6_tables ipv6 sha256_generic aes_i586 aes_generic cbc dm_crypt kvm_intel kvm uinput arc4 ecb snd_hda_codec_intelhdmi iwlagn iwlcore snd_hda_codec_realtek snd_hda_intel snd_hda_codec mac80211 snd_hwdep snd_seq snd_seq_device cfg80211 snd_pcm iTCO_wdt snd_timer uvcvideo videodev v4l1_compat wmi rfkill iTCO_vendor_support serio_raw snd pcspkr joydev i2c_i801 soundcore snd_page_alloc [last unloaded: scsi_wait_scan]
[ 3033.201806] Pid: 1358, comm: abrtd Tainted: G        W I 2.6.35-03797-gfc1caf6 #133
[ 3033.201811] Call Trace:
[ 3033.201831]  [<c042bd88>] ? warn_slowpath_common+0x78/0xb0
[ 3033.201849]  [<f914d7ac>] ? iwl_free_tfds_in_queue+0x2c/0xf0 [iwlagn]
[ 3033.201865]  [<f914d7ac>] ? iwl_free_tfds_in_queue+0x2c/0xf0 [iwlagn]
[ 3033.201873]  [<c042bddb>] ? warn_slowpath_null+0x1b/0x20
[ 3033.201891]  [<f914d7ac>] ? iwl_free_tfds_in_queue+0x2c/0xf0 [iwlagn]
[ 3033.201908]  [<f914f588>] ? iwlagn_rx_reply_tx+0x178/0xb60 [iwlagn]
[ 3033.201919]  [<c084d780>] ? do_page_fault+0x0/0x3e0
[ 3033.201926]  [<c084d927>] ? do_page_fault+0x1a7/0x3e0
[ 3033.201936]  [<c05c0544>] ? avc_has_perm+0x64/0x80
[ 3033.201950]  [<f913519d>] ? iwl_rx_handle+0xfd/0x4a0 [iwlagn]
[ 3033.201958]  [<c084d780>] ? do_page_fault+0x0/0x3e0
[ 3033.201966]  [<c084b2a3>] ? error_code+0x6b/0x70
[ 3033.201980]  [<f913a824>] ? iwl_irq_tasklet+0x2a4/0xd60 [iwlagn]
[ 3033.201990]  [<c048a541>] ? generic_file_aio_read+0x5d1/0x710
[ 3033.201998]  [<c043091f>] ? tasklet_action+0x5f/0x70
[ 3033.202005]  [<c0430c7f>] ? __do_softirq+0x6f/0xf0
[ 3033.202012]  [<c047766d>] ? handle_IRQ_event+0x2d/0xc0
[ 3033.202019]  [<c0430d2d>] ? do_softirq+0x2d/0x40
[ 3033.202025]  [<c0430e4d>] ? irq_exit+0x5d/0x70
[ 3033.202037]  [<c0403e53>] ? do_IRQ+0x43/0xb0
[ 3033.202045]  [<c049c8d5>] ? unmap_vmas+0x455/0x650
[ 3033.202052]  [<c04032b0>] ? common_interrupt+0x30/0x38
[ 3033.202060]  [<c049007b>] ? account_page_dirtied+0x1b/0x60
[ 3033.202068]  [<c04b58f7>] ? kmem_cache_alloc+0x17/0xa0
[ 3033.202075]  [<c04a1504>] ? unmap_region+0xc4/0x120
[ 3033.202083]  [<c04c6a88>] ? getname+0x28/0xe0
[ 3033.202091]  [<c04bcc2e>] ? do_sys_open+0x1e/0x160
[ 3033.202099]  [<c046c6e6>] ? audit_syscall_entry+0x1a6/0x1d0
[ 3033.202106]  [<c04bcdec>] ? sys_open+0x2c/0x40
[ 3033.202113]  [<c0402d53>] ? sysenter_do_call+0x12/0x22
[ 3033.202119] ---[ end trace a7919e7f17c15a5b ]---

and so on...
