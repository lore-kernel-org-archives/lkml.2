Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932660Ab2JCXKs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 19:10:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59749 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932497Ab2JCXKr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 19:10:47 -0400
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 0/2] UAPI: Extra preparatory patches
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Date: Thu, 04 Oct 2012 00:10:44 +0100
Message-ID: <20121003231044.19239.81961.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

I have here a couple of extra preparatory patches for you that I discovered
were necessary today:

 (1) Remove reinclusion guards from certain asm/unistd.h files that were
     overriding the guard if __SYSCALL was defined, eg:

	#if defined(__ASM_UNISTD_H) || defined(__SYSCALL)

     The macro __SYSCALL is defined within and not then undef'd, thus
     rendering the guard ineffective.

     Clearly these guards are unnecessary, so drop them entirely for the
     moment.  We may want to add them back later, but it makes my scripts much
     easier to handle by virtue of simplifying the logic.

 (2) Break apart some cpp conditionals that got added with the arm64 arch that
     are of the form:

	defined(__KERNEL__) && defined(X)

     Splitting these into two separate nested conditionals makes scripting
     easier.

David
---
David Howells (2):
      UAPI: Split compound conditionals containing __KERNEL__ in Arm64
      UAPI: Fix the guards on various asm/unistd.h files


 arch/arm64/include/asm/hwcap.h      |    4 +++-
 arch/arm64/include/asm/stat.h       |    4 +++-
 arch/arm64/include/asm/unistd.h     |    8 +++-----
 arch/arm64/include/asm/unistd32.h   |    4 ----
 arch/c6x/include/asm/unistd.h       |    4 ----
 arch/hexagon/include/asm/unistd.h   |    5 -----
 arch/openrisc/include/asm/unistd.h  |    5 -----
 arch/score/include/asm/unistd.h     |    5 -----
 arch/tile/include/asm/unistd.h      |    5 -----
 arch/unicore32/include/asm/unistd.h |    4 ----
 include/asm-generic/unistd.h        |    4 ----
 11 files changed, 9 insertions(+), 43 deletions(-)

