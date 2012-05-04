Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757374Ab2EDBtt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 21:49:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33170 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755532Ab2EDBts (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 21:49:48 -0400
Message-ID: <4FA33520.6080507@redhat.com>
Date: Fri, 04 May 2012 09:47:12 +0800
From: Dave Young <dyoung@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.22) Gecko/20110904 Red Hat/3.1.14-1.el6_1 Thunderbird/3.1.14
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org, johannes.berg@intel.com,
        wey-yi.w.guy@intel.com, ilw@linux.intel.com
CC: lkml <linux-kernel@vger.kernel.org>
Subject: iwlwifi warning (3.4.0-rc5+)
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Annoying warnings as below in dmesg, known issue?

[   71.852336] wlan0: authentication with 00:1c:f6:62:f3:03 timed out
[   71.856985] iwlwifi 0000:03:00.0: ACTIVATE a non DRIVER active
station id 0 addr 00:1c:f6:62:f3:03
[   71.857014] ------------[ cut here ]------------
[   71.857035] WARNING: at
drivers/net/wireless/iwlwifi/iwl-agn-sta.c:809
iwl_send_lq_cmd+0xa1/0x115 [iwlwifi]()
[   71.857039] Hardware name: 4236NUC
[   71.857041] Modules linked in: fuse rfcomm bnep sunrpc vhost_net
macvtap macvlan tun kvm_intel kvm uvcvideo videobuf2_core videodev media
videobuf2_vmalloc videobuf2_memops btusb bluetooth pcspkr iwlwifi
mac80211 cfg80211 e1000e wmi thinkpad_acpi rfkill firewire_ohci
firewire_core crc_itu_t sdhci_pci [last unloaded: scsi_wait_scan]
[   71.857084] Pid: 939, comm: kworker/u:5 Not tainted 3.4.0-rc5+ #277
[   71.857087] Call Trace:
[   71.857096]  [<ffffffff81031eed>] warn_slowpath_common+0x80/0x98
[   71.857101]  [<ffffffff81031f1a>] warn_slowpath_null+0x15/0x17
[   71.857111]  [<ffffffffa013d817>] iwl_send_lq_cmd+0xa1/0x115 [iwlwifi]
[   71.857121]  [<ffffffffa013e380>] iwl_restore_stations+0x1b3/0x203
[iwlwifi]
[   71.857132]  [<ffffffffa01447d1>] iwlagn_commit_rxon+0x41a/0x604
[iwlwifi]
[   71.857141]  [<ffffffffa0144d67>] iwlagn_bss_info_changed+0x31c/0x50f
[iwlwifi]
[   71.857148]  [<ffffffff815e51f1>] ? __mutex_unlock_slowpath+0x111/0x124
[   71.857164]  [<ffffffffa00bfcef>] ?
ieee80211_teardown_sdata+0xd6/0xd6 [mac80211]
[   71.857171]  [<ffffffff81078a35>] ? trace_hardirqs_on+0xd/0xf
[   71.857181]  [<ffffffffa00b43b3>]
ieee80211_bss_info_change_notify+0x195/0x1cb [mac80211]
[   71.857194]  [<ffffffffa00bfcef>] ?
ieee80211_teardown_sdata+0xd6/0xd6 [mac80211]
[   71.857210]  [<ffffffffa00defda>]
ieee80211_destroy_auth_data+0x7a/0x9e [mac80211]
[   71.857226]  [<ffffffffa00e3508>] ieee80211_sta_work+0xbb/0x9a8
[mac80211]
[   71.857231]  [<ffffffff815e758e>] ? _raw_spin_unlock_irqrestore+0x42/0x51
[   71.857243]  [<ffffffffa00bfcef>] ?
ieee80211_teardown_sdata+0xd6/0xd6 [mac80211]
[   71.857248]  [<ffffffff81078a35>] ? trace_hardirqs_on+0xd/0xf
[   71.857260]  [<ffffffffa00bfcef>] ?
ieee80211_teardown_sdata+0xd6/0xd6 [mac80211]
[   71.857271]  [<ffffffffa00bff80>] ieee80211_iface_work+0x291/0x2aa
[mac80211]
[   71.857283]  [<ffffffffa00bfcef>] ?
ieee80211_teardown_sdata+0xd6/0xd6 [mac80211]
[   71.857288]  [<ffffffff81049f4b>] process_one_work+0x22b/0x393
[   71.857293]  [<ffffffff81049ebc>] ? process_one_work+0x19c/0x393
[   71.857298]  [<ffffffff8129eebb>] ? do_raw_spin_lock+0x69/0xea
[   71.857304]  [<ffffffff8104a1e9>] worker_thread+0x136/0x255
[   71.857309]  [<ffffffff8104a0b3>] ? process_one_work+0x393/0x393
[   71.857314]  [<ffffffff81050a2c>] kthread+0x9f/0xa7
[   71.857319]  [<ffffffff815ef474>] kernel_thread_helper+0x4/0x10
[   71.857324]  [<ffffffff815e7870>] ? retint_restore_args+0x13/0x13
[   71.857329]  [<ffffffff8105098d>] ? __init_kthread_worker+0x56/0x56
[   71.857334]  [<ffffffff815ef470>] ? gs_change+0x13/0x13
[   71.857337] ---[ end trace d7bea907d4ff9b83 ]---
-- 
Thanks
Dave
