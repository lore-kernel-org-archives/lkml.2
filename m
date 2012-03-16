Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755339Ab2CPGLJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 02:11:09 -0400
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:38082 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753913Ab2CPGLE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 02:11:04 -0400
From: Mike Turquette <mturquette@linaro.org>
To: Russell King <linux@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linaro-dev@lists.linaro.org, patches@linaro.org,
        Mike Turquette <mturquette@linaro.org>
Subject: [PATCH v7 0/3] common clk framework
Date: Thu, 15 Mar 2012 23:11:17 -0700
Message-Id: <1331878280-2758-1-git-send-email-mturquette@linaro.org>
X-Mailer: git-send-email 1.7.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The common clock framework defines a common struct clk as well as an
implementation of the clk api that unifies clock operations on various
platforms and devices.

The net result is consolidation of many different struct clk definitions
and platform-specific clock framework implementations.

This series is the feature freeze for the common clock framework.
Unless any major bugs are reported this should be the final version of
this patchset.  Now is the time to add any acked-by's, reviewed-by's or
tested-by's.  I've carried over the *-by's from v6; I hope everyone is
OK with that.

Big thanks to Sascha Hauer for his changes to clk_set_rate in this
version.

Major changes since v6:
 * clk_set_rate rewritten to set clock rates from top-to-bottom
   * should also reduce pre-rate change notifier noise (thanks Sascha)
 * fixed up clk_divider's .round_rate logic (thanks Sascha)
 * removed useless locking around basic clock types
 * fixed return types for __clk_get_(enable|prepare)_count
 * some NULL pointer fixes for handling .parent_names and .parents
 * removed unnecessary checks for recursive calls in a few helpers
 * made __clk_round_rate more sane and aligned with clk_round_rate
   * parent rates are returned if .round_rate is not implemented
 * fixed CONFIG_COMMON_CLK_DEBUGFS to select DEBUG_FS
 * rebased onto Linus' v3.3-rc7 tag

Major changes since v5:
 * removed redundant HAVE_CLK_PREPARE in Kconfig
 * new CONFIG_COMMON_CLK_DISABLE_UNUSED feature
   * results in a new clk_op callback, .is_enabled
 * standardized the hw-specific locking in the basic clock types
 * export the individual ops for each basic clock type
 * improve registration for single-parent basic clocks (thanks Sascha)
 * fixed bugs in gate clock's static initializers (thanks Andrew)
 * overall improvements to Documentation/clk.txt
 * rebased onto Linus' v3.3-rc6 tag

Major changes since v4:
 * rolled in TGLX's comments on overall design.  We now have,
   * proper handling of root clocks and orphan clocks
   * multi-parent clocks are handled in the core
   * struct clk is shielded from struct clk_foo and vice versa
     * this is a return to the previous struct clk_hw design
 * split basic clock types out into separate files
 * split headers up by purpose
   * clk.h remains the driver-level interface
     * declarations for rate change notifiers are the only additions
   * clk-provider.h is primary header for implementing clock operations
   * clk-private.h allows for static initialization of clock data
 * validation and bug fixes
 * rebased onto Linus' v3.3-rc5 tag

Patches can be pulled from:
git://git.linaro.org/people/mturquette/linux.git v3.3-rc7-clkv7

v6 can be found at,
http://article.gmane.org/gmane.linux.kernel/1265022

v5 can be found at,
http://article.gmane.org/gmane.linux.kernel/1261472

v4 can be found at,
http://article.gmane.org/gmane.linux.linaro.devel/8896/

v3 can be found at,
http://article.gmane.org/gmane.linux.kernel/1218622

Mike Turquette (3):
  Documentation: common clk API
  clk: introduce the common clock framework
  clk: basic clock hardware types

 Documentation/clk.txt        |  233 +++++++
 drivers/clk/Kconfig          |   40 ++
 drivers/clk/Makefile         |    2 +
 drivers/clk/clk-divider.c    |  200 ++++++
 drivers/clk/clk-fixed-rate.c |   82 +++
 drivers/clk/clk-gate.c       |  150 +++++
 drivers/clk/clk-mux.c        |  116 ++++
 drivers/clk/clk.c            | 1461 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/clk-private.h  |  196 ++++++
 include/linux/clk-provider.h |  300 +++++++++
 include/linux/clk.h          |   68 ++-
 11 files changed, 2843 insertions(+), 5 deletions(-)
 create mode 100644 Documentation/clk.txt
 create mode 100644 drivers/clk/clk-divider.c
 create mode 100644 drivers/clk/clk-fixed-rate.c
 create mode 100644 drivers/clk/clk-gate.c
 create mode 100644 drivers/clk/clk-mux.c
 create mode 100644 drivers/clk/clk.c
 create mode 100644 include/linux/clk-private.h
 create mode 100644 include/linux/clk-provider.h

-- 
1.7.5.4

