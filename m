Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932836Ab1IOKrY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 06:47:24 -0400
Received: from krak.alatek.krakow.pl ([46.170.108.42]:3635 "EHLO
	krak.alatek.krakow.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932575Ab1IOKrW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 06:47:22 -0400
From: Pawel Sikora <pluto@agmk.net>
To: Lin Ming <mlin@ss.pku.edu.cn>
Cc: Andrew Morton <akpm@google.com>, Eric Dumazet <eric.dumazet@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>,
        Dave Chinner <david@fromorbit.com>, Hugh Dickins <hughd@google.com>,
        Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: [BUG] infinite loop in find_get_pages()
Date: Thu, 15 Sep 2011 12:47:12 +0200
Message-ID: <3669551.Uo4Qe4YO2W@pawels>
User-Agent: KMail/4.7.1 (Linux/3.0.4-2; KDE/4.7.1; x86_64; ; )
In-Reply-To: <CAF1ivSbCb-eS=npyHO+iWuAXfKPjnCD+LZDWQQ9SbTxGg3nq7Q@mail.gmail.com>
References: <1315941801.2565.19.camel@edumazet-laptop> <20110913165344.1d800582.akpm@google.com> <CAF1ivSbCb-eS=npyHO+iWuAXfKPjnCD+LZDWQQ9SbTxGg3nq7Q@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 14 of September 2011 08:34:21 Lin Ming wrote:

> [3.0.2-stable] BUG: soft lockup - CPU#13 stuck for 22s! [kswapd2:1092]
> http://marc.info/?l=linux-kernel&m=131469584117857&w=2

Hi,

i'm not sure that this is fully related to this thread but i've found
new warnings about memory pages in dmesg today:

[650697.716481] ------------[ cut here ]------------
[650697.716498] WARNING: at mm/page-writeback.c:1176 __set_page_dirty_nobuffers+0x10a/0x140()
[650697.716501] Hardware name: H8DGU
[650697.716502] Modules linked in: nfs fscache binfmt_misc nfsd lockd nfs_acl auth_rpcgss sunrpc ipmi_si ipmi_devintf ipmi_msghandler sch_sfq iptable_nat nf_nat nf_conntrack_ipv4 
nf_conntrack nf_defrag_ipv4 iptable_filter xt_TCPMSS xt_tcpudp iptable_mangle ip_tables ip6table_filter ip6_tables x_tables ext4 jbd2 crc16 raid10 raid0 dm_mod uvesafb autofs4 
dummy aoe joydev usbhid hid ide_cd_mod cdrom ata_generic pata_acpi pata_atiixp sp5100_tco ohci_hcd ide_pci_generic ssb ehci_hcd pcmcia igb pcmcia_core psmouse mmc_core evdev 
i2c_piix4 atiixp ide_core k10temp usbcore amd64_edac_mod edac_core i2c_core dca hwmon edac_mce_amd ghes serio_raw button hed processor pcspkr sg sd_mod crc_t10dif raid1 md_mod ext3 
jbd mbcache ahci libahci libata scsi_mod [last unloaded: scsi_wait_scan]
[650697.716569] Pid: 16806, comm: m_xilinx Not tainted 3.0.4 #5
[650697.716572] Call Trace:
[650697.716582]  [<ffffffff810470da>] warn_slowpath_common+0x7a/0xb0
[650697.716586]  [<ffffffff81047125>] warn_slowpath_null+0x15/0x20
[650697.716590]  [<ffffffff810e71ba>] __set_page_dirty_nobuffers+0x10a/0x140
[650697.716596]  [<ffffffff81127eb8>] migrate_page_copy+0x1c8/0x1d0
[650697.716600]  [<ffffffff81127ef5>] migrate_page+0x35/0x50
[650697.716623]  [<ffffffffa04b6f19>] nfs_migrate_page+0x59/0xf0 [nfs]
[650697.716627]  [<ffffffff81127fb9>] move_to_new_page+0xa9/0x260
[650697.716630]  [<ffffffff811286bd>] migrate_pages+0x3fd/0x4c0
[650697.716635]  [<ffffffff8142988e>] ? apic_timer_interrupt+0xe/0x20
[650697.716641]  [<ffffffff8111cbf0>] ? ftrace_define_fields_mm_compaction_isolate_template+0x70/0x70
[650697.716645]  [<ffffffff8111d5da>] compact_zone+0x52a/0x8c0
[650697.716649]  [<ffffffff8111dade>] compact_zone_order+0x7e/0xb0
[650697.716653]  [<ffffffff8111dbcd>] try_to_compact_pages+0xbd/0xf0
[650697.716657]  [<ffffffff810e5148>] __alloc_pages_direct_compact+0xa8/0x180
[650697.716661]  [<ffffffff810e588d>] __alloc_pages_nodemask+0x66d/0x7f0
[650697.716667]  [<ffffffff8110a92d>] ? page_add_new_anon_rmap+0x9d/0xb0
[650697.716671]  [<ffffffff8111b865>] alloc_pages_vma+0x95/0x180
[650697.716676]  [<ffffffff8112c2f8>] do_huge_pmd_anonymous_page+0x138/0x310
[650697.716680]  [<ffffffff81102ace>] handle_mm_fault+0x21e/0x310
[650697.716685]  [<ffffffff81424bed>] do_page_fault+0x11d/0x4e0
[650697.716688]  [<ffffffff811077a7>] ? do_mmap_pgoff+0x357/0x370
[650697.716692]  [<ffffffff8110790d>] ? sys_mmap_pgoff+0x14d/0x220
[650697.716697]  [<ffffffff811371b8>] ? do_sys_open+0x168/0x1d0
[650697.716701]  [<ffffffff81421d5f>] page_fault+0x1f/0x30
[650697.716704] ---[ end trace 4255de435c6def21 ]---

BR,
Paweł.

