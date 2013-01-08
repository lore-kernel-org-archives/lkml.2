Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753702Ab3AHVeR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 16:34:17 -0500
Received: from mga02.intel.com ([134.134.136.20]:16391 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752139Ab3AHVeQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 16:34:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,433,1355126400"; 
   d="scan'208";a="269486434"
Message-ID: <50EC90C3.2090604@intel.com>
Date: Tue, 08 Jan 2013 22:33:55 +0100
From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-kernel@vger.kernel.org, grant.likely@secretlab.ca,
        linus.walleij@linaro.org, eric.y.miao@gmail.com,
        linux@arm.linux.org.uk, haojian.zhuang@gmail.com, chao.bi@intel.com,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: [PATCH 05/11] spi/pxa2xx: make clock rate configurable from platform
 data
References: <1357555480-24022-1-git-send-email-mika.westerberg@linux.intel.com> <1357555480-24022-6-git-send-email-mika.westerberg@linux.intel.com> <20130108110228.GM4544@opensource.wolfsonmicro.com> <20130108124153.GJ13897@intel.com> <20130108131008.GW4544@opensource.wolfsonmicro.com>
In-Reply-To: <20130108131008.GW4544@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=US-ASCII;
	format=flowed
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/8/2013 2:10 PM, Mark Brown wrote:
> On Tue, Jan 08, 2013 at 02:41:53PM +0200, Mika Westerberg wrote:
>> On Tue, Jan 08, 2013 at 11:02:28AM +0000, Mark Brown wrote:
>>> No, the way to do this is to fix x86 to enable the clock API there.  The
>>> x86 maintainers couldn't be bothered when I submitted a patch and
>>> getting anyone to take a patch to make it available by default appears
>>> to be unreasonably hard but perhaps if someone from Intel tries the x86
>>> maintainers might take a patch...
>> Do you mean enabling CONFIG_COMMON_CLK on x86?
> Yes.

Why so?  x86 doesn't have a notion of direct clock control, at least not 
on the ACPI systems.

>>> We shouldn't be adding special case code to every driver that might need
>>> a clock that gets used on an Intel system.
>> I agree and it is cleaner to have the same API for all arches. However, I'm
>> not sure how do we create the fixed clocks then? There is nothing in ACPI
>> namespace (or in the ACPI 5.0 spec) that allows you to describe clocks and
>> their relationships.
> I'm sure it's not beyond the bounds of possibility that we could solve
> this problem...

No, it isn't.  Any suggestions?

>> So then we end up either:
>> 	1. Creating a custom board file for Lynxpoint which creates the
>> 	   clocks. This is something I think x86 maintainers don't want to
>> 	   see.
>> 	2. Creating the clock in the driver itself in its ACPI enumeration
>> 	   implementation. This might work but it litters the drivers with
>> 	   clock details.
>> Or is there something I'm missing?
> Well, it seems fairly clear to me that the SoC wiring ought to be done
> outside the driver.
>
> It is something that needs to be resolved for your smartphone SoCs for

We're not talking about smartphones and even not about SoCs here, sorry.

This is a laptop CPU that happens to have an SPI controller integrated.

> this and for other things like platform data for external chips, what's
> actually happening in practical systems here is that people are just
> hacking the arch code as there's no mechanism for providing
> configuration at present.

I'm not sure what you're referring to, but here we have ACPI as a 
configuration mechanism.

Which doesn't allow us to control clocks directly.

Thanks,
Rafael

---------------------------------------------------------------------
Intel Technology Poland sp. z o.o.
z siedziba w Gdansku
ul. Slowackiego 173
80-298 Gdansk

Sad Rejonowy Gdansk Polnoc w Gdansku, 
VII Wydzial Gospodarczy Krajowego Rejestru Sadowego, 
numer KRS 101882

NIP 957-07-52-316
Kapital zakladowy 200.000 zl

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

