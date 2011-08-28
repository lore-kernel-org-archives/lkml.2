Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751384Ab1H1HAk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Aug 2011 03:00:40 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:38999 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750926Ab1H1HAg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Aug 2011 03:00:36 -0400
Subject: Re: BUG: unable to handle kernel NULL pointer dereference at
 000000a0
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Justin Mattock <justinmattock@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Johannes Berg <johannes.berg@intel.com>,
        linux-wireless@vger.kernel.org
In-Reply-To: <CAKFRV=NPtyEpdpyV+Q37_SSTbdRsNeA=ftZX8cLpNFbV51qFrw@mail.gmail.com>
References: <CAKFRV=NPtyEpdpyV+Q37_SSTbdRsNeA=ftZX8cLpNFbV51qFrw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 28 Aug 2011 09:00:28 +0200
Message-ID: <1314514828.3036.5.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le samedi 27 août 2011 à 13:58 -0700, Justin Mattock a écrit :

CC Johannes Berg & linux-wireless

> running the latest Mainline, on my dell inspiron 1200, s2r does work,
> but ath5k dies out,
> and some smp oops is showing up.
> 
> 
> full dmesg..:
> http://fpaste.org/t1e9/
> 
> [  256.469741] BUG: unable to handle kernel NULL pointer dereference at 000000a0
> [  256.469763] IP: [<c1390104>] set_regdom+0x1ba/0x501
> [  256.469783] *pdpt = 00000000190a0001 *pde = 0000000000000000
> [  256.469797] Oops: 0000 [#1] SMP
> [  256.469808] Modules linked in: snd_seq snd_seq_device i915
> drm_kms_helper drm mperf ath5k ath snd_intel8x0 snd_ac97_codec
> ac97_bus snd_pcm snd_timer joydev snd soundcore e100 yenta_socket
> psmouse evdev i2c_i801 mii snd_page_alloc button battery video ac
> intel_agp intel_gtt uhci_hcd ehci_hcd fan thermal processor
> [  256.469898]
> [  256.469906] Pid: 3510, comm: crda Not tainted
> 3.1.0-rc2-00190-g3210d19 #1 Dell Inc. Inspiron 1200
> /0C8862
> [  256.469927] EIP: 0060:[<c1390104>] EFLAGS: 00010246 CPU: 0
> [  256.469939] EIP is at set_regdom+0x1ba/0x501
> [  256.469948] EAX: dd9e51a0 EBX: dc4d3ab0 ECX: 00000000 EDX: 00000000
> [  256.469959] ESI: ffffff8e EDI: 00000004 EBP: d907dc44 ESP: d907dc00
> [  256.469970]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
> [  256.469981] Process crda (pid: 3510, ti=d907c000 task=c1cd0000
> task.ti=d907c000)
> [  256.469992] Stack:
> [  256.469997]  de002500 d907dc18 d907dc44 00000000 dd4de128 dd4de128
> dc4d3af8 00000006
> [  256.470007]  d907dc3c c11de8b7 00000006 d907dc58 dc4d3af8 dc4d3ab0
> dc4d3b10 dc4d3ab0
> [  256.470007]  dd4de130 d907dc80 c13964b3 00000000 00000004 00000004
> 00000000 dd4de100
> [  256.470007] Call Trace:
> [  256.470007]  [<c11de8b7>] ? nla_parse+0x3c/0x8f
> [  256.470007]  [<c13964b3>] nl80211_set_reg+0x197/0x1e9
> [  256.470007]  [<c1330bf9>] genl_rcv_msg+0x1cb/0x1e8
> [  256.470007]  [<c1330a2e>] ? genl_rcv+0x22/0x22
> [  256.470007]  [<c133014c>] netlink_rcv_skb+0x32/0x73
> [  256.470007]  [<c1330a27>] genl_rcv+0x1b/0x22
> [  256.470007]  [<c132fc76>] netlink_unicast+0x1af/0x210
> [  256.470007]  [<c132feff>] netlink_sendmsg+0x228/0x276
> [  256.470007]  [<c130abf4>] sock_sendmsg+0xc3/0xde
> [  256.470007]  [<c10cedde>] ? might_fault+0x36/0x70
> [  256.470007]  [<c10cedde>] ? might_fault+0x36/0x70
> [  256.470007]  [<c10cedde>] ? might_fault+0x36/0x70
> [  256.470007]  [<c11d234e>] ? _copy_from_user+0x39/0x4d
> [  256.470007]  [<c131367e>] ? verify_iovec+0x3e/0x74
> [  256.470007]  [<c130ae0e>] __sys_sendmsg+0x17d/0x202
> [  256.470007]  [<c130aa0a>] ? sock_sendmsg_nosec+0xbb/0xbb
> [  256.470007]  [<c13da231>] ? _raw_spin_unlock+0x1d/0x20
> [  256.470007]  [<c10eae81>] ? fget_light+0xce/0x248
> [  256.470007]  [<c130c0ce>] sys_sendmsg+0x2b/0x46
> [  256.470007]  [<c130c555>] sys_socketcall+0x166/0x1b4
> [  256.470007]  [<c11d1d3c>] ? trace_hardirqs_on_thunk+0xc/0x10
> [  256.470007]  [<c13df898>] sysenter_do_call+0x12/0x38
> [  256.470007] Code: ff 76 08 68 36 91 57 c1 e8 fb 74 04 00 83 c4 14
> 47 83 c6 18 3b 3b 72 bc e9 9f 01 00 00 83 78 04 02 75 2d 8b 4d c8 be
> 8e ff ff ff
> [  256.470007]  b9 a0 00 00 00 00 0f 85 89 01 00 00 89 c8 89 da 05 a0 00 00
> [  256.470007] EIP: [<c1390104>] set_regdom+0x1ba/0x501 SS:ESP 0068:d907dc00
> [  256.470007] CR2: 00000000000000a0
> [  256.470555] ---[ end trace abd4fbefd1655e11 ]---
> 
> last good kernel I have with this is:
> 3.1.0-rc1 (minus the i915 s2r problem thats fixed now)
> if you need any patches tested on this let me know. I can try a bisect
> since its not to much
> (but might be a while, since the machine is sloooow!!)
> 

NULL deref is in net/wireless/reg.c line 2047

	if (request_wiphy->regd)
		return -EALREADY;

Apparently, request_wiphy is NULL

request_wiphy = wiphy_idx_to_wiphy(last_request->wiphy_idx);



