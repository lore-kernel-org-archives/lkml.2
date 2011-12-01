Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751776Ab1LAI6w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 03:58:52 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44978 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751360Ab1LAI6u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 03:58:50 -0500
Date: Thu, 1 Dec 2011 09:58:45 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, Yong Zhang <yong.zhang0@gmail.com>
Subject: Re: [3.2-rc3] 100% CPU usage while in del_timer_sync from
 iwl3945_rs_free_sta
Message-ID: <20111201085845.GA4602@tiehlicka.suse.cz>
References: <20111129100727.GD2675@tiehlicka.suse.cz>
 <20111129113906.GA7299@redhat.com>
 <20111130101028.GA2906@tiehlicka.suse.cz>
 <20111130142316.GA2466@redhat.com>
 <20111130140316.GA4153@tiehlicka.suse.cz>
 <20111130153929.GA2144@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111130153929.GA2144@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 30-11-11 16:39:30, Stanislaw Gruszka wrote:
> On Wed, Nov 30, 2011 at 03:03:16PM +0100, Michal Hocko wrote:
> > No, didn't help unfortunately...
> 
> Lets gather some more messages. Please apply attached simple patch,
> recompile with:
> CONFIG_MAC80211_DEBUG_MENU=y
> CONFIG_MAC80211_VERBOSE_DEBUG=y

$ zgrep "MAC80211.*DEBUG" /proc/config.gz | grep -v ^\#
CONFIG_MAC80211_DEBUG_MENU=y
CONFIG_MAC80211_VERBOSE_DEBUG=y

> and provide dmesg.

[  262.007061] ieee80211 phy0: device no longer idle - scanning
[  266.699301] ieee80211 phy0: device now idle
[  342.002248] ieee80211 phy0: device no longer idle - scanning
[  346.695045] ieee80211 phy0: device now idle
[  351.813276] ieee80211 phy0: device no longer idle - scanning
[  355.487602] ieee80211 phy0: device now idle
[  360.491257] ieee80211 phy0: device no longer idle - scanning
[  364.170612] ieee80211 phy0: device now idle
[  369.175101] ieee80211 phy0: device no longer idle - scanning
[  372.847072] ieee80211 phy0: device now idle
[  372.848534] ieee80211 phy0: device no longer idle - working
[  372.848545] wlan0: authenticate with 00:0b:6b:3c:8c:e4 (try 1)
[  372.850295] wlan0: authenticated
[  372.850317] ieee80211 phy0: device now idle
[  372.852870] iwl3945_rs_alloc_sta rs_sta f411dac0
[  372.852877] ieee80211 phy0: Allocated STA 00:0b:6b:3c:8c:e4
[  372.852882] ieee80211 phy0: Inserted dummy STA 00:0b:6b:3c:8c:e4
[  372.852897] ieee80211 phy0: device no longer idle - working
[  372.852903] wlan0: associate with 00:0b:6b:3c:8c:e4 (try 1)
[  372.910215] wlan0: RX ReassocResp from 00:0b:6b:3c:8c:e4 (capab=0x431 status=0 aid=1)
[  372.910223] wlan0: associated
[  372.910341] ieee80211 phy0: Inserted STA 00:0b:6b:3c:8c:e4
[  372.910352] ieee80211 phy0: WMM queue=2 aci=0 acm=0 aifs=2 cWmin=7 cWmax=1023 txop=64 uapsd=0
[  372.910362] ieee80211 phy0: WMM queue=3 aci=1 acm=0 aifs=7 cWmin=15 cWmax=1023 txop=0 uapsd=0
[  372.910372] ieee80211 phy0: WMM queue=1 aci=2 acm=0 aifs=2 cWmin=7 cWmax=15 txop=94 uapsd=0
[  372.910381] ieee80211 phy0: WMM queue=0 aci=3 acm=0 aifs=2 cWmin=3 cWmax=7 txop=47 uapsd=0
[  383.384042] wlan0: no IPv6 routers present
[  426.375395] PM: Syncing filesystems ... done.
[  426.430760] PM: Preparing system for mem sleep
[...]
suspen
resume with AP deactivated
[...]
[  431.324532] iwl3945 0000:05:00.0: restoring config space at offset 0xf (was 0x100, writing 0x10b)
[  431.324601] iwl3945 0000:05:00.0: restoring config space at offset 0x4 (was 0x0, writing 0x80100000)
[  431.324616] iwl3945 0000:05:00.0: restoring config space at offset 0x3 (was 0x0, writing 0x10)
[  431.324636] iwl3945 0000:05:00.0: restoring config space at offset 0x1 (was 0x100000, writing 0x100406)
[...]
[  434.064050] ieee80211 phy0: wlan0: No probe response from AP 00:0b:6b:3c:8c:e4 after 500ms, try 1/5
[  434.250089] usb 5-2: New USB device found, idVendor=0c24, idProduct=000f
[  434.250098] usb 5-2: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[  434.564034] ieee80211 phy0: wlan0: No probe response from AP 00:0b:6b:3c:8c:e4 after 500ms, try 2/5
[  435.004096] wlan0: detected beacon loss from AP - sending probe request
[  435.064044] ieee80211 phy0: wlan0: No probe response from AP 00:0b:6b:3c:8c:e4 after 500ms, try 3/5
[  435.564047] ieee80211 phy0: wlan0: No probe response from AP 00:0b:6b:3c:8c:e4 after 500ms, try 4/5
[  436.064065] ieee80211 phy0: wlan0: No probe response from AP 00:0b:6b:3c:8c:e4 after 500ms, disconnecting.
[  436.148044] ieee80211 phy0: Removed STA 00:0b:6b:3c:8c:e4
[  436.148069] iwl3945_rs_free_sta rs_sta f411dac0
[  436.148076] ------------[ cut here ]------------
[  436.148097] WARNING: at drivers/net/wireless/iwlegacy/iwl-3945-rs.c:438 iwl3945_rs_free_sta+0x33/0x42 [iwl3945]()
[  436.148103] Hardware name: LIFEBOOK S7110
[  436.148107] Modules linked in: aes_i586 aes_generic i915 fbcon font bitblit softcursor drm_kms_helper drm fb fbdev i2c_algo_bit cfbcopyarea i2c_core cfbimgblt cfbfillrect fuse tun coretemp hwmon arc4 snd_hda_codec_realtek iwl3945 snd_hda_intel iwl_legacy snd_hda_codec snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_oss snd_seq_midi_event mac80211 snd_seq snd_timer snd_seq_device snd fujitsu_laptop video backlight cfg80211 snd_page_alloc [last unloaded: scsi_wait_scan]
[  436.148195] Pid: 1330, comm: kworker/u:4 Tainted: G        W    3.2.0-rc3-mac80211test-00005-g1b97fa2 #19
[  436.148200] Call Trace:
[  436.148214]  [<c01331ac>] warn_slowpath_common+0x68/0x7d
[  436.148229]  [<f8223454>] ? iwl3945_rs_free_sta+0x33/0x42 [iwl3945]
[  436.148238]  [<c01331d5>] warn_slowpath_null+0x14/0x18
[  436.148251]  [<f8223454>] iwl3945_rs_free_sta+0x33/0x42 [iwl3945]
[  436.148274]  [<f81c2f94>] __sta_info_free.isra.24+0x28/0x60 [mac80211]
[  436.148296]  [<f81c3df9>] __sta_info_destroy+0x259/0x283 [mac80211]
[  436.148320]  [<f81c4194>] sta_info_flush+0x43/0x6e [mac80211]
[  436.148346]  [<f81c9453>] ieee80211_set_disassoc+0x1a3/0x1d7 [mac80211]
[  436.148372]  [<f81c95e8>] ieee80211_sta_connection_lost+0x31/0x8a [mac80211]
[  436.148382]  [<c0311367>] ? dev_printk+0x2b/0x2d
[  436.148409]  [<f81cbde2>] ieee80211_sta_work+0x1b0/0x1c3 [mac80211]
[  436.148439]  [<f81ce38a>] ieee80211_iface_work+0x23e/0x250 [mac80211]
[  436.148450]  [<c0146673>] process_one_work+0x19b/0x2e6
[  436.148476]  [<f81ce14c>] ? ieee80211_netdev_select_queue+0x14/0x14 [mac80211]
[  436.148485]  [<c0146ba1>] worker_thread+0x136/0x1ee
[  436.148494]  [<c0146a6b>] ? manage_workers.isra.23+0x14f/0x14f
[  436.148502]  [<c0149eb9>] kthread+0x67/0x6c
[  436.148510]  [<c0149e52>] ? kthread_worker_fn+0x119/0x119
[  436.148520]  [<c0475576>] kernel_thread_helper+0x6/0x10
[  436.148525] ---[ end trace f37fc1957f2d5230 ]---
[  436.148532] ieee80211 phy0: Destroyed STA 00:0b:6b:3c:8c:e4
[  436.148546] ieee80211 phy0: device now idle
[  436.164140] cfg80211: Calling CRDA to update world regulatory domain
[  436.248933] ieee80211 phy0: device no longer idle - scanning
[  439.932216] ieee80211 phy0: device now idle
[  444.930668] ieee80211 phy0: device no longer idle - scanning
[  448.604546] ieee80211 phy0: device now idle
[  453.608897] ieee80211 phy0: device no longer idle - scanning
[  457.283583] ieee80211 phy0: device now idle
[  462.287692] ieee80211 phy0: device no longer idle - scanning
[  465.964143] ieee80211 phy0: device now idle
[  470.967145] ieee80211 phy0: device no longer idle - scanning
[  474.642423] ieee80211 phy0: device now idle 

So we are hitting NULL timer in the iwl3945_rs_free_sta again. Is it
possible that the timer was just deactivated during suspend? I do not
see any code doing that in the iwl driver but maybe there is some
generic functionality at 80211 layer.

I will try to turn on timer debugging suggested by Yong Zhang in other
email.

Thanks
-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
