Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753678Ab2LREQK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 23:16:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:14103 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753214Ab2LREQI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 23:16:08 -0500
Date: Mon, 17 Dec 2012 22:20:28 -0500
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Andreas Herrmann <andreas.herrmann3@amd.com>
Subject: mutex warning in intel_cacheinfo.c:cpu_list_show
Message-ID: <20121218032028.GA5896@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Andreas Herrmann <andreas.herrmann3@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(At least I think that's where 'cpu_list_show' comes from...
 those preprocessor tricks confuse ctags)

Just started seeing this today..
(fwiw, cpu is a Phenom(tm) 9750)

	Dave

WARNING: at kernel/mutex.c:198 mutex_lock_nested+0x39c/0x3b0()
Hardware name: GA-MA78GM-S2H
Modules linked in: hidp fuse l2tp_ppp l2tp_core bnep rfcomm binfmt_misc phonet rose af_key nfnetlink caif_socket caif ipt_ULOG af_rxrpc netrom appletalk ax25 can ipx p8023 rds psnap nfc p8022 atm scsi_transport_iscsi pppoe pppox ppp_generic llc2 irda decnet slhc llc x25 crc_ccitt nfsv3 nfs_acl nfs fscache lockd sunrpc ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_conntrack nf_conntrack ip6table_filter ip6_tables snd_hda_codec_realtek microcode snd_hda_intel btusb snd_hda_codec bluetooth serio_raw usb_debug snd_pcm pcspkr snd_page_alloc snd_timer snd edac_core soundcore r8169 mii vhost_net tun macvtap macvlan kvm_amd kvm
Pid: 667, comm: trinity-child2 Not tainted 3.7.0+ #25
Call Trace:
 [<ffffffff81045cff>] warn_slowpath_common+0x7f/0xc0
 [<ffffffff81045d5a>] warn_slowpath_null+0x1a/0x20
 [<ffffffff816a04ec>] mutex_lock_nested+0x39c/0x3b0
 [<ffffffff81164bd5>] ? cpu_list_show+0x35/0x70
 [<ffffffff81164bd5>] ? cpu_list_show+0x35/0x70
 [<ffffffff81233e1b>] ? sysfs_read_file+0x8b/0x1c0
 [<ffffffff81164bd5>] cpu_list_show+0x35/0x70
 [<ffffffff814370a0>] dev_attr_show+0x20/0x60
 [<ffffffff81233e1b>] ? sysfs_read_file+0x8b/0x1c0
 [<ffffffff81233e47>] sysfs_read_file+0xb7/0x1c0
 [<ffffffff811b575c>] vfs_read+0xac/0x180
 [<ffffffff811b5a0a>] sys_pread64+0x9a/0xb0
 [<ffffffff816ab682>] system_call_fastpath+0x16/0x1b
 [<ffffffffa0000001>] ? ack_flush+0x1/0x10 [kvm]
---[ end trace 6d0328611cb687b5 ]---

