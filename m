Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753408Ab2K2EfB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 23:35:01 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:52949 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752896Ab2K2Ee7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 23:34:59 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Shawn Guo <shawn.guo@linaro.org>
From: Mike Turquette <mturquette@ti.com>
In-Reply-To: <20121129015133.GD28170@S2100-06.ap.freescale.net>
CC: Mark Langsdorf <mark.langsdorf@calxeda.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
References: <1351631056-25938-1-git-send-email-mark.langsdorf@calxeda.com>
 <1354046672-7392-1-git-send-email-mark.langsdorf@calxeda.com>
 <1354046672-7392-7-git-send-email-mark.langsdorf@calxeda.com>
 <20121128023240.GA28170@S2100-06.ap.freescale.net>
 <50B60E9C.9000405@calxeda.com>
 <20121128145759.GB28170@S2100-06.ap.freescale.net>
 <20121128151741.GC28170@S2100-06.ap.freescale.net>
 <20121128160115.21126.3841@nucleus>
 <20121129015133.GD28170@S2100-06.ap.freescale.net>
Message-ID: <20121129043436.21126.714@nucleus>
User-Agent: alot/0.3.2+
Subject: Re: [PATCH 6/6 v6] cpufreq, highbank: add support for highbank cpufreq
Date: Wed, 28 Nov 2012 20:34:36 -0800
X-Originating-IP: [10.188.36.112]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Shawn Guo (2012-11-28 17:51:36)
> > The notifiers in the clk framework might be a better place for this than
> > just simply hacking the logic into the .set_rate callback.
> 
> Ah, right.  How did I forget about that nice piece?
> 
> > I haven't looked at the definition of hb_voltage_change but does the
> > call graph make any clk api calls?  Are you talking over i2c to a
> > regulator?  If so then you'll probably hit the same reentrancy problem I
> > hit when trying to make a general solution.
> 
> So, how is your "reentrancy in the common clk framework" series[1]
> going on?  Haven't seen any update since August.
> 

I've begun to look at a dvfs api that builds on top of the clock
framework, as opposed to using clk_set_rate as the dvfs api itself.
This eliminates the need for reentrancy, at least for the dvfs case.

I'll post more when I have it.  Honestly the reentrancy stuff was just
too ugly.  I might try again some day but for now I'm thinking a less
radical approach deserves consideration.

Thanks,
Mike

> Shawn
> 
> [1] http://thread.gmane.org/gmane.linux.ports.arm.kernel/182198
