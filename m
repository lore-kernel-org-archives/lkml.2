Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751359Ab2LSVHJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 16:07:09 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:25419 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751124Ab2LSVHA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 16:07:00 -0500
X-IronPort-AV: E=Sophos;i="4.84,318,1355126400"; 
   d="scan'208";a="15269215"
Date: Wed, 19 Dec 2012 13:06:54 -0800
From: Pratik Patel <pratikp@codeaurora.org>
To: Will Deacon <will.deacon@arm.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "magnus.p.persson@stericsson.com" <magnus.p.persson@stericsson.com>,
        "arve@android.com" <arve@android.com>,
        "jon-hunter@ti.com" <jon-hunter@ti.com>,
        "david.rusling@linaro.org" <david.rusling@linaro.org>,
        "dsaxena@linaro.org" <dsaxena@linaro.org>,
        "john.stultz@linaro.org" <john.stultz@linaro.org>,
        "d-deao@ti.com" <d-deao@ti.com>,
        "christian.bejram@stericsson.com" <christian.bejram@stericsson.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: CoreSight framework and drivers
Message-ID: <20121219210654.GA524@pratikp-linux.qualcomm.com>
References: <1355858365-11849-1-git-send-email-pratikp@codeaurora.org>
 <20121219112314.GA26329@mudshark.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121219112314.GA26329@mudshark.cambridge.arm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 19, 2012 at 11:23:14AM +0000, Will Deacon wrote:
> Hi Pratik,
> 
> On Tue, Dec 18, 2012 at 07:19:17PM +0000, pratikp@codeaurora.org wrote:
> > This RFC is aimed at introducing CoreSight framework as well as
> > individual CoreSight trace component drivers adhering to ARM
> > CoreSight specification. Some prior discussion on this can be
> > referred at [1].
> > 
> > There are 3 kinds of CoreSight trace components:
> > 
> > * Sources: Responsible for producing trace data to provide
> >   visibility for the associated entity.
> > 
> > * Links: Transport components that carry trace data.
> > 
> > * Sinks: Collectors for storing trace data or acting as conduits
> >   for off-chip trace data collection.
> > 
> > These components can be connected in various topologies to suite
> > a particular SoCs tracing needs.
> > 
> > Framework is responsible for gathering and using the information
> > about the registered CoreSight components and their connections
> > to allow it to dynamically deduce the sequence of components
> > representing a connection from a CoreSight source to the
> > currently selected CoreSight sink. This helps the framework to
> > program the correct set of components to satisfy user request.
> 
> From a million miles up, this looks like a sensible sort of design but I
> really think you need to talk to Jon Hunter (he's at least on CC) about
> this, especially where bindings are concerned. If we can get something that
> you both agree on, then we can include the CTI with the other coresight
> components and do a more in-depth review at that point.
> 

Thanks for the feedback.

> Finally, how do you plan on exposing this data to the user? I think the only
> sane way is to have per-device file descriptors which act as pipes to the raw
> data but this means we need some readily available, open-source tooling (or
> at least public specifications of the trace formats).
> 

The sink drivers (ETB, TMC), expose a device node per device that
is used to collect the raw data.

Eg:, we have:
/dev/coresight-etb
/dev/coresight-tmc-etf
/dev/coresight-tmc-etr

where reading /dev/coresight-tmc-etf only works when the ETF is
in circular buffer mode.

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
