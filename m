Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752634Ab2LKEAS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 23:00:18 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:57715 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751811Ab2LKEAQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 23:00:16 -0500
MIME-Version: 1.0
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 10 Dec 2012 19:59:50 -0800
X-Google-Sender-Auth: ue_zh-c7EX_5Udok8fu_LSrTpUs
Message-ID: <CA+55aFw9N4DTgYfrPCzDNYiL4=0-oi5jXuijHf=QVVeeOxFYrg@mail.gmail.com>
Subject: Linux 3.7
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Whee. After an extra rc release, 3.7 is now out. After a few more
trials at fixing things, in the end we ended up reverting the kswapd
changes that caused problems. And with the extra rc, I had decided to
risk doing the buffer.c cleanups that would otherwise have just been
marked for stable during the next merge window, and had enough time to
fix a few problems that people found there too.

There's also a fix for a SCSI driver bug that was exposed by the
last-minute workqueue fixes in rc8.

Other than that, there's a few networking fixes, and some trivial
fixes for sparc and MIPS.

Anyway, it's been a somewhat drawn out release despite the 3.7 merge
window having otherwise appeared pretty straightforward, and none of
the rc's were all that big either. But we're done, and this means that
the merge window will close on Christmas eve.

Or rather, I'll probably close it a couple of days early. For obvious
reasons. It's the main commercial holiday of the year, after all.

So aim for winter solstice, and no later. Deal? And even then, I might
be deep into the glögg.

                Linus

---

Chris Ball (1):
      Revert misapplied "mmc: sh-mmcif: avoid oops on spurious interrupts"

Dan Carpenter (1):
      vfs: clear to the end of the buffer on partial buffer reads

David Daney (1):
      MIPS: Avoid mcheck by flushing page range in huge_ptep_set_access_flags()

David Howells (2):
      MODSIGN: Don't use enum-type bitfields in module signature info block
      ASN.1: Fix an indefinite length skip error

David S. Miller (2):
      sparc64: exit_group should kill register windows just like plain exit.
      sparc: Fix piggyback with newer binutils.

Dmitry Adamushko (1):
      MIPS: Fix endless loop when processing signals for kernel tasks

Eric Dumazet (1):
      net: gro: fix possible panic in skb_gro_receive()

Florian Fainelli (1):
      Input: matrix-keymap - provide proper module license

Guennadi Liakhovetski (1):
      mmc: sh-mmcif: avoid oops on spurious interrupts (second try)

Heiko Stübner (1):
      mmc: sdhci-s3c: fix missing clock for gpio card-detect

James Hogan (2):
      linux/kernel.h: define SYMBOL_PREFIX
      modsign: add symbol prefix to certificate list

Johannes Berg (1):
      ipv4: ip_check_defrag must not modify skb before unsharing

Johannes Weiner (2):
      mm: vmscan: do not keep kswapd looping forever due to individual
uncompactable zones
      mm: vmscan: fix inappropriate zone congestion clearing

Linus Torvalds (5):
      vfs: avoid "attempt to access beyond end of device" warnings
      vfs: fix O_DIRECT read past end of block device
      Revert "mm: avoid waking kswapd for THP allocations when
compaction is deferred or contended"
      Revert "revert "Revert "mm: remove __GFP_NO_KSWAPD""" and
associated damage
      Linux 3.7

Mel Gorman (2):
      mm: compaction: validate pfn range passed to isolate_freepages_block
      tmpfs: fix shared mempolicy leak

Neal Cardwell (4):
      inet_diag: fix oops for IPv4 AF_INET6 TCP SYN-RECV state
      inet_diag: validate byte code to prevent oops in inet_diag_bc_run()
      inet_diag: avoid unsafe and nonsensical prefix matches in
inet_diag_bc_run()
      inet_diag: validate port comparison byte code to prevent unsafe reads

Ralf Baechle (3):
      MIPS: N32: Fix preadv(2) and pwritev(2) entry points.
      MIPS: N32: Fix signalfd4 syscall entry point
      MIPS: R3000/R3081: Fix CPU detection.

Richard Weinberger (2):
      UBI: remove PEB from free tree in get_peb_for_wl()
      UBI: dont call ubi_self_check_all_ff() in __wl_get_peb()

Tejun Heo (1):
      workqueue: convert BUG_ON()s in __queue_delayed_work() to WARN_ON_ONCE()s

Thomas Gleixner (1):
      watchdog: Fix CPU hotplug regression

Tim Gardner (1):
      lib/Makefile: Fix oid_registry build dependency

Xiaotian Feng (1):
      megaraid: fix BUG_ON() from incorrect use of delayed work

Yuchung Cheng (1):
      tcp: bug fix Fast Open client retransmission
