Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932533Ab2EUSGc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 14:06:32 -0400
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:42070 "EHLO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758720Ab2EUSGV convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 14:06:21 -0400
MIME-Version: 1.0
In-Reply-To: <20120521084642.GV20304@tbergstrom-lnx.Nvidia.com>
References: <1337227884.2066.9.camel@pgaikwad-dt2> <20120517062131.GA9305@gmail.com>
 <1337316517.22560.19.camel@pgaikwad-dt2> <20120518112104.GL20304@tbergstrom-lnx.Nvidia.com>
 <CAJOA=zM_o1Nqw55xxFvw6KssM50Q+7yyo41rUSH2Aoo1neTMjg@mail.gmail.com> <20120521084642.GV20304@tbergstrom-lnx.Nvidia.com>
From: "Turquette, Mike" <mturquette@ti.com>
Date: Mon, 21 May 2012 11:05:57 -0700
Message-ID: <CAJOA=zNoj1nZ+zVURfhziqFem4F7_Y_B8s=Gp1Aptr0hgfj6Xw@mail.gmail.com>
Subject: Re: Clock register in early init
To: Peter De Schrijver <pdeschrijver@nvidia.com>
Cc: Prashant Gaikwad <pgaikwad@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 21, 2012 at 1:46 AM, Peter De Schrijver
<pdeschrijver@nvidia.com> wrote:
>>
>> On OMAP I think the only "gotcha" is setting up the timer.  One
>> solution is to open code the register reads and the rate calculation
>> in the timer code.  That is ugly... but it works.
>>
>> > Which advantages do you see in dynamically allocating all this?
>> >
>>
>> There are many but I'll name a couple.  The most significant point is
>> that we can avoid exposing the definition of struct clk if we
>> dynamically allocate stuff.  One can use struct clk_hw_init to
>> statically initialize data, or instead rely on direct calls to
>> clk_register with a bunch of parameters.
>>
>
> Which means if you make a mistake in specifying parents for example, it will
> only fail at runtime, possibly before any console is active. With static
> initialization, this will fail at compiletime. Much easier to debug.
>

Is this really a problem?  Once you have good data it does not change.
 Debugging bad data when introducing a new chip is just a fact of
life.  Static versus dynamic is irrelevant here.

>> Another point is that copying the data at registration-time makes
>> __initdata possible.  I haven't done the math yet to see if this
>> really makes a difference.  However if we start doing single zImage's
>> with multiple different ARM SoCs then this could recover some pages.
>>
>
> On the other hand most clock structures are small, so there will be internal
> fragmentation. Also the arrays of parent clock pointers can be shared between
> different clocks. We have about 70 muxes in Tegra30 and 12 different parent
> arrays.
>

What is missing from struct clk_hw_init to do what your static arrays do today?

Thanks,
Mike

> Cheers,
>
> Peter.
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
