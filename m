Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752867Ab3ABPiB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 10:38:01 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41353 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752755Ab3ABPh6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 10:37:58 -0500
Date: Wed, 2 Jan 2013 10:37:44 -0500
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Jiri Slaby <jslaby@suse.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: WARNING: at drivers/tty/tty_buffer.c:476  (tty is NULL)
Message-ID: <20130102153744.GC25940@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>, Jiri Slaby <jslaby@suse.cz>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This happened a few times to my test boxes I left running over the holidays..

[ 8419.797533] ------------[ cut here ]------------
[ 8419.798341] WARNING: at drivers/tty/tty_buffer.c:476 flush_to_ldisc+0x1de/0x1f0()
[ 8419.800313] Hardware name: GA-MA78GM-S2H
[ 8419.800887] tty is NULL
[ 8419.801857] Modules linked in: fuse binfmt_misc bnep rfcomm hidp scsi_transport_iscsi can_raw can_bcm ipt_ULOG nfnetlink l2tp_ppp l2tp_core can caif_socket rose nfc caif ipx phonet irda p8023 p8022 netrom rds ax25 atm af_rxrpc crc_ccitt appletalk psnap llc2 af_key decnet llc pppoe pppox ppp_generic x25 slhc lockd sunrpc ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_conntrack nf_conntrack ip6table_filter ip6_tables btusb bluetooth snd_hda_codec_realtek usb_debug rfkill snd_hda_intel snd_hda_codec microcode snd_pcm serio_raw snd_page_alloc pcspkr edac_core snd_timer snd soundcore r8169 mii vhost_net tun macvtap macvlan kvm_amd kvm
[ 8419.811268] Pid: 4980, comm: kworker/0:1 Not tainted 3.8.0-rc1+ #43
[ 8419.812159] Call Trace:
[ 8419.812586]  [<ffffffff81044aef>] warn_slowpath_common+0x7f/0xc0
[ 8419.813504]  [<ffffffff81044be6>] warn_slowpath_fmt+0x46/0x50
[ 8419.814353]  [<ffffffff8132b59a>] ? ___ratelimit+0x9a/0x120
[ 8419.815146]  [<ffffffff813e5a8e>] flush_to_ldisc+0x1de/0x1f0
[ 8419.815982]  [<ffffffff81068a77>] process_one_work+0x207/0x750
[ 8419.816844]  [<ffffffff81068a07>] ? process_one_work+0x197/0x750
[ 8419.817731]  [<ffffffff810b2342>] ? get_lock_stats+0x22/0x70
[ 8419.818605]  [<ffffffff813e58b0>] ? tty_insert_flip_string_fixed_flag+0x110/0x110
[ 8419.819725]  [<ffffffff81069396>] worker_thread+0x156/0x440
[ 8419.820575]  [<ffffffff81069240>] ? rescuer_thread+0x240/0x240
[ 8419.821463]  [<ffffffff8106fd8d>] kthread+0xed/0x100
[ 8419.822174]  [<ffffffff810b27ae>] ? put_lock_stats.isra.23+0xe/0x40
[ 8419.823125]  [<ffffffff8106fca0>] ? kthread_create_on_node+0x160/0x160
[ 8419.824114]  [<ffffffff816a49dc>] ret_from_fork+0x7c/0xb0
[ 8419.824943]  [<ffffffff8106fca0>] ? kthread_create_on_node+0x160/0x160
[ 8419.845167] ---[ end trace 0c3565bace6c005f ]---

