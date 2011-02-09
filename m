Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751412Ab1BIGlq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 01:41:46 -0500
Received: from ozlabs.org ([203.10.76.45]:44457 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750898Ab1BIGlo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 01:41:44 -0500
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Subject: [RFC,PATCH 0/3] Common struct clk implementation, v12
In-Reply-To: <201102011711.31258.jeremy.kerr@canonical.com>
Message-Id: <1297233693.241680.897691111624.0.gpush@pororo>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>, Dima Zavin <dmitriyz@google.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        <linux-sh@vger.kernel.org>,
        Ben Herrenschmidt <benh@kernel.crashing.org>,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Paul Mundt <lethal@linux-sh.org>,
        Saravana Kannan <skannan@codeaurora.org>,
        Ben Dooks <ben-linux@fluff.org>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Russell King <linux@arm.linux.org.uk>
From: Jeremy Kerr <jeremy.kerr@canonical.com>
Date: Wed, 09 Feb 2011 14:41:33 +0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

These patches are an attempt to allow platforms to share clock code. At
present, the definitions of 'struct clk' are local to platform code,
which makes allocating and initialising cross-platform clock sources
difficult, and makes it impossible to compile a single image containing
support for two ARM platforms with different struct clks.

The three patches are for the architecture-independent kernel code,
introducing the common clk infrastructure. The changelog for the first
patch includes details about the new clock definitions.

Ben Herrenschmidt is looking at using common struct clk code for powerpc
too, hence the kernel-wide approach.

Many thanks to the following for their input:
 * Ben Dooks <ben-linux@fluff.org>
 * Baruch Siach <baruch@tkos.co.il>
 * Russell King <linux@arm.linux.org.uk>
 * Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
 * Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>
 * Vincent Guittot <vincent.guittot@linaro.org>
 * Sascha Hauer <s.hauer@pengutronix.de>
 * Ryan Mallon <ryan@bluewatersys.com>
 * Colin Cross <ccross@google.com>
 * Jassi Brar <jassisinghbrar@gmail.com>

Cheers,


Jeremy

--
v12:
 * Always refcount, even when enable/prepare ops are NULL
 * Unify prepare & enable count checking
 * Update comments for prepare/unprepare
 * Use spin_{lock,unlock}_irqsave
 * Change clk_put to __clk_put, and use the shared clk_put

v11:
 * add prepare/unprepare for non-atomic switching, document atomicity
 * move to drivers/clk/

v10:
 * comment fixups, from Uwe's review
 * added DEFINE_CLK_FIXED

v9:
 * comment improvements
 * kerneldoc fixups
 * add WARN_ON to clk_disable

v8:
 * add atomic clocks, and locking wrappers
 * expand comments on clk and clk_ops

v7:
 * change CLK_INIT to initialise clk->mutex statically

v6:
 * fixed up references to 'clk_operations' in the changelog

v5:
 * uninline main API, and share definitions with !USE_COMMON_STRUCT_CLK
 * add __clk_get
 * delay mutex init
 * kerneldoc for struct clk

v4:
 * use mutex for enable/disable locking
 * DEFINE_CLK -> INIT_CLK, and pass the clk name for mutex init
 * struct clk_operations -> struct clk_ops

v3:
 * do clock usage refcounting in common code
 * provide sample port

v2:
 * no longer ARM-specific
 * use clk_operations

---
Jeremy Kerr (3):
      Add a common struct clk
      clk: Generic support for fixed-rate clocks
      clk: add warnings for incorrect enable/prepare semantics

