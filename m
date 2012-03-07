Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758787Ab2CGNZQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 08:25:16 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:39321 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758545Ab2CGNZN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 08:25:13 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: 3.3.0-rc6-next-20120305 - iwlwifi BUG sleeping function called from invalid context (2 similar ones)
From: Valdis.Kletnieks@vt.edu
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1331126649_3519P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 07 Mar 2012 08:24:09 -0500
Message-ID: <30424.1331126649@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=dagger.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020207.4F57617B.0007,ss=1,re=0.000,fgs=0,
	ip=0.0.0.0,
	so=2011-07-25 19:15:43,
	dmn=2011-05-27 18:58:46,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1331126649_3519P
Content-Type: text/plain; charset=us-ascii

Seen in my dmesg, 3.3.0-rc6-next20120305.  Dell Latitude E6500,
Intel 5100 wireless card.  Seems to be pretty reproducible.

Have hit this one 368 times in 10 hours of uptime:

[  159.765059] wlan0: authenticate with d8:c7:c8:81:98:f0
[  159.767884] wlan0: send auth to d8:c7:c8:81:98:f0 (try 1/3)
[  159.769451] wlan0: authenticated
[  159.769870] wlan0: waiting for beacon from d8:c7:c8:81:98:f0
[  159.881293] wlan0: associate with d8:c7:c8:81:98:f0 (try 1/3)
[  159.883470] wlan0: RX AssocResp from d8:c7:c8:81:98:f0 (capab=0x511 status=0 aid=4)
[  159.883474] wlan0: associated
[  159.890205] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[  164.620017] BUG: sleeping function called from invalid context at drivers/net/wireless/iwlwifi/iwl-trans.h:459
[  164.620950] in_atomic(): 1, irqs_disabled(): 1, pid: 59, name: kworker/u:4
[  164.620950] 5 locks held by kworker/u:4/59:
[  164.620950]  #0:  (wiphy_name(local->hw.wiphy)){.+.+.+}, at: [<ffffffff810449e0>] process_one_work+0x1a4/0x455
[  164.620950]  #1:  ((&sta->ampdu_mlme.work)){+.+...}, at: [<ffffffff810449e0>] process_one_work+0x1a4/0x455
[  164.620950]  #2:  (&sta->ampdu_mlme.mtx){+.+.+.}, at: [<ffffffff8157b43f>] ieee80211_ba_session_work+0x49/0x1cd
[  164.620950]  #3:  (&priv->shrd->mutex){+.+.+.}, at: [<ffffffff8134d9c6>] iwlagn_mac_ampdu_action+0xba/0x322
[  164.620950]  #4:  (&(&priv->shrd->sta_lock)->rlock){..-...}, at: [<ffffffff81352aa1>] iwlagn_tx_agg_start+0x124/0x26d
[  164.620950] irq event stamp: 2564
[  164.620950] hardirqs last  enabled at (2563): [<ffffffff810c88ad>] __free_pages_ok+0x97/0xa3
[  164.620950] hardirqs last disabled at (2564): [<ffffffff815da880>] _raw_spin_lock_irqsave+0x1a/0x57
[  164.620950] softirqs last  enabled at (2532): [<ffffffff81032641>] irq_exit+0x75/0xd5
[  164.620950] softirqs last disabled at (2531): [<ffffffff810032cc>] do_IRQ+0x89/0xa0
[  164.620950] Pid: 59, comm: kworker/u:4 Tainted: G           O 3.3.0-rc6-next-20120305 #1
[  164.620950] Call Trace:
[  164.620950]  [<ffffffff8106f16f>] ? print_irqtrace_events+0x9d/0xa1
[  164.620950]  [<ffffffff81053486>] __might_sleep+0x19f/0x1a7
[  164.620950]  [<ffffffff81352adb>] iwlagn_tx_agg_start+0x15e/0x26d
[  164.620950]  [<ffffffff8134dadb>] iwlagn_mac_ampdu_action+0x1cf/0x322
[  164.620950]  [<ffffffff8157bed2>] drv_ampdu_action+0x135/0x20f
[  164.620950]  [<ffffffff8157c978>] ieee80211_tx_ba_session_handle_start+0x79/0x28a
[  164.620950]  [<ffffffff81070a29>] ? trace_hardirqs_on+0xd/0xf
[  164.620950]  [<ffffffff81031edf>] ? _local_bh_enable_ip+0x127/0x18f
[  164.620950]  [<ffffffff8157b515>] ieee80211_ba_session_work+0x11f/0x1cd
[  164.620950]  [<ffffffff81044a97>] process_one_work+0x25b/0x455
[  164.620950]  [<ffffffff810449e0>] ? process_one_work+0x1a4/0x455
[  164.620950]  [<ffffffff8157b3f6>] ? ieee80211_sta_tear_down_BA_sessions+0x56/0x56
[  164.620950]  [<ffffffff8104289d>] ? spin_lock_irq+0x9/0xb
[  164.620950]  [<ffffffff81044fa7>] worker_thread+0x15a/0x239
[  164.620950]  [<ffffffff81044e4d>] ? rescuer_thread+0x192/0x192
[  164.620950]  [<ffffffff810499bd>] kthread+0x86/0x8e
[  164.620950]  [<ffffffff815e2434>] kernel_thread_helper+0x4/0x10
[  164.620950]  [<ffffffff815db41d>] ? retint_restore_args+0xe/0xe
[  164.620950]  [<ffffffff81049937>] ? flush_kthread_worker+0xcf/0xcf
[  164.620950]  [<ffffffff815e2430>] ? gs_change+0xb/0xb
[  164.842511]

And the other one has triggered 344 times:

[  299.323405] BUG: sleeping function called from invalid context at drivers/net/wireless/iwlwifi/iwl-trans.h:448
[  299.323410] in_atomic(): 1, irqs_disabled(): 1, pid: 61, name: kworker/u:6
[  299.323412] INFO: lockdep is turned off.
[  299.323415] irq event stamp: 35694
[  299.323417] hardirqs last  enabled at (35693): [<ffffffff8109aedb>] rcu_note_context_switch+0x1d9/0x29a
[  299.323426] hardirqs last disabled at (35694): [<ffffffff815da82d>] _raw_spin_lock_irq+0x12/0x4b
[  299.323432] softirqs last  enabled at (34130): [<ffffffff8157343e>] ieee80211_configure_filter+0x1b5/0x30d
[  299.323439] softirqs last disabled at (34128): [<ffffffff815da908>] _raw_spin_lock_bh+0x11/0x4a
[  299.323445] Pid: 61, comm: kworker/u:6 Tainted: G           O 3.3.0-rc6-next-20120305 #1
[  299.323448] Call Trace:
[  299.323454]  [<ffffffff8106f16f>] ? print_irqtrace_events+0x9d/0xa1
[  299.323460]  [<ffffffff81053486>] __might_sleep+0x19f/0x1a7
[  299.323465]  [<ffffffff813519c7>] iwl_trans_tx_agg_disable+0x27/0x70
[  299.323469]  [<ffffffff8135294d>] iwlagn_tx_agg_stop+0x1d6/0x206
[  299.323475]  [<ffffffff8134db1d>] iwlagn_mac_ampdu_action+0x211/0x322
[  299.323480]  [<ffffffff8157bed2>] drv_ampdu_action+0x135/0x20f
[  299.323484]  [<ffffffff8157c863>] ___ieee80211_stop_tx_ba_session+0x143/0x1df
[  299.323489]  [<ffffffff8157b59f>] ieee80211_ba_session_work+0x1a9/0x1cd
[  299.323494]  [<ffffffff81044a97>] process_one_work+0x25b/0x455
[  299.323498]  [<ffffffff810449e0>] ? process_one_work+0x1a4/0x455
[  299.323503]  [<ffffffff8157b3f6>] ? ieee80211_sta_tear_down_BA_sessions+0x56/0x56
[  299.323507]  [<ffffffff8104289d>] ? spin_lock_irq+0x9/0xb
[  299.323511]  [<ffffffff81044fa7>] worker_thread+0x15a/0x239
[  299.323515]  [<ffffffff81044e4d>] ? rescuer_thread+0x192/0x192
[  299.323520]  [<ffffffff810499bd>] kthread+0x86/0x8e
[  299.323525]  [<ffffffff815e2434>] kernel_thread_helper+0x4/0x10
[  299.323530]  [<ffffffff815db41d>] ? retint_restore_args+0xe/0xe
[  299.323534]  [<ffffffff81049937>] ? flush_kthread_worker+0xcf/0xcf
[  299.323538]  [<ffffffff815e2430>] ? gs_change+0xb/0xb




--==_Exmh_1331126649_3519P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBT1dheAdmEQWDXROgAQJe4Q/+L07FXbCRCq+Xo9me0lr5EHJlpPmTdN+a
fReNsZU5foVFOh7yzqyb14jL9xWa9oSkuVv4mPN3d5iX2BfH/1eMYUmRr0miGSTJ
2UxKMi512mGP3mNxLOUSy17bLeabf6mI42gT+QbGFuvbPw+caXjVDVDlRFIX9/Jr
qEFTuDkcLDVozn/vEAGuxSBhmCecGQFuy60waCJLZughFQU4nSTahiNJFOjrBs67
rNqIn5T2UumWs2NfjWhXImaYCiJj3lhYjl6SpmCLkz/SxhBfSLaJ4cE1xMg/gSat
0UT+h0UijIssQYi5cLjC5sMGWLuMA66ixboL6BrHvfhiGladHxXglcggsO97nd60
+KaKAAgXSgdZhooUZCEvruWPwXa0BzvXXrAfh1i9UxmuIXU7ZOyNfNIbp0Pn7qHm
nkvRQeuehiOPuIaxUi9KSmW743qGzXHJQqzVRqxnLS8Uwq3eUSXANaV1Uqaa95Uj
GBVNEDZdt82hniY+F5C1gqJoAhAWXzDuGOEWFdmbWhB7geO8mml67eBPNfvAd8hQ
q9NK7amM4UdEzLr9xrL/tVKK+I1l9CMDutWk502USKcsr5njYlEpep5bAvyY1fPM
/PayIhhJ6vNlWiKgmGlXMY60GlZsZssT2Tf2jXtPzw+z4gLGYriYD87VzyWnB7HO
Ow40Lpm0puA=
=7RcF
-----END PGP SIGNATURE-----

--==_Exmh_1331126649_3519P--

