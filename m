Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752438Ab2IZXTG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 19:19:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48056 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751119Ab2IZXTD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 19:19:03 -0400
Date: Wed, 26 Sep 2012 20:18:55 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux EDAC Mailing List <linux-edac@vger.kernel.org>,
        Doug Thompson <dougthompson@xmission.com>
Subject: [GIT PULL for v3.6-final] EDAC fixes
Message-ID: <20120926201855.1de686bf@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:
  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-edac.git master

For 3 edac fixes at the memory enumeration logic:
	- i3200_edac: Fixes a regression at the memory rank size, when the
		memorias are dual-rank;
	- i5000_edac: Fix a longstanding bug when calculating the memory
		size: before Kernel 3.6, the memory size were right only
		with one specific configuration;
	- sb_edac: Fixes a bug since the initial release of the driver:
		with 16GB DIMMs, there's an overflow at the memory size,
		causing the number of pages per dimm (an unsigned value)
		to have the highest bit equal to 1, effectively mangling
		the memory size.

The third bug can potentially affect the error decoding logic as well.

Thank you!
Mauro

-

The following changes since commit 979570e02981d4a8fc20b3cc8fd651856c98ee9d:

  Linux 3.6-rc7 (2012-09-23 18:10:57 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-edac.git master

for you to fetch changes up to deb09ddaff1435f72dd598d38f9b58354c68a5ec:

  sb_edac: Avoid overflow errors at memory size calculation (2012-09-25 07:38:20 -0300)

----------------------------------------------------------------
Mauro Carvalho Chehab (3):
      i3200_edac: Fix memory rank size
      i5000: Fix the memory size calculation with 2R memories
      sb_edac: Avoid overflow errors at memory size calculation

 drivers/edac/i3200_edac.c | 2 +-
 drivers/edac/i5000_edac.c | 4 ++++
 drivers/edac/sb_edac.c    | 7 ++++---
 3 files changed, 9 insertions(+), 4 deletions(-)

