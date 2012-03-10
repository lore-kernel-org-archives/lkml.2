Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752653Ab2CJHyM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2012 02:54:12 -0500
Received: from na3sys009aog116.obsmtp.com ([74.125.149.240]:46050 "EHLO
	na3sys009aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751642Ab2CJHyL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2012 02:54:11 -0500
From: Mike Turquette <mturquette@linaro.org>
To: Russell King <linux@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linaro-dev@lists.linaro.org, patches@linaro.org,
        Mike Turquette <mturquette@linaro.org>
Subject: [PATCH v6 0/3] common clk framework
Date: Fri,  9 Mar 2012 23:54:21 -0800
Message-Id: <1331366064-1273-1-git-send-email-mturquette@linaro.org>
X-Mailer: git-send-email 1.7.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The common clock framework defines a common struct clk as well as an
implementation of the clk api that unifies clock operations on various
platforms and devices.

The net result is consolidation of many different struct clk definitions
and platform-specific clock framework implementations.

Thanks to Sascha Hauer and Andrew Lunn for their great review and
feedback on the previous v5 series.

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
git://git.linaro.org/people/mturquette/linux.git v3.3-rc6-clkv6

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
 drivers/clk/Kconfig          |   39 ++
 drivers/clk/Makefile         |    2 +
 drivers/clk/clk-divider.c    |  204 ++++++
 drivers/clk/clk-fixed-rate.c |   82 +++
 drivers/clk/clk-gate.c       |  157 +++++
 drivers/clk/clk-mux.c        |  123 ++++
 drivers/clk/clk.c            | 1424 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/clk-private.h  |  192 ++++++
 include/linux/clk-provider.h |  298 +++++++++
 include/linux/clk.h          |   68 ++-
 11 files changed, 2817 insertions(+), 5 deletions(-)
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

