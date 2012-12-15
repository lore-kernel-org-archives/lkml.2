Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756164Ab2LODx1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 22:53:27 -0500
Received: from mailout39.mail01.mtsvc.net ([216.70.64.83]:43220 "EHLO
	n12.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755980Ab2LODx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 22:53:26 -0500
Message-ID: <1355543596.3837.10.camel@thor>
Subject: Re: WARNING: at drivers/tty/tty_buffer.c:476
 flush_to_ldisc+0x1de/0x1f0()
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Dave Jones <davej@redhat.com>, Jiri Slaby <jslaby@suse.cz>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Alan Cox <alan@linux.intel.com>
Date: Fri, 14 Dec 2012 22:53:16 -0500
In-Reply-To: <20121215022918.GC21333@kroah.com>
References: <20121212030124.GA10828@redhat.com>
	 <20121215022918.GC21333@kroah.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.4-0build1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Authenticated-User: 125194 peter@hurleysoftware.com
X-MT-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
X-MT-INTERNAL-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-12-14 at 18:29 -0800, Greg Kroah-Hartman wrote:
> On Tue, Dec 11, 2012 at 10:01:24PM -0500, Dave Jones wrote:
> > Fuzz-testing fallout from post 3.7 tree as of commit 414a6750e59b0b687034764c464e9ddecac0f7a6
> > 
> > [ 2181.230579] ------------[ cut here ]------------
> > [ 2181.231277] WARNING: at drivers/tty/tty_buffer.c:476 flush_to_ldisc+0x1de/0x1f0()
> > [ 2181.232358] Hardware name: GA-MA78GM-S2H
> > [ 2181.232925] tty is NULL
> > [ 2181.233430] Modules linked in: l2tp_ppp l2tp_core fuse rfcomm binfmt_misc hidp bnep scsi_transport_iscsi ipt_ULOG nfnetlink rose ipx p8023 p8022 caif_socket caif af_rxrpc x25 irda af_key appletalk pppoe netrom pppox ppp_generic decnet phonet slhc psnap crc_ccitt ax25 llc2 rds atm llc nfc can nfsv3 nfs_acl nfs fscache lockd sunrpc ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_conntrack nf_conntrack ip6table_filter ip6_tables snd_hda_codec_realtek btusb snd_hda_intel bluetooth usb_debug snd_hda_codec microcode snd_pcm serio_raw pcspkr snd_page_alloc snd_timer edac_core snd soundcore r8169 mii vhost_net tun macvtap macvlan kvm_amd kvm
> > [ 2181.245632] Pid: 29787, comm: kworker/0:1 Not tainted 3.7.0+ #12
> > [ 2181.246503] Call Trace:
> > [ 2181.246851]  [<ffffffff8104da4f>] warn_slowpath_common+0x7f/0xc0
> > [ 2181.247725]  [<ffffffff8104db46>] warn_slowpath_fmt+0x46/0x50
> > [ 2181.248558]  [<ffffffff8132e6ba>] ? ___ratelimit+0x9a/0x120
> > [ 2181.249347]  [<ffffffff813e897e>] flush_to_ldisc+0x1de/0x1f0
> > [ 2181.250164]  [<ffffffff81071237>] process_one_work+0x207/0x750
> > [ 2181.251013]  [<ffffffff810711c7>] ? process_one_work+0x197/0x750
> > [ 2181.251893]  [<ffffffff8106de50>] ? destroy_work_on_stack+0x20/0x20
> > [ 2181.252809]  [<ffffffff813e87a0>] ? tty_insert_flip_string_fixed_flag+0x110/0x110
> > [ 2181.253993]  [<ffffffff81071b56>] worker_thread+0x156/0x440
> > [ 2181.254815]  [<ffffffff81071a00>] ? rescuer_thread+0x240/0x240
> > [ 2181.255638]  [<ffffffff810784bd>] kthread+0xed/0x100
> > [ 2181.256374]  [<ffffffff810b80ce>] ? put_lock_stats.isra.23+0xe/0x40
> > [ 2181.257290]  [<ffffffff810783d0>] ? kthread_create_on_node+0x160/0x160
> > [ 2181.258223]  [<ffffffff816a8ddc>] ret_from_fork+0x7c/0xb0
> > [ 2181.259018]  [<ffffffff810783d0>] ? kthread_create_on_node+0x160/0x160
> > [ 2181.259969] ---[ end trace 12dd9f01acd7e09f ]---
> 
> Jiri, I thought we resolved these warnings in the linux-next tree, how
> are they still showing up?

Greg, that's what the series that I just sent v2 of fixes. Look for
"[PATCH v2 0/11] tty: Fix buffer work access-after-free" et al.

I tried to get it done sooner but got waylaid by GP fault in SLUB caused
by nouveau (solved) and page allocation exhaustion in -next on 10gb
machine (not solved). That and some frustration with getting netconsole
running with kvm (solved).

Dave, how do you have your trinity command line + kvm configured? I had
to write a test jig to get this to happen but I'd prefer to reproduce it
in trinity.

Regards,
Peter Hurley

