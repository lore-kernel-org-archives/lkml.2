Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756714Ab2CVSfy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 14:35:54 -0400
Received: from na3sys009aob129.obsmtp.com ([74.125.149.136]:33285 "EHLO
	na3sys009amx259.postini.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754053Ab2CVSfw convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 14:35:52 -0400
MIME-Version: 1.0
In-Reply-To: <20120322113356.GC3091@opensource.wolfsonmicro.com>
References: <1332360082-25092-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1332360082-25092-4-git-send-email-broonie@opensource.wolfsonmicro.com>
 <20120321222622.GG29317@pengutronix.de> <20120322111531.GA3091@opensource.wolfsonmicro.com>
 <20120322112613.GA3852@pengutronix.de> <20120322113356.GC3091@opensource.wolfsonmicro.com>
From: "Turquette, Mike" <mturquette@ti.com>
Date: Thu, 22 Mar 2012 11:35:29 -0700
Message-ID: <CAJOA=zOYfwy-smo6ukX7GSE2jrwz4UxwpgcFJiW876ga7ksShw@mail.gmail.com>
Subject: Re: [PATCH 4/4] clk: wm831x: Add initial WM831x clock driver
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Sascha Hauer <s.hauer@pengutronix.de>,
        linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 22, 2012 at 4:33 AM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Thu, Mar 22, 2012 at 12:26:13PM +0100, Sascha Hauer wrote:
>> On Thu, Mar 22, 2012 at 11:15:31AM +0000, Mark Brown wrote:
>
>> > No, that's not sensible.  We shouldn't be open coding this into each
>> > individual driver that provides clocks, and we shouldn't have clock
>> > users having to guess at what scheme the driver author used to dedupe
>> > the clocks.  As a driver author you would assume that the reason we're
>
>> It seems they got dropped. Currently the clock framework does nothing
>> with the device argument. But right, it could use this argument to
>> generate a suitable name.
>
> Indeed, and as with adding the stub clk_unregister() it seems like it's
> better at this point to just code the drivers as we'd expect them to
> work and fill out the framework to handle this rather than introducing
> workarounds in the drivers.

Agreed.  I put this off some time back, but I figured the WM831X
driver would bring the issue back up.

I'm happy for the core to concatenate the strings when a struct device
*dev is passed in.  However the reason I dropped this in the first
place is that I have some ideas on providing something like clk_get
directly from the common clk core and I hadn't figured out all of the
details yet.  For now we can handle the string concatenation in the
core and figure out those tricky details if/when the time comes to
provide a clk_get which is more closely linked to the clock framework
implementation.

I'll roll in a patch for my fixes series.

Regards,
Mike
