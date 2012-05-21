Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756154Ab2EUCSV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2012 22:18:21 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:58177 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755209Ab2EUCST (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2012 22:18:19 -0400
Message-ID: <4FB9A5E7.2070000@gmail.com>
Date: Sun, 20 May 2012 21:18:15 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Shawn Guo <shawn.guo@freescale.com>
CC: Mike Turquette <mturquette@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        "arm@kernel.org" <arm@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] DT clk binding support
References: <4FB80F32.5090309@gmail.com> <20120520030653.GB5810@S2100-06.ap.freescale.net>
In-Reply-To: <20120520030653.GB5810@S2100-06.ap.freescale.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/19/2012 10:06 PM, Shawn Guo wrote:
> On Sat, May 19, 2012 at 04:22:58PM -0500, Rob Herring wrote:
>> Grant Likely (2):
>>       clk: add DT clock binding support
> 
> I just checked your branch and found that a couple of comments that
> I put on this patch haven't get addressed.  The most notable one would
> be the "clocks" property of clock consumers.
> 
> +==Clock consumers==
> +
> +Required properties:
> +clocks:                List of phandle and clock specifier pairs, one pair
> +               for each clock input to the device.  Note: if the
> +               clock provider specifies '0' for #clock-cells, then
> +               only the phandle portion of the pair will appear.
> +
> +Optional properties:
> +clock-names:   List of clock input name strings sorted in the same
> +               order as the clocks property.  Consumers drivers
> +               will use clock-names to match clock input names
> +               with clocks specifiers.
> 
> As I said, any clock in the clock tree except root clock is not only
> a clock provider but also a consumer.  If you define "clocks" as a
> required property for clock consumers, you are essentially asking users
> to either define the whole clock tree in the device tree or stay away
> from device tree completely.

So what are you proposing that a clock consumer have? The very
definition of a clock consumer is that it has a clocks property.

> 
> Are you sure this is the right thing to do?  If I remember correctly,
> Grant's position is it should be pretty reasonable to have most of
> the clock tree defined in clock driver and only define those leaf
> clocks which are very likely to become the clock providers for other
> peripherals.

The minimum is you have to have a provider and consumer. It may be a
single provider that provides all clocks for a chip. If you don't want a
provider, then just define a clock-frequency property.
> 
> Let me put a terrible example here.  Since clock tree is actually SoC
> specific, I can reasonably choose to define the entire imx6q clock tree
> and all the clk lookups for imx6q peripherals in clk-imx6q driver.
> On imx6q-sabrelite board, the audio codec sgtl5000 uses cko (an imx6q
> clock available on pad) as the clock source.  That said, I need a board
> specific clk lookup here, which should be the best user of clock DT
> bindings.  But sadly, with the current bindings, I can not give the
> required "clocks" property for sgtl5000 node.

I don't understand your example. For the sgtl5000 on the sabrelite, you
would provide a phandle and cell entry that is interpreted as the cko
pin. Is your concern the node itself has to change from board to board?
That's normal for all bindings. If you have a module, its interrupts
binding is dependent on the interrupt controller's binding (i.e. a GIC
has 3 cells and VIC has 1 cell) which can vary.

Rob
