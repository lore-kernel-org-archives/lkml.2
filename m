Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754077Ab2HGLIu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 07:08:50 -0400
Received: from tama500.ecl.ntt.co.jp ([129.60.39.148]:50964 "EHLO
	tama500.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751621Ab2HGLIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 07:08:48 -0400
Date: Tue, 7 Aug 2012 20:07:59 +0900
From: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
To: akpm@linux-foundation.org
Cc: bhutchings@solarflare.com, grundler@parisc-linux.org, arnd@arndb.de,
        benh@kernel.crashing.org, avi@redhat.com, mtosatti@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        takuya.yoshikawa@gmail.com
Subject: [PATCH 0/5 - RESEND] Introduce generic set_bit_le()
Message-Id: <20120807200759.26ca8faa.yoshikawa.takuya@oss.ntt.co.jp>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is against today's linux-next.

KVM is using test_and_set_bit_le() for this missing function; this patch
series corrects this usage.

As some drivers have their own definitions of set_bit_le(), a bit of
preparation is also needed.

  Although these are differently implemented, especially for big-endian
  case, than the generic __set_bit_le(), it should not be a problem to
  use the latter since both maintainers prefer it.

Ben Hutchings (1):
  sfc: Use standard __{clear,set}_bit_le() functions

Takuya Yoshikawa (4):
  drivers/net/ethernet/dec/tulip: Use standard __set_bit_le() function
  bitops: Introduce generic {clear,set}_bit_le()
  powerpc: bitops: Introduce {clear,set}_bit_le()
  KVM: Replace test_and_set_bit_le() in mark_page_dirty_in_slot() with set_bit_le()

 arch/powerpc/include/asm/bitops.h           |   10 ++++++++++
 drivers/net/ethernet/dec/tulip/de2104x.c    |    7 ++-----
 drivers/net/ethernet/dec/tulip/tulip_core.c |    7 ++-----
 drivers/net/ethernet/sfc/efx.c              |    4 ++--
 drivers/net/ethernet/sfc/net_driver.h       |   12 ------------
 drivers/net/ethernet/sfc/nic.c              |    4 ++--
 include/asm-generic/bitops/le.h             |   10 ++++++++++
 virt/kvm/kvm_main.c                         |    3 +--
 8 files changed, 29 insertions(+), 28 deletions(-)

-- 
1.7.5.4

