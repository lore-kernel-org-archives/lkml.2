Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753482Ab1DSQOY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 12:14:24 -0400
Received: from hiauly1.hia.nrc.ca ([132.246.10.84]:3913 "EHLO
	hiauly1.hia.nrc.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753250Ab1DSQOW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 12:14:22 -0400
X-Greylist: delayed 493 seconds by postgrey-1.27 at vger.kernel.org; Tue, 19 Apr 2011 12:14:22 EDT
Subject: Re: [PATCH v3] mm: make expand_downwards symmetrical to
To: James.Bottomley@HansenPartnership.com (James Bottomley)
Date: Tue, 19 Apr 2011 12:06:06 -0400 (EDT)
From: "John David Anglin" <dave@hiauly1.hia.nrc.ca>
Cc: mhocko@suse.cz, akpm@linux-foundation.org, hughd@google.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-parisc@vger.kernel.org
In-Reply-To: <1303228009.3171.18.camel@mulgrave.site> from "James Bottomley" at Apr 19, 2011 10:46:49 am
X-Mailer: ELM [version 2.4 PL25]
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Message-Id: <20110419160606.932084E6A@hiauly1.hia.nrc.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> It compiles OK, but crashes on boot in fsck.  The crash is definitely mm
> but looks to be a slab problem (it's a null deref on a spinlock in
> add_partial(), which seems unrelated to this patch).

I had a somewhat similar crash Sunday with the "debian" config building GCC.
This is with 2.6.39-rc3+  without the mm patch:

mx3210 login: [12244.664000] Backtrace:
[12244.664000]  [<000000004020c9a0>] __slab_free+0x100/0x200
[12244.664000]  [<000000004020d23c>] kmem_cache_free+0xf4/0x108
[12244.668000]  [<000000001c7e9efc>] __journal_remove_journal_head+0x214/0x248 [
jbd]
[12244.668000]  [<000000001c7edd48>] journal_put_journal_head+0xc8/0x168 [jbd]
[12244.668000]  [<000000001c7e158c>] journal_invalidatepage+0x45c/0x710 [jbd]
[12244.672000]  [<000000001c8652d8>] ext3_invalidatepage+0x88/0xe8 [ext3]
[12244.672000]  [<00000000401d76f4>] do_invalidatepage+0x34/0x40
[12244.672000]  [<00000000401d7770>] truncate_inode_page+0x70/0x178
[12244.676000]  [<00000000401d798c>] truncate_inode_pages_range+0x114/0x518
[12244.676000]  [<00000000401d7da4>] truncate_inode_pages+0x14/0x20
[12244.680000]  [<000000001c86ac1c>] ext3_evict_inode+0x64/0x2a8 [ext3]
[12244.680000]  [<0000000040234424>] evict+0xac/0x1c8

[12244.692000] PSW: 00001000000001101111001100001110 Not tainted
[12244.692000] r00-03  000000ff0806f30e 0000000040745e50 000000004020c9a0 000000
01453d6000
[12244.692000] r04-07  0000000040722e50 0000000000000000 00000002bf400000 000000
001c7dc000
[12244.696000] r08-11  0000000000000002 0000000040630298 0000000000000001 000000
007bba4940
[12244.696000] r12-15  00000002bf400000 0000000000000001 0000000000000000 000000
0000000001
[12244.700000] r16-19  000000007e71d888 000000007e71d888 0000000000001000 200000
0000000081
[12244.700000] r20-23  0000000000000000 0000000040630290 0000000000000001 000000
001c7e9efc
[12244.704000] r24-27  000000000800000e 00000001453d6000 0000000000000000 000000
0040722e50
[12244.704000] r28-31  0000000000000001 000000007bba4b70 000000007bba4ba0 000000
0000000023
[12244.708000] sr00-03  000000000556c000 000000000556c000 0000000000000000 000000000556c000
[12244.708000] sr04-07  0000000000000000 0000000000000000 0000000000000000 0000000000000000

[12244.712000]
[12244.712000] IASQ: 0000000000000000 0000000000000000 IAOQ: 000000004011b240 000000004011b244
[12244.712000]  IIR: 0f4015dc    ISR: 0000000000000000  IOR: 0000000000000000
[12244.716000]  CPU:        3   CR30: 000000007bba4000 CR31: ffffffffffffffff
[12244.716000]  ORIG_R28: 0000000000000001
[12244.720000]  IAOQ[0]: _raw_spin_lock+0x10/0x20
[12244.720000]  IAOQ[1]: _raw_spin_lock+0x14/0x20
[12244.720000]  RP(r2): __slab_free+0x100/0x200

Dave
-- 
J. David Anglin                                  dave.anglin@nrc-cnrc.gc.ca
National Research Council of Canada              (613) 990-0752 (FAX: 952-6602)
