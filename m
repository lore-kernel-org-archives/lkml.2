Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754466Ab1H2R2h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 13:28:37 -0400
Received: from claw.goop.org ([74.207.240.146]:34093 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750948Ab1H2R2f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 13:28:35 -0400
Message-ID: <4E5BCC40.3030501@goop.org>
Date: Mon, 29 Aug 2011 10:28:32 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110816 Thunderbird/6.0
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Subject: [GIT PULL] ticketlock + cmpxchg cleanups
X-Enigmail-Version: 1.3.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is the final version of the ticketlock+cmpxchg series.  I dropped
the cmpxchg_flag() stuff, since it is not a clear win and not really
germane to the rest of the series.

Thanks,
    J

The following changes since commit 61c4f2c81c61f73549928dfd9f3e8f26aa36a8cf:

  Linux 2.6.39 (2011-05-18 21:06:34 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/jeremy/xen.git upstream/ticketlock-cleanup

Jeremy Fitzhardinge (10):
      x86/cmpxchg: linux/alternative.h has LOCK_PREFIX
      x86/cmpxchg: move 32-bit __cmpxchg_wrong_size to match 64 bit.
      x86/cmpxchg: move 64-bit set64_bit() to match 32-bit
      x86/cmpxchg: unify cmpxchg into cmpxchg.h
      x86: add xadd helper macro
      x86: use xadd helper more widely
      x86/ticketlock: clean up types and accessors
      x86/ticketlock: convert spin loop to C
      x86/ticketlock: convert __ticket_spin_lock to use xadd()
      x86/ticketlock: make __ticket_spin_trylock common

 arch/x86/include/asm/atomic.h         |    8 +-
 arch/x86/include/asm/atomic64_64.h    |    6 +-
 arch/x86/include/asm/cmpxchg.h        |  198 +++++++++++++++++++++++++++++++++
 arch/x86/include/asm/cmpxchg_32.h     |  114 -------------------
 arch/x86/include/asm/cmpxchg_64.h     |  131 ----------------------
 arch/x86/include/asm/rwsem.h          |    8 +-
 arch/x86/include/asm/spinlock.h       |  110 +++++--------------
 arch/x86/include/asm/spinlock_types.h |   22 ++++-
 arch/x86/include/asm/uv/uv_bau.h      |    6 +-
 9 files changed, 250 insertions(+), 353 deletions(-)


