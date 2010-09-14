Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753802Ab0INOec (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 10:34:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64791 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751327Ab0INOea (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 10:34:30 -0400
Date: Tue, 14 Sep 2010 16:28:15 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Reinette Chatre <reinette.chatre@intel.com>,
        Wey-Yi Guy <wey-yi.w.guy@intel.com>,
        Intel Linux Wireless <ilw@linux.intel.com>
Subject: 2.6.36-rc4/iwl: warning triggered in net/mac80211/scan.c:266
Message-ID: <20100914142814.GA8744@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am running 2.6.36-rc4 on T60 with an iwlagn wireless card:
03:00.0 Network controller: Intel Corporation PRO/Wireless 5100 AGN [Shiloh] Network Connection

I was compiling a large file which stressed the box heavily, and the
following warning in net/mac80211/scan.c triggered:

        /*
         * It's ok to abort a not-yet-running scan (that
         * we have one at all will be verified by checking
         * local->scan_req next), but not to complete it
         * successfully.
         */
        if (WARN_ON(!local->scanning && !aborted))
                aborted = true;

dmesg below:

[84379.361297] ------------[ cut here ]------------
[84379.361307] WARNING: at net/mac80211/scan.c:266 ieee80211_scan_completed+0x43/0x17f()
[84379.361311] Hardware name: 2241B48
[84379.361313] Modules linked in: tun iwlagn kvm_intel kvm iwlcore e1000e thinkpad_acpi [last unloaded: scsi_wait_scan]
[84379.361325] Pid: 8254, comm: kworker/u:0 Not tainted 2.6.36-rc4-mst #96
[84379.361328] Call Trace:
[84379.361334]  [<ffffffff815d1399>] ? ieee80211_scan_completed+0x43/0x17f
[84379.361340]  [<ffffffff81042046>] warn_slowpath_common+0x80/0x99
[84379.361354]  [<ffffffffa005d8e7>] ? iwl_generic_cmd_callback+0x0/0xe4 [iwlcore]
[84379.361359]  [<ffffffff81042074>] warn_slowpath_null+0x15/0x17
[84379.361363]  [<ffffffff815d1399>] ieee80211_scan_completed+0x43/0x17f
[84379.361374]  [<ffffffffa0065212>] iwl_bg_scan_completed+0x1ce/0x1d7 [iwlcore]
[84379.361380]  [<ffffffff81057153>] process_one_work+0x1e2/0x301
[84379.361391]  [<ffffffffa0065044>] ? iwl_bg_scan_completed+0x0/0x1d7 [iwlcore]
[84379.361395]  [<ffffffff8105752c>] worker_thread+0x130/0x243
[84379.361400]  [<ffffffff810573fc>] ? worker_thread+0x0/0x243
[84379.361404]  [<ffffffff8105bc1b>] kthread+0x81/0x89
[84379.361409]  [<ffffffff81003914>] kernel_thread_helper+0x4/0x10
[84379.361413]  [<ffffffff8105bb9a>] ? kthread+0x0/0x89
[84379.361417]  [<ffffffff81003910>] ? kernel_thread_helper+0x0/0x10
[84379.361420] ---[ end trace c5ebbd902daa4ea8 ]---
[84379.361422] ------------[ cut here ]------------
[84379.361426] WARNING: at net/mac80211/scan.c:269 ieee80211_scan_completed+0x62/0x17f()
[84379.361429] Hardware name: 2241B48
[84379.361431] Modules linked in: tun iwlagn kvm_intel kvm iwlcore e1000e thinkpad_acpi [last unloaded: scsi_wait_scan]
[84379.361441] Pid: 8254, comm: kworker/u:0 Tainted: G        W   2.6.36-rc4-mst #96
[84379.361461] Call Trace:
[84379.361464]  [<ffffffff815d13b8>] ? ieee80211_scan_completed+0x62/0x17f
[84379.361469]  [<ffffffff81042046>] warn_slowpath_common+0x80/0x99
[84379.361479]  [<ffffffffa005d8e7>] ? iwl_generic_cmd_callback+0x0/0xe4 [iwlcore]
[84379.361484]  [<ffffffff81042074>] warn_slowpath_null+0x15/0x17
[84379.361488]  [<ffffffff815d13b8>] ieee80211_scan_completed+0x62/0x17f
[84379.361503]  [<ffffffffa0065212>] iwl_bg_scan_completed+0x1ce/0x1d7 [iwlcore]
[84379.361506]  [<ffffffff81057153>] process_one_work+0x1e2/0x301
[84379.361512]  [<ffffffffa0065044>] ? iwl_bg_scan_completed+0x0/0x1d7 [iwlcore]
[84379.361515]  [<ffffffff8105752c>] worker_thread+0x130/0x243
[84379.361517]  [<ffffffff810573fc>] ? worker_thread+0x0/0x243
[84379.361519]  [<ffffffff8105bc1b>] kthread+0x81/0x89
[84379.361522]  [<ffffffff81003914>] kernel_thread_helper+0x4/0x10
[84379.361524]  [<ffffffff8105bb9a>] ? kthread+0x0/0x89
[84379.361526]  [<ffffffff81003910>] ? kernel_thread_helper+0x0/0x10
[84379.361528] ---[ end trace c5ebbd902daa4ea9 ]---

Should this happen? Does anyone care?
I am not sure how reproducible this is.
Thanks,

-- 
MST
