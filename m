Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752703Ab2KREO6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2012 23:14:58 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:59804 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752562Ab2KREO5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2012 23:14:57 -0500
MIME-Version: 1.0
In-Reply-To: <20121112212212.20034.78522@nucleus>
References: <CAPub14-CPS48gQ1h8vvAYBpO_=egjheG_rMoZ894Y4XZ2CinUQ@mail.gmail.com>
	<CAPub148Bq=uwTuky25WzXn4yfCukJ+WacxkBvuyV5yTzGasGOQ@mail.gmail.com>
	<20121112212212.20034.78522@nucleus>
Date: Sun, 18 Nov 2012 09:44:54 +0530
Message-ID: <CAPub149DJ21zG27FSLC-MeQFdkYXtim4TbxnZx3Bg7gtxK9BiA@mail.gmail.com>
Subject: Re: possibility of parent clock selection through DT
From: Shiraz Hashim <shiraz.linux.kernel@gmail.com>
To: Mike Turquette <mturquette@ti.com>
Cc: Rob Herring <rob.herring@calxeda.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Viresh Kumar <viresh.kumar@linaro.org>,
        devicetree-discuss@lists.ozlabs.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,

On Tue, Nov 13, 2012 at 2:52 AM, Mike Turquette <mturquette@ti.com> wrote:
> Quoting Shiraz Hashim (2012-11-06 22:36:10)
>> On Wed, Nov 7, 2012 at 11:42 AM, Shiraz Hashim
>> <shiraz.linux.kernel@gmail.com> wrote:
>> > Hi Mike, Rob,
>> >
>> > Devices in a SoC can have multiple possible clock sources which is
>> > perfectly captured through clk framework.
>> >
>> > But the device itself may not be aware of the complex hierarchy above it.
>> > In this case how do you suggest a board (through DT) should select its
>> > preference.
>> >
>> > Is there some work already going on in this direction ?
>>
>> Just to make it clear, I already have referred the clock DT bindings and
>> Shawn Guo patch on removing clk look up registration from kernel code.
>>
>> Here I am talking about possibility of selecting desired clock hierarchy
>> by the boards about which device nodes are not aware.
>>
>
> One way to achieve this is to use clk_set_rate as a way to switch
> parents at run-time.  The OMAP CCF code currently does this when
> relocking PLLs and makes use of __clk_reparent to update the clock
> framework's representation of the hierarchy dynamically.
>
> Maybe something like the following is helpful to you:
> http://git.linaro.org/gitweb?p=people/mturquette/linux.git;a=blob;f=arch/arm/mach-omap2/dpll3xxx.c;h=f72dedb4eee892ce4cd5bdf22cc8c22510f3d526;hb=clk-omap-3.8#l542

Thanks for the information.

So the generic SoC part can be handled through set_rate but
what about boards preferences and restrictions. For e.g., it prefers
to route a clock from a particular clk source only and wants its own
fixed (as per its design) clk source selections.

-- 
regards
Shiraz Hashim
