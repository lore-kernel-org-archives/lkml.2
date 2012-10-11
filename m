Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755715Ab2JKIeR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 04:34:17 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:38865 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751678Ab2JKIeM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 04:34:12 -0400
Message-ID: <5076847A.3010705@gmail.com>
Date: Thu, 11 Oct 2012 10:34:02 +0200
From: Daniel Mack <zonque@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Sebastian Hesselbarh <sebastian.hesselbarth@googlemail.com>
CC: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>, mturquette@ti.com
Subject: Re: [RFC] Common clock framework for external clock generators
References: <4FAB15DB.5050702@googlemail.com>
In-Reply-To: <4FAB15DB.5050702@googlemail.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sebastian,

On 10.05.2012 03:11, Sebastian Hesselbarh wrote:
> first of all I apologize for the quite long attachment but I think
> it is useful for the following discussion.
> 
> I recently read about the newly introduced common clock framework (ccf)
> and wondered if this could be also used for external, e.g. i2c attached,
> clock generators.
> 
> Based on my current understanding of the framework I wrote such a
> driver and now I want to present it here for clarification of some
> remarks I have regarding the framework itself.

May I kindly ask what happened to this driver? Are you planning to do
another spin for submission?


Many thanks,
Daniel




> Please do not see this driver as mature but as some kind of
> proof-of-concept. I have the driver somewhat running but stumbled
> upon some issues.
> 
> First I want to give a brief overview of the intended use case of
> this driver:
> 
> It is a driver for a clock generator that is externally attached to
> a Marvell Dove (arm/mach-dove) SoC. It will provide driver configurable
> clocks that are connected to dedicated clock inputs of the SoC, e.g.
> external audio clock for i2s controller.
> 
> The basic intention I had in mind when writing this driver was to
> add it during platform init and pass a list of clock aliases and clock
> hierarchy description to allow the receiving driver, e.g. i2s, to set
> the rate of the supplied clock without poking the clock generator
> directly.
> 
> Please comment on the following aspects:
> - there is no clk_unregister which is okay for platform clocks but
> should be there since clock generators can be detached
> - the clock generator has two plls and up to 8 clocks; inside the
> clk_ops it is quite hard to find the correct struct clk_hw when
> using container_of()
> - most of clk_ops are spin-locked but i2c drivers tend to sleep
> during read or write; this causes a "BUG: scheduling while atomic"
> 
> I know that ccf is quite new but it is well suited for generic,
> i.e. platform independent, external clock generator drivers. Maybe
> I got the overall concept just wrong but maybe this RFC helps
> to straighten things up for future drivers.
> 
> Regards,
>      Sebastian
> 
> 
> 
> 
> 
> 

