Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754726Ab0FUFfc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 01:35:32 -0400
Received: from ozlabs.org ([203.10.76.45]:53211 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753072Ab0FUFfZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 01:35:25 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 0/2] Common struct clk implementation, v5
Message-Id: <1277098513.947165.104554431018.0.gpush@pororo>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org,
       Ben Herrenchmidt <benh@kernel.crashing.org>
From: Jeremy Kerr <jeremy.kerr@canonical.com>
Date: Mon, 21 Jun 2010 13:35:13 +0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

These patches are an attempt to allow platforms to share clock code. At
present, the definitions of 'struct clk' are local to platform code,
which makes allocating and initialising cross-platform clock sources
difficult, and makes it impossible to compile a single image containing
support for two ARM platforms with different struct clks.

The two patches are for the architecture-independent kernel code,
introducing the common clk infrastructure. The changelog for the first
patch includes details about the new clock definitions.

As requested by rmk, I've put together a small series of patches
illustrating the usage of the common struct clock on the ARM imx51
platform. These are available in my git tree:

 git://kernel.ubuntu.com/jk/dt/linux-2.6

in the clk-common-mx51 branch (clk-common..clk-common-mx51).

The approach I've taken with the imx51 port is to temporarly duplicate
the platform-common clock code (ie, for all mxc-based boards) to enable
usage of the common struct clk on one machine (imx51), while leaving the
others as-is. For a proper platform-wide usage of the common struct clk,
we'd be better off doing the whole platform at once. However, mx51 is
the only mxc-based HW I have, hence the duplicated example port.

In the example port, the first change simply converts the mxc's struct
clk to a struct clk_mxc, using the new API.  The subsequent patches move
certain clocks to more specific data structures (eg clk_fixed and
clk_pll) where possible.

Ben Herrenschmidt is looking at using common struct clk code for powerpc
too, hence the kernel-wide approach.

Comments most welcome.

Cheers,


Jeremy

--
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
Jeremy Kerr (2):
      Add a common struct clk
      clk: Generic support for fixed-rate clocks

