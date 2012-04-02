Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753612Ab2DBREG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 13:04:06 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:37630 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751548Ab2DBREE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 13:04:04 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6668"; a="175812896"
Message-ID: <4F79DC03.7020503@codeaurora.org>
Date: Mon, 02 Apr 2012 10:04:03 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Mike Turquette <mturquette@ti.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/2] clkdev: Implement managed clk_get()
References: <1333279960-8497-1-git-send-email-broonie@opensource.wolfsonmicro.com> <1333279960-8497-2-git-send-email-broonie@opensource.wolfsonmicro.com> <4F787392.5040308@codeaurora.org> <20120401153450.GC8971@opensource.wolfsonmicro.com> <4F79D85F.4020909@codeaurora.org> <20120402165242.GC24211@n2100.arm.linux.org.uk>
In-Reply-To: <20120402165242.GC24211@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/02/12 09:52, Russell King - ARM Linux wrote:
> On Mon, Apr 02, 2012 at 09:48:31AM -0700, Stephen Boyd wrote:
>> I hope we get a better clk_get() implementation with the unified struct
>> clk. Don't get me wrong, clkdev is a great improvement over open coding
>> clock framework stuff in each platform. But clkdev is really just
>> another platform specific implementation
> Utter crap.  It is not platform specific.

It has compile-time platform hooks so it isn't entirely generic.

>
>> that most platforms decide to
>> use. Each platform has to select the option and it breaks if two
>> platforms implement __clk_get()/__clk_put() in conflicting ways.
> They should go away with the common clock stuff: they are there to deal
> with the implementation specific parts of struct clk, and as the common
> clock stuff sorts that out, these should be provided by the common clk.

Agreed. They should all be deleted and only one should exist.

>
> So any platform using the common clock will be compatible with any other
> platform using the common clock.
>
> If you somehow think that clkdev comes into that compatibility, you're
> wrong.  It doesn't.

I don't.

>
> And if you think that a private clk implementation could have a unified
> clk_get(), you're also barking mad.

I don't understand this. Maybe I'm barking mad already.

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

