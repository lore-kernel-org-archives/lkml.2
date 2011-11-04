Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753043Ab1KDVeh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 17:34:37 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:58719 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751907Ab1KDVeg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 17:34:36 -0400
MIME-Version: 1.0
X-Originating-IP: [173.13.129.225]
In-Reply-To: <20111104212910.GB8266@opensource.wolfsonmicro.com>
References: <1319721864-30067-1-git-send-email-rnayak@ti.com>
	<20111104202905.GA3918@quad.lixom.net>
	<20111104211447.GC2541@opensource.wolfsonmicro.com>
	<20111104212216.GA5756@quad.lixom.net>
	<20111104212910.GB8266@opensource.wolfsonmicro.com>
Date: Fri, 4 Nov 2011 14:34:35 -0700
Message-ID: <CAOesGMgA7UayF9SJUP0YLnj86GmKBrajsBxv4_kRNNqCsvKTYg@mail.gmail.com>
Subject: Re: [PATCH v4 1/4] regulator: helper routine to extract regulator_init_data
From: Olof Johansson <olof@lixom.net>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Rajendra Nayak <rnayak@ti.com>, grant.likely@secretlab.ca,
        patches@linaro.org, tony@atomide.com,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, lrg@ti.com,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 4, 2011 at 2:29 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Fri, Nov 04, 2011 at 02:22:16PM -0700, Olof Johansson wrote:
>> On Fri, Nov 04, 2011 at 09:14:48PM +0000, Mark Brown wrote:
>
>> > The name will be fixed by the individual device bindings, this is
>> > specifying the general form of a supply property.  Each device binding
>> > will define the set of supplies that the device can use.
>
>> Ah, ok. It shouldn't be a part of this binding then and instead be added
>> to the bindings for the consumers.
>
> I think it's useful to define how consumers are supposed to do this
> somewhere - it is actually part of the core binding how consumers are
> supposed to do this.

Yeah, ok, but it shouldn't be part of the description of regulator
properties per se. See how gpio does it, defining how a gpio-specifier
is crafted. The equivalent should be done for regulators.

> There's also a bit of magic here for chained supplies with one regulator
> supplying another (eg, using a DCDC to drop the system supply down to a
> lower voltage to supply a bunch of LDOs for improved efficiency).

Describing that in the device tree using regulator-specifiers
shouldn't be too bad? The LDO will reference the DCDC as the parent
supply (or input or whatever language you prefer). They don't have to
be in the same topology, they will instead be under whatever
controller/bus they are on for control -- i2c, etc.


-Olof
