Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754554Ab2JHSGf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 14:06:35 -0400
Received: from service87.mimecast.com ([91.220.42.44]:36303 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752582Ab2JHSGd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 14:06:33 -0400
Date: Mon, 8 Oct 2012 19:06:28 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] arm64 fixes
Message-ID: <20121008180628.GC3204@arm.com>
MIME-Version: 1.0
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 08 Oct 2012 18:06:29.0024 (UTC) FILETIME=[A3BEEA00:01CDA57F]
X-MC-Unique: 112100819063105801
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the tag below. There are two fixes and removal of the
arm64-specific compat_sys_sendfile (I pushed the generic implementation
separately and it now got into mainline). Thanks.

The following changes since commit e9eca4de957ac33744fb994ccacd4a5102e445a8:

  Merge tag 'upstream-3.7-rc1-fastmap' of git://git.infradead.org/linux-ubi (2012-10-08 20:40:45 +0900)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/cmarinas/linux-aarch64.git arm64-fixes

for you to fetch changes up to 6916fd086f0c5d7871ad3986300ba30d63616925:

  arm64: Enable interrupts before calling do_notify_resume() (2012-10-08 18:04:21 +0100)

----------------------------------------------------------------
AArch64 fixes:
- Use swiotlb_init() instead of swiotlb_init_with_default_size(). The
  latter is now a static function (commit 74838b7 "swiotlb: add the late
  swiotlb initialization function with iotlb memory").
- Enable interrupts before calling do_notify_resume().

AArch64 clean-up:
- Use the generic implementation of compat_sys_sendfile() on arm64 as
  commit 8f9c0119 (introducing the function) has been merged.

----------------------------------------------------------------
Catalin Marinas (3):
      arm64: Call swiotlb_init() instead of swiotlb_init_with_default_size()
      arm64: Use the generic compat_sys_sendfile() implementation
      arm64: Enable interrupts before calling do_notify_resume()

 arch/arm64/include/asm/unistd32.h |    1 +
 arch/arm64/kernel/entry.S         |    1 +
 arch/arm64/kernel/sys_compat.c    |   20 --------------------
 arch/arm64/mm/dma-mapping.c       |    6 ++----
 arch/arm64/mm/init.c              |    5 +----
 arch/arm64/mm/mm.h                |    1 +
 6 files changed, 6 insertions(+), 28 deletions(-)

