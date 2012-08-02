Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753700Ab2HBWUc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 18:20:32 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:53863 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751277Ab2HBWU2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 18:20:28 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1208020150240.4177@utopia.booyaka.com>
References: <1342466485-1050-1-git-send-email-omar.luna@linaro.org>
	<1342466485-1050-3-git-send-email-omar.luna@linaro.org>
	<alpine.DEB.2.00.1208020150240.4177@utopia.booyaka.com>
Date: Thu, 2 Aug 2012 17:20:27 -0500
Message-ID: <CALLhW=6-b+kjfG-u3+uXiD64UwoNEdufjJKu0Mx-sGWp6n9csg@mail.gmail.com>
Subject: Re: [PATCH 2/3] ARM: OMAP: hwmod: revise deassert sequence
From: Omar Ramirez Luna <omar.luna@linaro.org>
To: Paul Walmsley <paul@pwsan.com>
Cc: Benoit Cousson <b-cousson@ti.com>, Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>, Kevin Hilman <khilman@ti.com>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On 2 August 2012 02:52, Paul Walmsley <paul@pwsan.com> wrote:
> On Mon, 16 Jul 2012, Omar Ramirez Luna wrote:
>
>> For a reset sequence to complete cleanly, a module needs its
>> associated clocks to be enabled, otherwise the timeout check
>> in prcm code can print a false failure (failed to hardreset)
>> that occurs because the clocks aren't powered ON and the status
>> bit checked can't transition without them.
>>
>> Signed-off-by: Omar Ramirez Luna <omar.luna@linaro.org>
>
> Is enabling the clocks sufficient?

During my testing it seemed enough, besides it looks clk framework is
doing the same as _omap4_enable_module.

> Or do we also need to enable the
> IP block, e.g. by calling
>
>         if (soc_ops.enable_module)
>                 soc_ops.enable_module(oh);
>
> as we do on OMAP4+ in _enable() ?

Basically this is a call to _omap4_enable_module, and the latter will
"Enable the modulemode inside CLKCTRL".

However, _enable_clocks path which ends calling omap2_dflt_clk_enable
does the same thing with its clk->enable_reg field.

So in _enable:

        _enable_clocks(oh);
        if (soc_ops.enable_module)
                soc_ops.enable_module(oh);

The enable_module part seems redundant to me, since the module should
be already enabled by the first call to _enable_clocks.

Regards,

Omar
