Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751994Ab2HCFZL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 01:25:11 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:56908 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751454Ab2HCFZI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 01:25:08 -0400
Message-ID: <501B609F.9030403@ti.com>
Date: Fri, 3 Aug 2012 10:54:47 +0530
From: Vaibhav Hiremath <hvaibhav@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Omar Ramirez Luna <omar.luna@linaro.org>
CC: Paul Walmsley <paul@pwsan.com>, Benoit Cousson <b-cousson@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>, Kevin Hilman <khilman@ti.com>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] ARM: OMAP: hwmod: revise deassert sequence
References: <1342466485-1050-1-git-send-email-omar.luna@linaro.org> <1342466485-1050-3-git-send-email-omar.luna@linaro.org> <alpine.DEB.2.00.1208020150240.4177@utopia.booyaka.com> <CALLhW=6-b+kjfG-u3+uXiD64UwoNEdufjJKu0Mx-sGWp6n9csg@mail.gmail.com>
In-Reply-To: <CALLhW=6-b+kjfG-u3+uXiD64UwoNEdufjJKu0Mx-sGWp6n9csg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 8/3/2012 3:50 AM, Omar Ramirez Luna wrote:
> Hi.
> 
> On 2 August 2012 02:52, Paul Walmsley <paul@pwsan.com> wrote:
>> On Mon, 16 Jul 2012, Omar Ramirez Luna wrote:
>>
>>> For a reset sequence to complete cleanly, a module needs its
>>> associated clocks to be enabled, otherwise the timeout check
>>> in prcm code can print a false failure (failed to hardreset)
>>> that occurs because the clocks aren't powered ON and the status
>>> bit checked can't transition without them.
>>>
>>> Signed-off-by: Omar Ramirez Luna <omar.luna@linaro.org>
>>
>> Is enabling the clocks sufficient?
> 
> During my testing it seemed enough, besides it looks clk framework is
> doing the same as _omap4_enable_module.
> 
>> Or do we also need to enable the
>> IP block, e.g. by calling
>>
>>         if (soc_ops.enable_module)
>>                 soc_ops.enable_module(oh);
>>
>> as we do on OMAP4+ in _enable() ?
> 
> Basically this is a call to _omap4_enable_module, and the latter will
> "Enable the modulemode inside CLKCTRL".
> 
> However, _enable_clocks path which ends calling omap2_dflt_clk_enable
> does the same thing with its clk->enable_reg field.
> 
> So in _enable:
> 
>         _enable_clocks(oh);
>         if (soc_ops.enable_module)
>                 soc_ops.enable_module(oh);
> 
> The enable_module part seems redundant to me, since the module should
> be already enabled by the first call to _enable_clocks.
> 

Yes they do same thing, I believe the plan is to get rid of all clock
leaf-nodes in the near future, and let hwmod handle module
enable/disable part.

Thanks,
Vaibhav

> Regards,
> 
> Omar
> --
> To unsubscribe from this list: send the line "unsubscribe linux-omap" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
