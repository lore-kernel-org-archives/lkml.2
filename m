Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752316Ab2IKW2Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 18:28:24 -0400
Received: from utopia.booyaka.com ([74.50.51.50]:38387 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750934Ab2IKW2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 18:28:23 -0400
Date: Tue, 11 Sep 2012 22:28:22 +0000 (UTC)
From: Paul Walmsley <paul@pwsan.com>
To: Kishon Vijay Abraham I <kishon@ti.com>, b-cousson@ti.com
cc: balbi@ti.com, tony@atomide.com, linux@arm.linux.org.uk, arnd@arndb.de,
        gregkh@linuxfoundation.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] arm: omap: hwmod: make *phy_48m* as the main_clk of
 ocp2scp
In-Reply-To: <1347008955-21310-1-git-send-email-kishon@ti.com>
Message-ID: <alpine.DEB.2.00.1209112218440.9444@utopia.booyaka.com>
References: <1347008955-21310-1-git-send-email-kishon@ti.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="843723315-1248234203-1347402309=:9444"
Content-ID: <alpine.DEB.2.00.1209112225130.9444@utopia.booyaka.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--843723315-1248234203-1347402309=:9444
Content-Type: TEXT/PLAIN; CHARSET=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Content-ID: <alpine.DEB.2.00.1209112225131.9444@utopia.booyaka.com>

Hi Kishon, Beno=EEt,

On Fri, 7 Sep 2012, Kishon Vijay Abraham I wrote:

> Made *ocp2scp_usb_phy_phy_48m* as the main_clk for ocp2scp. Since this=20
> ocp2scp module does not have any fck but does have a single opt_clock,=20
> it is added as the main_clk for ocp2scp. Also removed phy_48m as the=20
> optional clock since it is now made as the main clock. By this the=20
> driver need not enable/disable phy_48m clk separately and=20
> runtime_get/runtime_put will take care of that.

Looking at this patch, it doesn't seem to make sense from a hardware point=
=20
of view.  If you look at the OMAP4430 TRM Rev. AE, Table 23-1166 "Clocks=20
and Resets", the 48MHz clock input is listed as an "Optional functional=20
clock".  The main functional clock is listed as "INIT_960M_FCLK", which=20
according to the same TRM, Section 3.6.3.9.1 "Overview", is an alias for=20
the clock we call "dpll_usb_clkdcoldo_ck".

So if any clock should be the main functional clock in the hwmod data,=20
shouldn't it be dpll_usb_clkdcoldo_ck?  The goal with the hwmod data=20
is/was to have it match the hardware.

=2E..

More to the point, I guess I don't see what the problem is with=20
adding a few lines to the ocp2scp driver to control the "phy_48m" optional=
=20
clock via the clock framework.  Is there some reason why you=20
couldn't prepare & enable it after the pm_runtime_get_*(),=20
and disable and unprepare it before the pm_runtime_put_*() ?


- Paul
--843723315-1248234203-1347402309=:9444--
