Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933164Ab2DLBHd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 21:07:33 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:40036 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761666Ab2DLBHc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 21:07:32 -0400
From: Mike Turquette <mturquette@linaro.org>
To: <arnd.bergmann@linaro.org>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linaro-dev@lists.linaro.org>, <patches@linaro.org>,
        Mike Turquette <mturquette@linaro.org>
Subject: [PATCH 00/13] common clk framework misc fixes
Date: Wed, 11 Apr 2012 18:02:38 -0700
Message-ID: <1334192572-12499-1-git-send-email-mturquette@linaro.org>
X-Mailer: git-send-email 1.7.5.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series collects many of the fixes posted for the recently merged
common clock framework as well as some general clean-up.  Most of the
code classifies as a clean-up moreso than a bug fix; hopefully this is
not a problem since the common clk framework is new code pulled for 3.4.

Patches are based on v3.4-rc2 and can be pulled from:
git://git.linaro.org/people/mturquette/linux.git v3.4-rc2-clk-fixes

Please let me know I missed any critical fixes that were posted to the
list already.

Arnd & Olof, if there are no objections to these changes can this get
pulled through the arm-soc tree?

Thanks,
Mike

Mark Brown (2):
  clk: Remove comment for end of CONFIG_COMMON_CLK section
  clk: Constify parent name arrays

Mike Turquette (6):
  clk: core: correct clk_set_rate kerneldoc
  clk: core: remove dead code paths
  clk: core: clk_calc_new_rates handles NULL parents
  clk: core: enforce clk_ops consistency
  clk: core: copy parent_names & return error codes
  clk: basic: improve parent_names & return errors

Rajendra Nayak (1):
  clk: Make clk_get_rate() return 0 on error

Shawn Guo (4):
  clk: use kzalloc in clk_register_mux
  clk: remove unnecessary EXPORT_SYMBOL_GPL
  clk: add "const" for clk_ops of basic clks
  clk: declare clk_ops of basic clks in clk-provider.h

 drivers/clk/clk-divider.c    |   51 +++++++++----
 drivers/clk/clk-fixed-rate.c |   57 +++++++++------
 drivers/clk/clk-gate.c       |   53 ++++++++++-----
 drivers/clk/clk-mux.c        |   16 +++--
 drivers/clk/clk.c            |  159 ++++++++++++++++++++++++++---------------
 include/linux/clk-private.h  |   14 +---
 include/linux/clk-provider.h |   13 ++--
 include/linux/clk.h          |    2 +-
 8 files changed, 230 insertions(+), 135 deletions(-)

-- 
1.7.5.4

