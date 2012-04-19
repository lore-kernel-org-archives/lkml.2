Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932218Ab2DSUBj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 16:01:39 -0400
Received: from na3sys009aog138.obsmtp.com ([74.125.149.19]:54562 "EHLO
	na3sys009aog138.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756251Ab2DSUBi convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 16:01:38 -0400
MIME-Version: 1.0
In-Reply-To: <4F902858.9040905@gmail.com>
References: <1334003101-17274-1-git-send-email-robherring2@gmail.com>
 <1334003101-17274-2-git-send-email-robherring2@gmail.com> <CAJOA=zMPqiH2fQJ5JWJ=COnju7Cmur6J2ATYUTcx41C4WMjFQQ@mail.gmail.com>
 <20120418070721.GL3852@pengutronix.de> <4F902858.9040905@gmail.com>
From: "Turquette, Mike" <mturquette@ti.com>
Date: Thu, 19 Apr 2012 13:01:15 -0700
Message-ID: <CAJOA=zNwueCeSjT2F-M1+Ffu49t5tMBow=8baGrvZdGjrUCMrA@mail.gmail.com>
Subject: Re: [PATCH 1/4] clk: select CLKDEV_LOOKUP for COMMON_CLK
To: Rob Herring <robherring2@gmail.com>
Cc: Sascha Hauer <s.hauer@pengutronix.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Sascha Hauer <kernel@pengutronix.de>, shawn.guo@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 19, 2012 at 7:59 AM, Rob Herring <robherring2@gmail.com> wrote:
> On 04/18/2012 02:07 AM, Sascha Hauer wrote:
>> On Tue, Apr 17, 2012 at 03:13:49PM -0700, Turquette, Mike wrote:
>>> On Mon, Apr 9, 2012 at 1:24 PM, Rob Herring <robherring2@gmail.com> wrote:
>>>> From: Rob Herring <rob.herring@calxeda.com>
>>>>
>>>> Using the common clock infrastructure without the common clkdev code makes
>>>> little sense, so select CLKDEV_LOOKUP for COMMON_CLK.
>>>>
>>>> Signed-off-by: Rob Herring <rob.herring@calxeda.com>
>>>> ---
>>>>  drivers/clk/Kconfig |    1 +
>>>>  1 files changed, 1 insertions(+), 0 deletions(-)
>>>>
>>>> diff --git a/drivers/clk/Kconfig b/drivers/clk/Kconfig
>>>> index 165e1fe..f05a60d 100644
>>>> --- a/drivers/clk/Kconfig
>>>> +++ b/drivers/clk/Kconfig
>>>> @@ -12,6 +12,7 @@ config HAVE_MACH_CLKDEV
>>>>  config COMMON_CLK
>>>>        bool
>>>>        select HAVE_CLK_PREPARE
>>>> +       select CLKDEV_LOOKUP
>>>>        ---help---
>>>>          The common clock framework is a single definition of struct
>>>>          clk, useful across many platforms, as well as an
>>>
>>> Hi Rob,
>>>
>>> I agree that the common clk framework is not particularly useful
>>> without clkdev.  However the core code has no dependency on clkdev.
>>> Why not just select it from an arch Kconfig, or even make it a
>>> dependency based on your own platform clock data/code?
>>
>> Selecting it from COMMON_CLK means that the compiler/linker will point
>> everybody trying to implement it without CLKDEV into the right
>> direction.
>
> Right. That was part of my rationale as well.
>
> The DT clock support is dependent on both options, so without this patch
> we'll have to add an otherwise unneeded OF_CLOCK option to select both.

Ok.  I'll take this into my -next branch.

Thanks,
Mike
