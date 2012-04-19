Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755252Ab2DSO7o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 10:59:44 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:48753 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752605Ab2DSO7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 10:59:42 -0400
Message-ID: <4F902858.9040905@gmail.com>
Date: Thu, 19 Apr 2012 09:59:36 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120410 Thunderbird/11.0.1
MIME-Version: 1.0
To: Sascha Hauer <s.hauer@pengutronix.de>
CC: "Turquette, Mike" <mturquette@ti.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Sascha Hauer <kernel@pengutronix.de>, shawn.guo@linaro.org
Subject: Re: [PATCH 1/4] clk: select CLKDEV_LOOKUP for COMMON_CLK
References: <1334003101-17274-1-git-send-email-robherring2@gmail.com> <1334003101-17274-2-git-send-email-robherring2@gmail.com> <CAJOA=zMPqiH2fQJ5JWJ=COnju7Cmur6J2ATYUTcx41C4WMjFQQ@mail.gmail.com> <20120418070721.GL3852@pengutronix.de>
In-Reply-To: <20120418070721.GL3852@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/18/2012 02:07 AM, Sascha Hauer wrote:
> On Tue, Apr 17, 2012 at 03:13:49PM -0700, Turquette, Mike wrote:
>> On Mon, Apr 9, 2012 at 1:24 PM, Rob Herring <robherring2@gmail.com> wrote:
>>> From: Rob Herring <rob.herring@calxeda.com>
>>>
>>> Using the common clock infrastructure without the common clkdev code makes
>>> little sense, so select CLKDEV_LOOKUP for COMMON_CLK.
>>>
>>> Signed-off-by: Rob Herring <rob.herring@calxeda.com>
>>> ---
>>>  drivers/clk/Kconfig |    1 +
>>>  1 files changed, 1 insertions(+), 0 deletions(-)
>>>
>>> diff --git a/drivers/clk/Kconfig b/drivers/clk/Kconfig
>>> index 165e1fe..f05a60d 100644
>>> --- a/drivers/clk/Kconfig
>>> +++ b/drivers/clk/Kconfig
>>> @@ -12,6 +12,7 @@ config HAVE_MACH_CLKDEV
>>>  config COMMON_CLK
>>>        bool
>>>        select HAVE_CLK_PREPARE
>>> +       select CLKDEV_LOOKUP
>>>        ---help---
>>>          The common clock framework is a single definition of struct
>>>          clk, useful across many platforms, as well as an
>>
>> Hi Rob,
>>
>> I agree that the common clk framework is not particularly useful
>> without clkdev.  However the core code has no dependency on clkdev.
>> Why not just select it from an arch Kconfig, or even make it a
>> dependency based on your own platform clock data/code?
> 
> Selecting it from COMMON_CLK means that the compiler/linker will point
> everybody trying to implement it without CLKDEV into the right
> direction.

Right. That was part of my rationale as well.

The DT clock support is dependent on both options, so without this patch
we'll have to add an otherwise unneeded OF_CLOCK option to select both.

Rob
