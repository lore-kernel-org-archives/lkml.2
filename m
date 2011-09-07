Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756675Ab1IGSoL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 14:44:11 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:32932 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752194Ab1IGSoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 14:44:09 -0400
Date: Wed, 7 Sep 2011 11:44:03 -0700
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PULL] regmap fix for 3.1
Message-ID: <20110907184402.GB4423@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Cookie: So you're back... about time...
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 9e79e3e9dd9672b37ac9412e9a926714306551fe:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/sparc (2011-08-30 11:28:18 -0700)

are available in the git repository at:

  git://opensource.wolfsonmicro.com/regmap.git for-linus

We had some module_put() calls that didn't match any module_get() left
lying around from an earlier version of the regmap API which broke
module unload and error paths.  This hadn't been noticed as most of the
usage so far had been with PMICs which can't be unloaded.

Mark Brown (1):
      regmap: Remove bitrotted module_put()s

 drivers/base/regmap/regmap.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)
