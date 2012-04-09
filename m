Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757708Ab2DIW2A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 18:28:00 -0400
Received: from londo.lunn.ch ([80.238.139.98]:33754 "EHLO londo.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752726Ab2DIW17 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 18:27:59 -0400
Date: Tue, 10 Apr 2012 00:29:03 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: mturquette@linaro.org
Cc: arnd.bergmann@linaro.org, rob.herring@calxeda.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: COMMON_CLK_DISABLE_UNUSED
Message-ID: <20120409222903.GA31622@lunn.ch>
Mail-Followup-To: mturquette@linaro.org, arnd.bergmann@linaro.org,
	rob.herring@calxeda.com, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike

I've been thinking about:

config COMMON_CLK_DISABLE_UNUSED
        bool "Disabled unused clocks at boot"
        depends on COMMON_CLK
        ---help---
          Traverses the entire clock tree and disables any clocks that are
          enabled in hardware but have not been enabled by any device drivers.
          This saves power and keeps the software model of the clock in line
          with reality.

          If in doubt, say "N".

I think in the long run, having this as an option is going to cause
problems, in particular for the One ARM Kernel. Some platforms are
going to want it enabled, others will want it disabled. Depending on
who looses out, there are going to be power regressions, or clocks
unexpectedly turned off.

I think it would be good to consider deleting this config option and
just have the code always enabled.

What do you think?

     Thanks
	Andrew
