Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753560Ab3AJIe4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 03:34:56 -0500
Received: from mail-ob0-f182.google.com ([209.85.214.182]:57794 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752298Ab3AJIex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 03:34:53 -0500
MIME-Version: 1.0
In-Reply-To: <20130109153848.GT19691@intel.com>
References: <20130108155423.GJ19691@intel.com>
	<1357719435-29955-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1357719435-29955-2-git-send-email-andriy.shevchenko@linux.intel.com>
	<20130109134757.GN19691@intel.com>
	<CAHp75VfFyX=Pz3xRt15n6ffP=v0pa413BFF2zHGoiQowG1kKVg@mail.gmail.com>
	<20130109153848.GT19691@intel.com>
Date: Thu, 10 Jan 2013 14:04:53 +0530
Message-ID: <CAKohpo=8PKk0VF3tpZLNYseHMv7dF-qg9iwKcC+VmPtb_8kzjg@mail.gmail.com>
Subject: Re: [resend][PATCH 01/16] dw_dmac: call .probe after we have a device
 in place
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Andy Shevchenko <andriy.shevchenko@linux.jf.intel.com>,
        linux-kernel@vger.kernel.org, spear-devel <spear-devel@list.st.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9 January 2013 21:08, Vinod Koul <vinod.koul@intel.com> wrote:
>> >>  subsys_initcall(dw_init);
> Viresh, Linus
>
> We had this discussion sometime back. pl022 use dma and we need DMA before SPI.
> So if we have pl022 as late_init and dma as device_init. If we have one  more
> dependency then moving dw_dmac to fs_init should help too. But arch/subsys seems
> overkill here?

We probably can't make spi late_init as they may be others waiting for
it to be in. And
so did subsys_init for dma. fs is for filesystem? then that may not be
logically correct too.

What's the problem you are seeing here with subsys_init?
