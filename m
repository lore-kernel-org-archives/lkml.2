Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757853Ab2CTXkG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 19:40:06 -0400
Received: from utopia.booyaka.com ([72.9.107.138]:60491 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750879Ab2CTXkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 19:40:04 -0400
Date: Tue, 20 Mar 2012 17:40:02 -0600 (MDT)
From: Paul Walmsley <paul@pwsan.com>
To: Arnd Bergmann <arnd@arndb.de>
cc: "Turquette, Mike" <mturquette@ti.com>,
        linux-arm-kernel@lists.infradead.org,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>, linaro-dev@lists.linaro.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Saravana Kannan <skannan@codeaurora.org>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Magnus Damm <magnus.damm@gmail.com>,
        Deepak Saxena <dsaxena@linaro.org>, patches@linaro.org,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Richard Zhao <richard.zhao@linaro.org>,
        Shawn Guo <shawn.guo@freescale.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Stephen Boyd <sboyd@codeaurora.org>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 1/3] Documentation: common clk API
In-Reply-To: <201203170905.33191.arnd@arndb.de>
Message-ID: <alpine.DEB.2.00.1203201731550.22974@utopia.booyaka.com>
References: <1331878280-2758-1-git-send-email-mturquette@linaro.org> <alpine.DEB.2.00.1203161509470.4395@utopia.booyaka.com> <CAJOA=zPmy7Dwzw8EOCW_+cvy2Dv=w0TPUq7Zg_s=Y0rs+v+u2w@mail.gmail.com> <201203170905.33191.arnd@arndb.de>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Arnd,

On Sat, 17 Mar 2012, Arnd Bergmann wrote:

> I think it's rather pointless, because the option is not going to
> be user selectable but will get selected by the platform unless I'm
> mistaken. The platform maintainers that care already know the state
> of the framework.

This is where we have differing views, I think.  Clearly, Sascha, 
Saravana, Rob, and I have at least slightly different opinions on the 
durability of the existing API and code.  So it seems reasonable to assume 
that others who have not followed the development of the common clock code 
might mistake the implementation or API as being stable and well-defined.

It sounds like the primary objection is to the use of CONFIG_EXPERIMENTAL.  
So here is a patch to simply note the status of this code in its Kconfig 
text.


- Paul

From: Paul Walmsley <paul@pwsan.com>
Date: Tue, 20 Mar 2012 17:19:06 -0600
Subject: [PATCH] clk: note that the common clk code is still subject to
 significant change

Indicate that the common clk code and API is still likely to require
significant change.  The API is not well-defined and both it and the
underlying mechanics are likely to need significant changes to support
non-trivial uses of the rate changing code, such as DVFS with external
I/O devices.  So any platforms that switch their implementation over
to this may need to revise much of their driver code and revalidate
their implementations until the behavior of the code is
better-defined.

A good time for removing this help text would be after at least two
platforms that do DVFS on groups of external I/O devices have ported
their clock implementations over to the common clk code.

Signed-off-by: Paul Walmsley <paul@pwsan.com>
Cc: Mike Turquette <mturquette@ti.com>
---
 drivers/clk/Kconfig |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/clk/Kconfig b/drivers/clk/Kconfig
index 2eaf17e..dd2d528 100644
--- a/drivers/clk/Kconfig
+++ b/drivers/clk/Kconfig
@@ -21,6 +21,11 @@ menuconfig COMMON_CLK
 	  this option for loadable modules requiring the common clock
 	  framework.
 
+	  The API and implementation enabled by this option is still
+	  incomplete.  The API and implementation is expected to be
+	  fluid and subject to change at any time, potentially
+	  breaking existing users.
+
 	  If in doubt, say "N".
 
 if COMMON_CLK
-- 
1.7.9.1

