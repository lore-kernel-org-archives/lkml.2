Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753317Ab2ALKyY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 05:54:24 -0500
Received: from mail-qw0-f53.google.com ([209.85.216.53]:61455 "EHLO
	mail-qw0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751860Ab2ALKyX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 05:54:23 -0500
Message-ID: <1326365659.2950.3.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Subject: Re: [PATCH] rcu: avoid checking for constant
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Jan Engelhardt <jengelh@medozas.de>
Cc: Josh Triplett <josh@joshtriplett.org>, paulmck@linux.vnet.ibm.com,
        laijs@cn.fujitsu.com, manfred@colorfullife.com, dhowells@redhat.com,
        linux-kernel@vger.kernel.org
Date: Thu, 12 Jan 2012 11:54:19 +0100
In-Reply-To: <alpine.LNX.2.01.1201121106040.17330@frira.zrqbmnf.qr>
References: <1326345104-6919-1-git-send-email-jengelh@medozas.de>
	 <20120112071431.GA1896@leaf>
	 <alpine.LNX.2.01.1201121018430.31943@frira.zrqbmnf.qr>
	 <20120112095257.GA2441@leaf>
	 <alpine.LNX.2.01.1201121106040.17330@frira.zrqbmnf.qr>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 12 janvier 2012 à 11:34 +0100, Jan Engelhardt a écrit :

> When compiling kernel or module code with -O0, "offset" is no longer
> considered a constant, and therefore always triggers the build error
> that BUILD_BUG_ON is defined to yield.


Why compiling kernel with -O0 is even considered ?

A lot of patches are needed because gcc -O0 is unable to understand some
code is dead code.

  LD      .tmp_vmlinux1
mm/built-in.o: In function `do_swap_page':
memory.c:(.text+0x44dbd): undefined reference to `ksm_does_need_to_copy'
net/built-in.o: In function `ieee80211_tx_status':
(.text+0x221ac1): undefined reference to `ieee80211s_update_metric'
net/built-in.o: In function `sta_info_insert_finish':
sta_info.c:(.text+0x224c62): undefined reference to
`mesh_accept_plinks_update'
net/built-in.o: In function `ieee80211_teardown_sdata':
iface.c:(.text+0x242773): undefined reference to `mesh_rmc_free'
net/built-in.o: In function `ieee80211_iface_work':
iface.c:(.text+0x242cfa): undefined reference to
`ieee80211_mesh_rx_queued_mgmt'
iface.c:(.text+0x242dc2): undefined reference to `ieee80211_mesh_work'
net/built-in.o: In function `ieee80211_setup_sdata':
iface.c:(.text+0x242ffc): undefined reference to
`ieee80211_mesh_init_sdata'
net/built-in.o: In function `ieee80211_if_remove':
(.text+0x243d1a): undefined reference to `mesh_path_flush_by_iface'
net/built-in.o: In function `ieee80211_remove_interfaces':
(.text+0x243df5): undefined reference to `mesh_path_flush_by_iface'
net/built-in.o: In function `ieee80211_rx_h_action':
rx.c:(.text+0x253ba6): undefined reference to `mesh_action_is_path_sel'
net/built-in.o: In function `ieee80211_xmit':
(.text+0x25a254): undefined reference to `mesh_nexthop_resolve'
net/built-in.o: In function `ieee80211_beacon_get_tim':
(.text+0x25c250): undefined reference to `mesh_add_ds_params_ie'
net/built-in.o: In function `ieee80211_beacon_get_tim':
(.text+0x25c28d): undefined reference to `mesh_add_rsn_ie'
net/built-in.o: In function `ieee80211_beacon_get_tim':
(.text+0x25c2a4): undefined reference to `mesh_add_ht_cap_ie'
net/built-in.o: In function `ieee80211_beacon_get_tim':
(.text+0x25c2bb): undefined reference to `mesh_add_ht_info_ie'
net/built-in.o: In function `ieee80211_beacon_get_tim':
(.text+0x25c2d2): undefined reference to `mesh_add_meshid_ie'
net/built-in.o: In function `ieee80211_beacon_get_tim':
(.text+0x25c2e9): undefined reference to `mesh_add_meshconf_ie'
net/built-in.o: In function `ieee80211_beacon_get_tim':
(.text+0x25c300): undefined reference to `mesh_add_vendor_ies'
make: *** [.tmp_vmlinux1] Erreur 1


