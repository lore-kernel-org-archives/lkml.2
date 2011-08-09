Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751319Ab1HITum (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 15:50:42 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:44211 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750807Ab1HITul convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 15:50:41 -0400
MIME-Version: 1.0
In-Reply-To: <20110803125524.GC23953@n2100.arm.linux.org.uk>
References: <cover.1311936523.git.viresh.kumar@st.com>
	<96781d46e41fa6ffc04b88527a25d73f5a59eda8.1311936524.git.viresh.kumar@st.com>
	<20110730120740.GA15791@n2100.arm.linux.org.uk>
	<20110730130537.GB15791@n2100.arm.linux.org.uk>
	<CAKnu2MqTYF43wW3axM--jXdtvsCyRBTLEHDc3hPoJYAmTAL5UA@mail.gmail.com>
	<CAKnu2MppEKxZD2Z77tfShMfG80d-Xx26yBGhZtJkJ2C6SjE=1w@mail.gmail.com>
	<20110731170451.GC2975@n2100.arm.linux.org.uk>
	<CACRpkdZTsD=7woN1qV-sFpsJTyT0LQBq+q=xTOwuewAk=ijBjQ@mail.gmail.com>
	<20110803125524.GC23953@n2100.arm.linux.org.uk>
Date: Tue, 9 Aug 2011 21:50:40 +0200
Message-ID: <CACRpkdYasq+Ha1K4Guma9XqJub348QgXDK9=Jnr6CzAj0Zf9pA@mail.gmail.com>
Subject: Re: [PATCH 07/18] dmaengine/amba-pl08x: Enable/Disable amba_pclk with
 channel requests
From: Linus Walleij <linus.walleij@linaro.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Viresh Kumar <viresh.kumar@st.com>, pratyush.anand@st.com,
        rajeev-dlh.kumar@st.com, armando.visconti@st.com,
        bhupesh.sharma@st.com, vinod.koul@intel.com,
        linux-kernel@vger.kernel.org, vipin.kumar@st.com, shiraz.hashim@st.com,
        amit.virdi@st.com, vipulkumar.samar@st.com, viresh.linux@gmail.com,
        deepak.sikri@st.com, dan.j.williams@intel.com,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 3, 2011 at 2:55 PM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Tue, Aug 02, 2011 at 11:05:38AM +0200, Linus Walleij wrote:
>> On Sun, Jul 31, 2011 at 7:04 PM, Russell King - ARM Linux
>> <linux@arm.linux.org.uk> wrote:
>> > On Sun, Jul 31, 2011 at 02:04:47AM +0200, Linus Walleij wrote:
>> >>
>> >> ..and while it will just cause some double refcounts on the clock,
>> >> it makes sense to delete the pclk manipulation from the PL022
>> >> driver code as part of the patch, like this:
>> >
>> > Yes, this looks fine.  Shall I wrap it up as part of my patch?
>>
>> Yes please.
>> Acked-by.
>
> Can you give this a try - this adds runtime PM to the primecell core,
> updates the SPI driver for those changes, and adds runtime PM to the
> MMCI driver.  I've briefly tested this on Versatile PB926, though
> obviously not the SPI stuff very much because Versatile has no SPI
> peripherals.
>
> I chose the PCI methodology to this - rather than having every driver
> fiddle about with enabling runtime PM, that's dealt with in the core
> and instead, drivers just do a put() in their probe and a balancing
> get() in their remove function to activate runtime PM for the device.

Sorry for the delay.

It works like a charm. I've tested it on U300 with a loopback test
and MMC and for both it works perfectly and the reference
counter goes to zero when unused.

Tested-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
