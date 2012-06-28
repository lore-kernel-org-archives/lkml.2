Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932545Ab2F1HZT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 03:25:19 -0400
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:55871 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751564Ab2F1HZR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 03:25:17 -0400
Date: Thu, 28 Jun 2012 16:25:12 +0900
From: Norbert Preining <preining@logic.at>
To: "Venkataraman, Meenakshi" <meenakshi.venkataraman@intel.com>,
        "Lin, Hsien KuoX" <hsien.kuox.lin@intel.com>
Cc: Emmanuel Grumbach <egrumbach@gmail.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ipw3945-devel@lists.sourceforge.net" 
	<ipw3945-devel@lists.sourceforge.net>,
        "ilw@linux.intel.com" <ilw@linux.intel.com>
Subject: Re: 3.4-rc2, ilwagn still most of the time completely unusable
Message-ID: <20120628072512.GF31944@gamma.logic.tuwien.ac.at>
References: <20120330011734.GH6277@gamma.logic.tuwien.ac.at> <20120411023747.GA10126@gamma.logic.tuwien.ac.at> <4595B4D22AB93C4FABBA84AAD5AA37FD11DE3C@ORSMSX103.amr.corp.intel.com> <20120412000202.GA15286@gamma.logic.tuwien.ac.at> <4595B4D22AB93C4FABBA84AAD5AA37FD120BF8@ORSMSX103.amr.corp.intel.com> <20120413014047.GB25681@gamma.logic.tuwien.ac.at> <20120330011734.GH6277@gamma.logic.tuwien.ac.at> <20120411023747.GA10126@gamma.logic.tuwien.ac.at> <4595B4D22AB93C4FABBA84AAD5AA37FD11DE3C@ORSMSX103.amr.corp.intel.com> <20120412000202.GA15286@gamma.logic.tuwien.ac.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <59083F8344AE164EB150C0518405C0680E0F285C@FMSMSX107.amr.corp.intel.com> <20120413014047.GB25681@gamma.logic.tuwien.ac.at> <20120412000202.GA15286@gamma.logic.tuwien.ac.at>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

I am coming back to this old thread, not because it has been solved, 
but because today I got a funny new message while checking why 
everything got stuck again:
	[69588.972126] iwlwifi 0000:06:00.0: fail to flush all tx fifo queues
and after doing
	rfkill block wifi
	sleep 20
	rfkill unblock wifi
I got a kernel warning:
[76477.289251] WARNING: at net/mac80211/driver-ops.h:12 ieee80211_bss_info_change_notify+0x14e/0x1ca [mac80211]()
[76477.289256] Hardware name: VGN-Z11VN_B
[76477.289260] wlan0:  Failed check-sdata-in-driver check, flags: 0x0
[76477.289350] Modules linked in: dm_mod btusb iptable_filter bnep rfcomm bluetooth snd_hrtimer vboxpci(O) vboxnetadp(O) vboxnetflt(O) vboxdrv(O) binfmt_misc isofs btrfs zlib_deflate libcrc32c vfat fat fuse loop uinput snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm snd_page_alloc hso arc4 snd_seq_dummy snd_seq_oss snd_seq_midi snd_rawmidi iwlwifi mac80211 snd_seq_midi_event cfg80211 snd_seq lpc_ich snd_seq_device snd_timer mxm_wmi mfd_core snd firewire_ohci firewire_core sony_laptop joydev crc_itu_t tpm_infineon rfkill soundcore
[76477.289361] Pid: 4278, comm: NetworkManager Tainted: P        W  O 3.5.0-rc4+ #78
[76477.289365] Call Trace:
[76477.289380]  [<ffffffff8102ba46>] warn_slowpath_common+0x83/0x9c
[76477.289389]  [<ffffffff8102bb02>] warn_slowpath_fmt+0x46/0x48
[76477.289402]  [<ffffffff813f21da>] ? neigh_ifdown+0xc5/0xd6
[76477.289424]  [<ffffffffa00b252e>] ieee80211_bss_info_change_notify+0x14e/0x1ca [mac80211]
[76477.289448]  [<ffffffffa00b267d>] ieee80211_ifa_changed+0xd3/0xe6 [mac80211]
[76477.289458]  [<ffffffff8104b7e3>] notifier_call_chain+0x37/0x61
[76477.289467]  [<ffffffff8104b919>] __blocking_notifier_call_chain+0x46/0x5f
[76477.289475]  [<ffffffff8104b946>] blocking_notifier_call_chain+0x14/0x16
[76477.289485]  [<ffffffff81432cc0>] __inet_del_ifa+0x176/0x22c
[76477.289494]  [<ffffffff81432f96>] inet_rtm_deladdr+0xe7/0x128
[76477.289504]  [<ffffffff813f61e0>] rtnetlink_rcv_msg+0x226/0x235
[76477.289513]  [<ffffffff8140460c>] ? netlink_sendmsg+0x124/0x20e
[76477.289520]  [<ffffffff813f5fba>] ? __rtnl_unlock+0x17/0x17
[76477.289528]  [<ffffffff814048b8>] netlink_rcv_skb+0x43/0x91
[76477.289536]  [<ffffffff813f415f>] rtnetlink_rcv+0x26/0x2d
[76477.289543]  [<ffffffff81404466>] netlink_unicast+0xe0/0x162
[76477.289551]  [<ffffffff814046d1>] netlink_sendmsg+0x1e9/0x20e
[76477.289562]  [<ffffffff813d7360>] __sock_sendmsg_nosec+0x61/0x6c
[76477.289570]  [<ffffffff813d774e>] sock_sendmsg+0xa1/0xb6
[76477.289582]  [<ffffffff813d96fb>] ? move_addr_to_kernel+0x49/0x67
[76477.289591]  [<ffffffff813e2605>] ? copy_from_user+0x9/0xb
[76477.289599]  [<ffffffff813e29e2>] ? verify_iovec+0x52/0xa4
[76477.289607]  [<ffffffff813d7a11>] __sys_sendmsg+0x206/0x293
[76477.289617]  [<ffffffff8108d48b>] ? __rcu_read_unlock+0xc/0x55
[76477.289627]  [<ffffffff810e69f5>] ? fput+0x16/0x1c7
[76477.289635]  [<ffffffff810e6888>] ? fget_light+0x92/0x9e
[76477.289643]  [<ffffffff813d77b3>] ? fput_light+0xd/0xf
[76477.289651]  [<ffffffff8108d48b>] ? __rcu_read_unlock+0xc/0x55
[76477.289659]  [<ffffffff810e6888>] ? fget_light+0x92/0x9e
[76477.289668]  [<ffffffff813da1ce>] sys_sendmsg+0x42/0x60
[76477.289678]  [<ffffffff81474b72>] system_call_fastpath+0x16/0x1b


Maybe this tells you something.

> > >	[ 9457.176828] iwlwifi 0000:06:00.0: ACTIVATE a non DRIVER active
> > >station id 0 addr 00:24:c4:ab:bd:e0

These messages now appear only now and then.

Best wishes

Norbert
------------------------------------------------------------------------
Norbert Preining            preining@{jaist.ac.jp, logic.at, debian.org}
JAIST, Japan                                 TeX Live & Debian Developer
DSA: 0x09C5B094   fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
------------------------------------------------------------------------
The fronting for the eighty-yard long marble-topped bar
had been made by stitching together nearly twenty thousand
Antarean Mosaic Lizard skins, despite the fact that the
twenty thousand lizards concerned had needed them to keep
their insides in.
                 --- The Book decribing Milliways' politically incorrect
                 --- decor.
                 --- Douglas Adams, The Hitchhikers Guide to the Galaxy
