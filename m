Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756138Ab1LAS0V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 13:26:21 -0500
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:53903 "EHLO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756016Ab1LAS0T convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 13:26:19 -0500
MIME-Version: 1.0
In-Reply-To: <20111201144205.GA2103@sirena.org.uk>
References: <1321926047-14211-1-git-send-email-mturquette@linaro.org>
 <1321926047-14211-4-git-send-email-mturquette@linaro.org> <alpine.DEB.2.00.1111291619110.6289@utopia.booyaka.com>
 <CAJOA=zM4vcyTt_RBEVm6JxmzW-Dna0gpuWda7ytq_mqFSuXw9g@mail.gmail.com>
 <alpine.DEB.2.00.1111302308280.6289@utopia.booyaka.com> <20111201144205.GA2103@sirena.org.uk>
From: "Turquette, Mike" <mturquette@ti.com>
Date: Thu, 1 Dec 2011 10:25:57 -0800
Message-ID: <CAJOA=zNeieTufhYjWCC-ortNQ1B0e3f515uvU5v5uKBuCUTXnQ@mail.gmail.com>
Subject: Re: [PATCH v3 3/5] clk: introduce the common clock framework
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Paul Walmsley <paul@pwsan.com>, linux@arm.linux.org.uk,
        linus.walleij@stericsson.com, patches@linaro.org,
        shawn.guo@freescale.com, magnus.damm@gmail.com,
        linux-kernel@vger.kernel.org, amit.kucheria@linaro.org,
        richard.zhao@linaro.org, grant.likely@secretlab.ca, dsaxena@linaro.org,
        eric.miao@linaro.org, sboyd@quicinc.com, skannan@quicinc.com,
        linaro-dev@lists.linaro.org, jeremy.kerr@canonical.com,
        linux-omap@vger.kernel.org, tglx@linutronix.de,
        linux-arm-kernel@lists.infradead.org, arnd.bergmann@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 1, 2011 at 6:42 AM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Wed, Nov 30, 2011 at 11:39:59PM -0700, Paul Walmsley wrote:
>
>> Clock rate/parent-change notifiers are requirements for DVFS use-cases,
>> and they must be paired with something like the
>> clk_{allow,block}_rate_change() functions to work efficiently.  I intend
>> to comment on this later; it's not a simple problem.  It might be worth
>> noting that Tero and I implemented a simplified version of this for the
>> N900.
>
> I'm thinking that if we're going to have clk_{allow,block}_rate_change()
> we may as well make that the main interface to enable rate changes - if
> a device wants to change the clock rate it allows rate changes using
> that interface rather than by disabling the clocks.  I've got devices
> which can do glitch free updates of active clocks so having to disable
> would be a real restriction, and cpufreq would have issues with actually
> disabling the clock too I expect.
>

I agree that imposing a "disable clk before changing rate" policy in
the framework core is a bad idea.  During discussion on the
CLK_GATE_SET_RATE flag in the patch #2 Shawn commented that he has
some clks that must be enabled to change their rates (I assume he
means PLLs but that detail doesn't really matter).

Regards,
Mike
