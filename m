Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754958Ab0I1Wa5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 18:30:57 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:38112 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750975Ab0I1Wa4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 18:30:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=syKQ5KeodNp4AJmNoREfuUyl82frG1v5/Yb3CTy2VHSPkpaTt6xqEq4nmpR8VPt2zA
         m4pXeFWtzzTXH/223uoKAgrWnxEItIRWAdfVxt5UudSTo9PXpQOGfKT85E5dypDiLgV7
         /NLpXJPIEPspox9c8nppMIDmptsQ9AeaK11uk=
MIME-Version: 1.0
Date: Tue, 28 Sep 2010 15:30:54 -0700
Message-ID: <AANLkTim5WCGKPvEkOkO_YnMF9pg8mvLfQoFBNUFpfa_k@mail.gmail.com>
Subject: WARNING: at drivers/net/wireless/ath/ath5k/base.c:3475
 ath5k_bss_info_changed+0x44/0x168 [ath5k]()
From: Justin Mattock <justinmattock@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hello,
I seem to be hitting something when doing echo mem > /sys/power/state
on my dell 1200 inspiron
the wireless card is a D-Link DWL-G650. This is easily reproducable so
a bisect I can do but might be a few days since this machine is vary
sloooow...

[  563.875560] ------------[ cut here ]------------
[  563.875576] WARNING: at drivers/net/wireless/ath/ath5k/base.c:3475
ath5k_bss_info_changed+0x44/0x168 [ath5k]()
[  563.875580] Hardware name: Inspiron 1200
[  563.875583] Modules linked in: snd_seq snd_seq_device i915
drm_kms_helper drm mperf ath5k ath snd_intel8x0 snd_ac97_codec
ac97_bus joydev snd_pcm snd_timer video ac psmouse intel_agp battery
button snd soundcore snd_page_alloc evdev yenta_socket i2c_i801
uhci_hcd ehci_hcd fan thermal processor
[  563.875618] Pid: 3149, comm: bash Not tainted 2.6.36-rc5-00226-g050026f #6
[  563.875621] Call Trace:
[  563.875630]  [<c10512db>] warn_slowpath_common+0x65/0x7a
[  563.875641]  [<e04ebd19>] ? ath5k_bss_info_changed+0x44/0x168 [ath5k]
[  563.875646]  [<c10512ff>] warn_slowpath_null+0xf/0x13
[  563.875656]  [<e04ebd19>] ath5k_bss_info_changed+0x44/0x168 [ath5k]
[  563.875664]  [<c13549b3>] ieee80211_bss_info_change_notify+0x135/0x13e
[  563.875674]  [<e04ebcd5>] ? ath5k_bss_info_changed+0x0/0x168 [ath5k]
[  563.875681]  [<c135ab36>] ieee80211_set_disassoc+0x1a7/0x1bf
[  563.875687]  [<c135ad97>] ieee80211_mgd_deauth+0x48/0x16a
[  563.875693]  [<c1361c02>] ieee80211_deauth+0x14/0x16
[  563.875699]  [<c134da5a>] __cfg80211_mlme_deauth+0xf6/0xff
[  563.875706]  [<c13507ee>] __cfg80211_disconnect+0xeb/0x150
[  563.875714]  [<c133f8ad>] cfg80211_netdev_notifier_call+0x24e/0x3b4
[  563.875720]  [<c138614f>] notifier_call_chain+0x26/0x50
[  563.875727]  [<c106aec9>] raw_notifier_call_chain+0xc/0xe
[  563.875733]  [<c12ddd78>] call_netdevice_notifiers+0x3c/0x43
[  563.875738]  [<c12de16a>] __dev_close+0x43/0x6a
[  563.875743]  [<c12de1a5>] dev_close+0x14/0x36
[  563.875747]  [<c12de252>] rollback_registered_many+0x8b/0x179
[  563.875753]  [<c12de34f>] unregister_netdevice_many+0xf/0x4e
[  563.875759]  [<c135ebdb>] ieee80211_remove_interfaces+0x97/0x9f
[  563.875764]  [<c135400d>] ieee80211_unregister_hw+0x43/0xec
[  563.875774]  [<e04eea8a>] ath5k_pci_remove+0x23/0xcf [ath5k]
[  563.875782]  [<c123e494>] ? pm_runtime_resume+0x26/0x2c
[  563.875789]  [<c11b7bae>] pci_device_remove+0x27/0xa3
[  563.875795]  [<c1239a8e>] __device_release_driver+0x59/0x9d
[  563.875799]  [<c1239b6f>] device_release_driver+0x18/0x23
[  563.875807]  [<c1239296>] bus_remove_device+0x78/0x85
[  563.875812]  [<c1237d94>] device_del+0xee/0x12f
[  563.875817]  [<c1237de0>] device_unregister+0xb/0x15
[  563.875822]  [<c11b47d1>] pci_stop_bus_device+0x45/0x51
[  563.875827]  [<c11b4851>] pci_remove_bus_device+0xd/0x93
[  563.875832]  [<c11b48f1>] pci_remove_behind_bridge+0x1a/0x2d
[  563.875838]  [<c1273656>] cb_free+0x12/0x14
[  563.875842]  [<c1272bb9>] socket_late_resume+0x72/0x90
[  563.875847]  [<c1272b47>] ? socket_late_resume+0x0/0x90
[  563.875852]  [<c1272558>] __pcmcia_pm_op+0x1c/0x2c
[  563.875856]  [<c1272586>] ? pcmcia_socket_dev_resume+0x0/0xf
[  563.875861]  [<c1272593>] pcmcia_socket_dev_resume+0xd/0xf
[  563.875867]  [<c123c973>] pm_op+0x89/0x128
[  563.875872]  [<c123cddd>] device_resume+0x8c/0xbf
[  563.875877]  [<c123cedd>] dpm_resume_end+0xcd/0x2b6
[  563.875883]  [<c107cf60>] suspend_devices_and_enter+0x13d/0x168
[  563.875888]  [<c107d024>] enter_state+0x99/0xb6
[  563.875893]  [<c107c928>] state_store+0x93/0xa7
[  563.875897]  [<c107c895>] ? state_store+0x0/0xa7
[  563.875903]  [<c11a2411>] kobj_attr_store+0x16/0x22
[  563.875910]  [<c1112ceb>] sysfs_write_file+0xbf/0xea
[  563.875916]  [<c10d0d4d>] vfs_write+0x8a/0xfd
[  563.875920]  [<c1112c2c>] ? sysfs_write_file+0x0/0xea
[  563.875925]  [<c10d0e57>] sys_write+0x3b/0x60
[  563.875932]  [<c1023998>] sysenter_do_call+0x12/0x28
[  563.875936] ---[ end trace 61c0f611befa1753 ]---
[  563.875941] wlan0: deauthenticating from 00:1e:2a:00:67:f0 by local
choice (reason=3)
[  563.876196] ------------[ cut here ]------------
[  563.876202] WARNING: at net/mac80211/work.c:884
ieee80211_work_work+0x5f/0xdb7()
[  563.876206] Hardware name: Inspiron 1200
[  563.876208] work scheduled while going to suspend
[  563.876211] Modules linked in: snd_seq snd_seq_device i915
drm_kms_helper drm mperf ath5k ath snd_intel8x0 snd_ac97_codec
ac97_bus joydev snd_pcm snd_timer video ac psmouse intel_agp battery
button snd soundcore snd_page_alloc evdev yenta_socket i2c_i801
uhci_hcd ehci_hcd fan thermal processor
[  563.876240] Pid: 3149, comm: bash Tainted: G        W
2.6.36-rc5-00226-g050026f #6
[  563.876243] Call Trace:
[  563.876248]  [<c10512db>] warn_slowpath_common+0x65/0x7a
[  563.876254]  [<c135dbe3>] ? ieee80211_work_work+0x5f/0xdb7
[  563.876259]  [<c1051354>] warn_slowpath_fmt+0x26/0x2a
[  563.876264]  [<c135dbe3>] ieee80211_work_work+0x5f/0xdb7
[  563.876269]  [<c1361c02>] ? ieee80211_deauth+0x14/0x16
[  563.876274]  [<c134da5a>] ? __cfg80211_mlme_deauth+0xf6/0xff
[  563.876281]  [<c13822dc>] ? __mutex_lock_slowpath+0x1ef/0x1f7
[  563.876287]  [<c135e998>] ieee80211_work_purge+0x5d/0x9d
[  563.876293]  [<c135f5f3>] ieee80211_stop+0x3b/0x3c4
[  563.876300]  [<c12ec57f>] ? dev_deactivate+0x133/0x153
[  563.876305]  [<c12de181>] __dev_close+0x5a/0x6a
[  563.876309]  [<c12de1a5>] dev_close+0x14/0x36
[  563.876314]  [<c12de252>] rollback_registered_many+0x8b/0x179
[  563.876319]  [<c12de34f>] unregister_netdevice_many+0xf/0x4e
[  563.876325]  [<c135ebdb>] ieee80211_remove_interfaces+0x97/0x9f
[  563.876330]  [<c135400d>] ieee80211_unregister_hw+0x43/0xec
[  563.876340]  [<e04eea8a>] ath5k_pci_remove+0x23/0xcf [ath5k]
[  563.876345]  [<c123e494>] ? pm_runtime_resume+0x26/0x2c
[  563.876351]  [<c11b7bae>] pci_device_remove+0x27/0xa3
[  563.876356]  [<c1239a8e>] __device_release_driver+0x59/0x9d
[  563.876361]  [<c1239b6f>] device_release_driver+0x18/0x23
[  563.876366]  [<c1239296>] bus_remove_device+0x78/0x85
[  563.876372]  [<c1237d94>] device_del+0xee/0x12f
[  563.876377]  [<c1237de0>] device_unregister+0xb/0x15
[  563.876381]  [<c11b47d1>] pci_stop_bus_device+0x45/0x51
[  563.876386]  [<c11b4851>] pci_remove_bus_device+0xd/0x93
[  563.876391]  [<c11b48f1>] pci_remove_behind_bridge+0x1a/0x2d
[  563.876396]  [<c1273656>] cb_free+0x12/0x14
[  563.876401]  [<c1272bb9>] socket_late_resume+0x72/0x90
[  563.876405]  [<c1272b47>] ? socket_late_resume+0x0/0x90
[  563.876410]  [<c1272558>] __pcmcia_pm_op+0x1c/0x2c
[  563.876415]  [<c1272586>] ? pcmcia_socket_dev_resume+0x0/0xf
[  563.876420]  [<c1272593>] pcmcia_socket_dev_resume+0xd/0xf
[  563.876425]  [<c123c973>] pm_op+0x89/0x128
[  563.876430]  [<c123cddd>] device_resume+0x8c/0xbf
[  563.876435]  [<c123cedd>] dpm_resume_end+0xcd/0x2b6
[  563.876440]  [<c107cf60>] suspend_devices_and_enter+0x13d/0x168
[  563.876445]  [<c107d024>] enter_state+0x99/0xb6
[  563.876450]  [<c107c928>] state_store+0x93/0xa7
[  563.876454]  [<c107c895>] ? state_store+0x0/0xa7
[  563.876459]  [<c11a2411>] kobj_attr_store+0x16/0x22
[  563.876464]  [<c1112ceb>] sysfs_write_file+0xbf/0xea
[  563.876470]  [<c10d0d4d>] vfs_write+0x8a/0xfd
[  563.876474]  [<c1112c2c>] ? sysfs_write_file+0x0/0xea
[  563.876479]  [<c10d0e57>] sys_write+0x3b/0x60
[  563.876484]  [<c1023998>] sysenter_do_call+0x12/0x28
[  563.876488] ---[ end trace 61c0f611befa1754 ]---
[  563.878327] cfg80211: Calling CRDA to update world regulatory domain
[  563.881264] ath5k 0000:03:00.0: PCI INT A disabled
[  563.881504] pci 0000:03:00.0: reg 10: [mem 0x24000000-0x2400ffff]
[  563.881660] pci 0000:03:00.0: BAR 0: assigned [mem 0x24000000-0x2400ffff]
[  563.881671] pci 0000:03:00.0: BAR 0: set to [mem
0x24000000-0x2400ffff] (PCI address [0x24000000-0x2400ffff]
[  563.881866] ath5k 0000:03:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[  563.881972] ath5k 0000:03:00.0: registered as 'phy1'
[  564.470266] ath: EEPROM regdomain: 0x10
[  564.470269] ath: EEPROM indicates we should expect a direct regpair map
[  564.470273] ath: Country alpha2 being used: CO
[  564.470276] ath: Regpair used: 0x10
[  564.470534] phy1: Selected rate control algorithm 'minstrel_ht'
[  564.471215] cfg80211: Calling CRDA for country: CO
[  564.471292] ath5k phy1: Atheros AR2414 chip found (MAC: 0x79, PHY: 0x45)
[  564.471438] pci 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 1


keep in mind I reverted the kernel too 2.6.31 and this thing is
lifeless upon wakeup so bisecting(hopefully) doesnt turn into a mess..

-- 
Justin P. Mattock
