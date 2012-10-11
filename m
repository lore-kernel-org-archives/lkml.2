Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756143Ab2JKMZp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 08:25:45 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:37873 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751213Ab2JKMZm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 08:25:42 -0400
Message-ID: <5076BAA2.6010404@ti.com>
Date: Thu, 11 Oct 2012 17:55:06 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: Murali Karicheri <m-karicheri2@ti.com>
CC: <mturquette@linaro.org>, <arnd@arndb.de>, <akpm@linux-foundation.org>,
        <shawn.guo@linaro.org>, <rob.herring@calxeda.com>,
        <linus.walleij@linaro.org>, <viresh.linux@gmail.com>,
        <linux-kernel@vger.kernel.org>, <khilman@ti.com>,
        <linux@arm.linux.org.uk>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-keystone@list.ti.com>,
        <linux-c6x-dev@linux-c6x.org>, <cyril@ti.com>
Subject: Re: [PATCH v2 09/13] ARM: davinci - update the dm644x soc code to
 use common clk drivers
References: <1348683037-9705-1-git-send-email-m-karicheri2@ti.com> <1348683037-9705-10-git-send-email-m-karicheri2@ti.com>
In-Reply-To: <1348683037-9705-10-git-send-email-m-karicheri2@ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Murali,

On 9/26/2012 11:40 PM, Murali Karicheri wrote:
> The clock tree for dm644x is defined using the new structure davinci_clk.
> The SoC specific code re-uses clk-fixed-rate, clk-divider and clk-mux
> drivers in addition to the davinci specific clk drivers, clk-davinci-pll
> and clk-davinci-psc. Macros are defined to define the various clocks in
> the SoC.
> 
> Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>

You have chosen to keep all clock related data in platform files while
using the common clock framework to provide just the infrastructure. If
you look at how mxs and spear have been migrated, they have migrated the
soc specific clock data to drivers/clk as well. See
"drivers/clk/spear/spear3xx_clock.c" or "drivers/clk/mxs/clk-imx23.c". I
feel the latter way is better and I also think it will simplify some of
the look-up infrastructure you had to build. This will also help some
real code reduction from arch/arm/mach-davinci/.

Thanks,
Sekhar
