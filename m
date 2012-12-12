Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751944Ab2LLHTh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 02:19:37 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46476 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750987Ab2LLHTg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 02:19:36 -0500
Date: Wed, 12 Dec 2012 16:19:23 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] regmap updates for v3.8
Message-ID: <20121212071922.GE30719@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Cookie: You're at the end of the road again.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 9489e9dcae718d5fde988e4a684a0f55b5f94d17:

  Linux 3.7-rc7 (2012-11-25 17:59:19 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regmap.git tags/regmap-3.8

for you to fetch changes up to 7c8a2994309214cbb6dba33cd72ec85f91fd6fcd:

  Merge remote-tracking branch 'regmap/topic/type' into regmap-next (2012-12-11 12:39:49 +0900)

----------------------------------------------------------------

regmap: Updates for v3.8

Quite a few enhancements this time around, helpers and diagnostics for
the most part which is good to see:

- Addition of table based lookups for the register access checks from
  Davide Ciminaghi, making life easier for drivers with big blocks of
  similar registers.
- Allow drivers to get the irqdomain for regmap irq_chips, allowing the
  domain to be used with other APIs.
- Debug improvements for paged register maps.
- Performance improvments for some of the diagnostic infrastructure,
  very helpful for devices with large register maps.

----------------------------------------------------------------
Davide Ciminaghi (2):
      regmap: make lock/unlock functions customizable
      regmap: introduce tables for readable/writeable/volatile/precious checks

Fabio Estevam (1):
      regmap: Fix printing of size_t variable

Mark Brown (22):
      regmap: irq: Allow users to retrieve the irq_domain
      regmap: Rename n_ranges to num_ranges
      regmap: When we sanity check during range adds say what errors we find
      regmap: Allow ranges to be named
      regmap: Factor out debugfs register read
      regmap: Provide debugfs read of register ranges
      regmap: Factor range lookup out of page selection
      regmap: Make return code checks consistent
      regmap: Split raw writes that cross window boundaries
      regmap: core: Report registers in hex when we can't cache
      Merge branches 'topic/core' and 'topic/range' of git://git.kernel.org/.../broonie/regmap into regmap-table
      Merge branch 'topic/lock' of git://git.kernel.org/.../broonie/regmap into regmap-table
      regmap: Cache register and value sizes for debugfs
      regmap: debugfs: Avoid overflows for very small reads
      regmap: debugfs: Factor out initial seek
      regmap: debugfs: Cache offsets of valid regions for dump
      Merge remote-tracking branch 'regmap/topic/core' into regmap-next
      Merge remote-tracking branch 'regmap/topic/debugfs' into regmap-next
      Merge remote-tracking branch 'regmap/topic/domain' into regmap-next
      Merge remote-tracking branch 'regmap/topic/lock' into regmap-next
      Merge remote-tracking branch 'regmap/topic/table' into regmap-next
      Merge remote-tracking branch 'regmap/topic/type' into regmap-next

Paul Bolle (1):
      regmap: silence GCC warning

 drivers/base/regmap/internal.h       |   24 ++-
 drivers/base/regmap/regmap-debugfs.c |  148 +++++++++++++++++--
 drivers/base/regmap/regmap-irq.c     |   19 +++
 drivers/base/regmap/regmap.c         |  269 ++++++++++++++++++++++++----------
 include/linux/regmap.h               |   95 +++++++++++-
 5 files changed, 453 insertions(+), 102 deletions(-)
