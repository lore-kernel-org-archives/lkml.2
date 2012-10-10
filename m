Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751523Ab2JJE1M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 00:27:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49056 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751027Ab2JJE1K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 00:27:10 -0400
Date: Wed, 10 Oct 2012 00:26:56 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Jiri Slaby <jslaby@suse.cz>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: ODEBUG: free active (active state 0) object type: work_struct hint:
 flush_to_ldisc+0x0/0x1a0
Message-ID: <20121010042656.GA32075@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Jiri Slaby <jslaby@suse.cz>, Alan Cox <alan@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just hit this..

WARNING: at lib/debugobjects.c:261 debug_print_object+0x8c/0xb0()
ODEBUG: free active (active state 0) object type: work_struct hint: flush_to_ldisc+0x0/0x1a0
Modules linked in: fuse ipt_ULOG nfnetlink tun binfmt_misc nfc caif_socket caif phonet can llc2 pppoe pppox ppp_generic slhc irda crc_ccitt rds af_key decnet rose x25 atm netrom appletalk ipx p8023 psnap p8022 llc ax25 lockd sunrpc bluetooth rfkill ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables kvm_intel usb_debug kvm crc32c_intel ghash_clmulni_intel microcode pcspkr i2c_i801 e1000e uinput i915 video i2c_algo_bit drm_kms_helper drm i2c_core
Pid: 23707, comm: kworker/3:0 Not tainted 3.6.0+ #26
Call Trace:
 [<ffffffff8107005f>] warn_slowpath_common+0x7f/0xc0
 [<ffffffff81070156>] warn_slowpath_fmt+0x46/0x50
 [<ffffffff813728fc>] debug_print_object+0x8c/0xb0
 [<ffffffff8141c200>] ? tty_insert_flip_string_fixed_flag+0x100/0x100
 [<ffffffff81373699>] debug_check_no_obj_freed+0x119/0x210
 [<ffffffff814122c6>] ? free_tty_struct+0x46/0x50
 [<ffffffff811cd166>] kfree+0xe6/0x340
 [<ffffffff814122c6>] free_tty_struct+0x46/0x50
 [<ffffffff81412377>] release_one_tty+0xa7/0xc0
 [<ffffffff81094bc7>] process_one_work+0x207/0x770
 [<ffffffff81094b57>] ? process_one_work+0x197/0x770
 [<ffffffff814122d0>] ? free_tty_struct+0x50/0x50
 [<ffffffff8109550e>] worker_thread+0x15e/0x440
 [<ffffffff810953b0>] ? rescuer_thread+0x240/0x240
 [<ffffffff8109c25d>] kthread+0xed/0x100
 [<ffffffff816bdcd9>] ? sub_preempt_count+0x79/0xd0
 [<ffffffff816c34a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff810aa29c>] ? finish_task_switch+0x7c/0x120
 [<ffffffff816b92bb>] ? _raw_spin_unlock_irq+0x4b/0x80
 [<ffffffff816b9d37>] ? retint_restore_args+0x13/0x13
 [<ffffffff8109c170>] ? kthread_create_on_node+0x160/0x160
 [<ffffffff816c34a0>] ? gs_change+0x13/0x13
---[ end trace fbabf37a8756c1c9 ]---

