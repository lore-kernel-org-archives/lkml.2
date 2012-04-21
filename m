Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751515Ab2DUNrQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2012 09:47:16 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:45399 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751084Ab2DUNrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2012 09:47:15 -0400
MIME-Version: 1.0
In-Reply-To: <20120421124219.GH24211@n2100.arm.linux.org.uk>
References: <cover.1335008617.git.viresh.kumar@st.com>
	<f48165b92f52e9a879cedacaddc548ac885bf73d.1335008617.git.viresh.kumar@st.com>
	<20120421124219.GH24211@n2100.arm.linux.org.uk>
Date: Sat, 21 Apr 2012 19:17:13 +0530
Message-ID: <CAOh2x=mcFFDHVkm71OC30TrbQTvay-QuCraKQ7gGyUQspQ43Kw@mail.gmail.com>
Subject: Re: [PATCH 01/13] clk: Add non CONFIG_HAVE_CLK routines
From: viresh kumar <viresh.linux@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: akpm@linux-foundation.org, mturquette@linaro.org, sshtylyov@mvista.com,
        spear-devel@list.st.com, linux-kernel@vger.kernel.org,
        jgarzik@redhat.com, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/21/12, Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:
> On Sat, Apr 21, 2012 at 05:17:28PM +0530, Viresh Kumar wrote:
>> Many drivers are shared between architectures that may or may not have
>> HAVE_CLK
>> selected for them. To remove compilation errors for them we enclose
>> clk_*()
>> calls in these drivers within #ifdef CONFIG_HAVE_CLK, #endif.
>
> All you're doing is making drivers buildable.  Drivers will not be usable
> with this (they'll error out because clk_get() will fail.)
>
> For example:
>
> -#ifndef CONFIG_HAVE_CLK
> -/* Dummy stub for clk framework */
> -#define clk_get(dev, id)       NULL
> -#define clk_put(clock)         do {} while (0)
> -#define clk_enable(clock)      do {} while (0)
> -#define clk_disable(clock)     do {} while (0)
> -#endif
> -
>
> along with your change in this patch changes the drivers behaviour.

I tried to take care of these issues, but unfortunately
i couldn't.

Patch numbers 6, 12 & 13 will actually break drivers. Will ask Andrew
to drop them.

> A better solution would be to assume that if HAVE_CLK is not set, then
> that means there's no control over clocks, and therefore the clk API
> should become totally transparent and non-failure inducing.  So, having
> clk_get() return NULL, and having all the other clk API functions ignore
> their argument (just like the macros above) is the right solution here.

Will leave these macros as is for mentioned patches.

--
viresh
