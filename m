Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755089Ab2ILGgV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 02:36:21 -0400
Received: from na3sys009aog130.obsmtp.com ([74.125.149.143]:42008 "EHLO
	na3sys009aog130.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752748Ab2ILGgS convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 02:36:18 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1209112218440.9444@utopia.booyaka.com>
References: <1347008955-21310-1-git-send-email-kishon@ti.com>
	<alpine.DEB.2.00.1209112218440.9444@utopia.booyaka.com>
Date: Wed, 12 Sep 2012 12:06:16 +0530
Message-ID: <CAAe_U6+JpyLrK9v3uae+yN1zCigMQc=JaEMAOZgupurCzuWDcA@mail.gmail.com>
Subject: Re: [PATCH v2] arm: omap: hwmod: make *phy_48m* as the main_clk of ocp2scp
From: "ABRAHAM, KISHON VIJAY" <kishon@ti.com>
To: Paul Walmsley <paul@pwsan.com>
Cc: b-cousson@ti.com, balbi@ti.com, tony@atomide.com, linux@arm.linux.org.uk,
        arnd@arndb.de, gregkh@linuxfoundation.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Sep 12, 2012 at 3:58 AM, Paul Walmsley <paul@pwsan.com> wrote:
> Hi Kishon, Benoît,
>
> On Fri, 7 Sep 2012, Kishon Vijay Abraham I wrote:
>
>> Made *ocp2scp_usb_phy_phy_48m* as the main_clk for ocp2scp. Since this
>> ocp2scp module does not have any fck but does have a single opt_clock,
>> it is added as the main_clk for ocp2scp. Also removed phy_48m as the
>> optional clock since it is now made as the main clock. By this the
>> driver need not enable/disable phy_48m clk separately and
>> runtime_get/runtime_put will take care of that.
>
> Looking at this patch, it doesn't seem to make sense from a hardware point
> of view.  If you look at the OMAP4430 TRM Rev. AE, Table 23-1166 "Clocks
> and Resets", the 48MHz clock input is listed as an "Optional functional
> clock".  The main functional clock is listed as "INIT_960M_FCLK", which
> according to the same TRM, Section 3.6.3.9.1 "Overview", is an alias for
> the clock we call "dpll_usb_clkdcoldo_ck".
>
> So if any clock should be the main functional clock in the hwmod data,
> shouldn't it be dpll_usb_clkdcoldo_ck?  The goal with the hwmod data
> is/was to have it match the hardware.
>
> ...
>
> More to the point, I guess I don't see what the problem is with
> adding a few lines to the ocp2scp driver to control the "phy_48m" optional

It should be added in omap-usb2 driver rather.
> clock via the clock framework.  Is there some reason why you
> couldn't prepare & enable it after the pm_runtime_get_*(),
> and disable and unprepare it before the pm_runtime_put_*() ?

We have omap-usb2 driver that is used for both omap4 and omap5. But
this 48m clock is used only in omap4. And we dint have any *main_clk*
in the ocp2scp_usb_phy_hwmod. So in order avoid some checks in the
omap-usb2 driver, we added 48m clk as the main clock of
ocp2scp_usb_phy_hwmod.

Thanks
Kishon
