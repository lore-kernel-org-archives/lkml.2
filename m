Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759505Ab0HDXdp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 19:33:45 -0400
Received: from sj-iport-4.cisco.com ([171.68.10.86]:55626 "EHLO
	sj-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759425Ab0HDXdm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 19:33:42 -0400
Authentication-Results: sj-iport-4.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAIuVWUyrR7Hu/2dsb2JhbACgKXGqAJsphTsEhB4
X-IronPort-AV: E=Sophos;i="4.55,318,1278288000"; 
   d="scan'208";a="167623349"
From: Roland Dreier <rdreier@cisco.com>
To: linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: InfiniBand/RDMA merge plans for 2.6.36
X-Message-Flag: Warning: May contain useful information
Date: Wed, 04 Aug 2010 16:33:38 -0700
Message-ID: <adak4o654x9.fsf@roland-alpha.cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since 2.6.35 is here, it's probably a good time to talk about 2.6.36
merge plans.  All the pending things that I'm aware of are listed below.

Boilerplate:

If something isn't already in my tree and it isn't listed below, I
probably missed it or dropped it unintentionally.  Please remind me.

As usual, when submitting a patch:

 - Give a good changelog that explains what issue your patch
   addresses, how you address the issue, how serious the issue is, and
   any other information that would be useful to someone evaluating
   your patch now, or trying to understand it years from now.

 - Please make sure that you include a "Signed-off-by:" line, and put
   any extra junk that should not go into the final kernel log *after*
   the "---" line so that git tools strip it off automatically.  Make
   the subject line be appropriate for inclusion in the kernel log as
   well once the leading "[PATCH ...]" stuff is stripped off.  I waste a
   lot of time fixing patches by hand that could otherwise be spent
   doing something productive like watching youtube.

 - Run your patch through checkpatch.pl so I don't have to nag you to
   fix trivial issues (or spend time fixing them myself).

 - Check your patch over at least enough so I don't see a memory leak
   or deadlock as soon as I look at it.

 - Build your patch with sparse checking ("C=2 CF=-D__CHECK_ENDIAN__")
   and make sure it doesn't introduce new warnings.  (A big bonus in
   goodwill for sending patches that fix old warnings)

 - Test your patch on a kernel with things like slab debugging and
   lockdep turned on.

And while you're waiting for me to get to your patch, I sure wouldn't
mind if you read and commented on someone else's patch.  We currently
have a big imbalance between people who are writing patches (many) and
people who are reviewing patches (mostly me).  None of this means you
shouldn't remind me about pending patches, since I often lose track of
things and drop them accidentally.

I don't think it makes sense to break down what I merged by topics
this time around -- there wasn't anything big that I can think of.  It
was really just a matter of small improvements, fixes, and cleanups
all over.

Here are a few topics I'm tracking that are not ready in time for the
2.6.36 window and will need to wait for 2.6.37 at least:

 - XRC.  While I think we made significant progress here, the fact is
   that this is not ready to merge at the beginning of the merge
   window, and so we'll need to keep working on it and wait for the
   next merge window.  I think this is just blocked on me at the
   moment.

 - IBoE.  Same as XRC; we made significant progress (and I opened an
   iboe branch to track this), and I think we have finally gotten the
   user-kernel interface nailed down yet, but it's just too late.

 - ummunotify-as-part-of-uverbs.  I'm working on this but don't have
   anything ready for the merge window.

 - AF_IB work.  I have not even had a chance to think about this yet,
   since I haven't dug through earlier backlog items.

 - mlx4 SR-IOV support.  See AF_IB above.

Here all the patches I already have in my for-next branch:

Aleksey Senin (1):
      IB: Rename RAW_ETY to RAW_ETHERTYPE

Alexander Schmidt (3):
      IB/ehca: Fix bitmask handling for lock_hcalls
      IB/ehca: Catch failing ioremap()
      IB/ehca: Init irq tasklet before irq can happen

Arnd Bergmann (1):
      IB/qib: Use generic_file_llseek

Bart Van Assche (3):
      IB/srp: Use print_hex_dump()
      IB/srp: Make receive buffer handling more robust
      IB/srp: Export req_lim via sysfs

Ben Hutchings (1):
      IB/ipath: Fix probe failure path

Chien Tung (1):
      RDMA/nes: Store and print eeprom version

Dan Carpenter (2):
      RDMA/cxgb4: Remove unneeded assignment
      RDMA/cxgb3: Clean up signed check of unsigned variable

Dave Olson (1):
      IB/qib: Allow PSM to select from multiple port assignment algorithms

David Rientjes (1):
      RDMA/cxgb4: Remove dependency on __GFP_NOFAIL

Faisal Latif (1):
      RDMA/nes: Fix hangs on ifdown

Ira Weiny (1):
      IB/qib: Allow writes to the diag_counters to be able to clear them

Miroslaw Walukiewicz (1):
      RDMA/nes: Read firmware version from correct place

Or Gerlitz (3):
      IB/iser: Make needlessly global iser_alloc_rx_descriptors() static
      RDMA/cxgb3: Make needlessly global iwch_l2t_send() static
      RDMA/nes: Fix two sparse warnings

Peter Huewe (1):
      RDMA/nes: Convert pci_table entries to PCI_VDEVICE

Ralph Campbell (5):
      IB/qib: Avoid variable-length array
      IB/qib: Turn off IB latency mode
      IB/qib: Set cfgctxts to number of CPUs by default
      IB/qib: Limit the number of packets processed per interrupt
      IB/qib: Fix race between qib_error_qp() and receive packet processing

Roland Dreier (6):
      IB/umad: Remove unused-but-set variable 'already_dead'
      RDMA/nes: Rewrite expression to avoid undefined semantics
      RDMA/cxgb4: Remove unneeded NULL check
      RDMA/nes: Get rid of "set but not used" variables
      RDMA/nes: Fix showing wqm_quanta
      RDMA/nes: Fix misindented code

Sean Hefty (1):
      IB/cm: Check LAP state before sending an MRA

Steve Wise (6):
      RDMA/cxgb4: Add module option to tweak delayed ack
      RDMA/cxgb4: Support variable sized work requests
      RDMA/cxgb4: Fix race in fini path
      RDMA/cxgb4: Use correct control txq
      RDMA/cxgb4: Set/reset the EP timer inside EP lock
      RDMA/cxgb4: Add timeouts when waiting for FW responses
-- 
Roland Dreier <rolandd@cisco.com> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
