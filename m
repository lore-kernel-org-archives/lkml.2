Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752481Ab1JWKQj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Oct 2011 06:16:39 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:36205 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041Ab1JWKQh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Oct 2011 06:16:37 -0400
MIME-Version: 1.0
In-Reply-To: <1633484.nypxIFiqdQ@pawels>
References: <1633484.nypxIFiqdQ@pawels>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 23 Oct 2011 13:16:15 +0300
X-Google-Sender-Auth: xJcHaR1HnXJnjPNIcnw0lAVIlrs
Message-ID: <CA+55aFzggUcGK_uso0dYb6r5egNtnkzifMzLUywA72JhQ9JSxw@mail.gmail.com>
Subject: Re: WARNING: at fs/dcache.c:2549 prepend_path+0x164/0x170() [Root
 dentry has weird name <>]
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>,
        David Howells <dhowells@redhat.com>, Jeff Layton <jlayton@redhat.com>,
        Pawel Sikora <pluto@agmk.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al, any idea on this one?

mnt->mnt_parent should equal mnt only for a root dentry, but detaching
mount-points and mnt_clone() ends up doing it too, so maybe there is
some way where that "global_root" test triggers on a dentry that
hasn't been allocated with d_alloc_root().

I wonder how useful that warning is at all.

                      Linus

On Thu, Oct 20, 2011 at 5:49 PM, Pawel Sikora <pluto@agmk.net> wrote:
> Hi,
>
> during the 3.0.6 kernel stressing on dual-opteron machine i've noticed warnings in dmesg.
> bugzilla.kernel.org is down currently, so i'm CCing last fs/dcache.c commiters.
> i hope that this shortlog will help you.
>
> BR,
> Paweł.
>
> (...)
> Oct 14 15:52:36 odra kernel: [   18.710510] igb: eth1 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
> Oct 14 15:52:36 odra kernel: [   18.713039] ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
> Oct 14 15:52:39 odra kernel: [   21.885578] FS-Cache: Loaded
> Oct 14 15:52:39 odra kernel: [   21.898297] Registering the id_resolver key type
> Oct 14 15:52:39 odra kernel: [   21.898325] FS-Cache: Netfs 'nfs' registered for caching
> Oct 14 15:52:59 odra kernel: [   26.110041] eth0: no IPv6 routers present
> Oct 14 15:53:02 odra kernel: [   29.363344] eth1: no IPv6 routers present
> Oct 15 11:06:50 odra kernel: [69257.064455] process `sysctl' is using deprecated sysctl (syscall) net.ipv6.neigh.default.retrans_time; Use net.ipv6.neigh.default.retrans_time_ms instead.
> Oct 18 19:40:36 odra kernel: [359283.045721] ------------[ cut here ]------------
> Oct 18 19:40:36 odra kernel: [359283.045731] WARNING: at fs/dcache.c:2549 prepend_path+0x164/0x170()
> Oct 18 19:40:36 odra kernel: [359283.045734] Hardware name: H8DGU
> Oct 18 19:40:36 odra kernel: [359283.045736] Root dentry has weird name <>
> Oct 18 19:40:36 odra kernel: [359283.045737] Modules linked in: nfs fscache binfmt_misc nfsd lockd exportfs nfs_acl auth_rpcgss sunrpc ipmi_si ipmi_devintf ipmi_msghandler sch_sfq iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 iptable_filter xt_TCPMSS xt_tcpudp iptable_mangle ip_tables ip6table_filter ip6_tables x_tables ext4 jbd2 crc16 raid0 dm_mod autofs4 dummy usbhid hid ide_cd_mod cdrom ata_generic pata_acpi ohci_hcd pata_atiixp ide_pci_generic ssb pcmcia sp5100_tco pcmcia_core ehci_hcd amd64_edac_mod pcspkr edac_core evdev mmc_core atiixp igb i2c_piix4 i2c_core ide_core edac_mce_amd processor ghes usbcore psmouse serio_raw button k10temp hed hwmon dca sg sd_mod crc_t10dif raid1 md_mod ext3 jbd mbcache ahci libahci libata scsi_mod [last unloaded: scsi_wait_scan]
> Oct 18 19:40:36 odra kernel: [359283.045799] Pid: 8349, comm: pidof Not tainted 3.0.6-dirty #2
> Oct 18 19:40:36 odra kernel: [359283.045802] Call Trace:
> Oct 18 19:40:36 odra kernel: [359283.045812]  [<ffffffff8104718a>] warn_slowpath_common+0x7a/0xb0
> Oct 18 19:40:36 odra kernel: [359283.045817]  [<ffffffff81047261>] warn_slowpath_fmt+0x41/0x50
> Oct 18 19:40:36 odra kernel: [359283.045822]  [<ffffffff81415c74>] ? __slab_free+0xfc/0x105
> Oct 18 19:40:36 odra kernel: [359283.045825]  [<ffffffff8114bac4>] prepend_path+0x164/0x170
> Oct 18 19:40:36 odra kernel: [359283.045829]  [<ffffffff8114bb27>] path_with_deleted+0x57/0xa0
> Oct 18 19:40:36 odra kernel: [359283.045831]  [<ffffffff8114bc21>] d_path+0xb1/0xe0
> Oct 18 19:40:36 odra kernel: [359283.045837]  [<ffffffff811906db>] proc_pid_readlink+0x8b/0xf0
> Oct 18 19:40:36 odra kernel: [359283.045841]  [<ffffffff8113baa6>] sys_readlinkat+0xa6/0xb0
> Oct 18 19:40:36 odra kernel: [359283.045844]  [<ffffffff8113bac6>] sys_readlink+0x16/0x20
> Oct 18 19:40:36 odra kernel: [359283.045849]  [<ffffffff81421f7b>] system_call_fastpath+0x16/0x1b
> Oct 18 19:40:36 odra kernel: [359283.045851] ---[ end trace b5522e2b9acb171d ]---
> (...)
>
>
