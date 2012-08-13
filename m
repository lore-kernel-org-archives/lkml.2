Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752068Ab2HMPuy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 11:50:54 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:32903 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751777Ab2HMPux (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 11:50:53 -0400
MIME-Version: 1.0
In-Reply-To: <20120809101947.GA8474@sirena.org.uk>
References: <1344375978-29981-1-git-send-email-matt@genesi-usa.com> <20120809101947.GA8474@sirena.org.uk>
From: Matt Sealey <matt@genesi-usa.com>
Date: Mon, 13 Aug 2012 10:42:58 -0500
Message-ID: <CAKGA1bkwMvDW7nMWxUbNm3_0ZTR2+uKs8UL_HuisJe7cd8POBA@mail.gmail.com>
Subject: Re: [PATCH] efikamx: reintroduce Genesi Efika MX Smarttop via device tree
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Steev Klimaszewski <steev@genesi-usa.com>,
        Shawn Guo <shawn.guo@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 9, 2012 at 5:19 AM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Tue, Aug 07, 2012 at 04:46:18PM -0500, Matt Sealey wrote:
>
> Yay for indentation!  It'd be good to rewrite your DT so you could cut
> down on that, at the minute it's not good for legibility.
>
>> +                                                     sw1_reg: sw1 {
>> +                                                             regulator-min-microvolt = <600000>;
>> +                                                             regulator-max-microvolt = <1375000>;
>> +                                                             regulator-boot-on;
>> +                                                             regulator-always-on;
>> +                                                     };
>
> This and many of your other regulators have voltage ranges specified but
> no consumers which doesn't make sense.  It looks awfully like you've
> just typed in the maximum range supported by the regulator which is most
> likely broken.

Okay I have a question about this; some of the regulators (SW1
especially) are obviously consumed by the CPU core complex so that
when DVFS gives us a hint we can clock down and reduce voltage. How on
earth do we implement that?

We can drop the maximum range to be better for the CPU (1.3V is too
high, I think this is legacy from when we may have had a sorted 1GHz
MX51 coming out) but I can't find any source for where this is hooked
in.

-- 
Matt Sealey <matt@genesi-usa.com>
Product Development Analyst, Genesi USA, Inc.
