Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753682Ab3ACSGx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 13:06:53 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:12277 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753475Ab3ACSGv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 13:06:51 -0500
X-IronPort-AV: E=Sophos;i="4.84,404,1355126400"; 
   d="scan'208";a="17681943"
Date: Thu, 3 Jan 2013 10:06:43 -0800
From: Pratik Patel <pratikp@codeaurora.org>
To: Will Deacon <will.deacon@arm.com>
Cc: Jon Hunter <jon-hunter@ti.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "magnus.p.persson@stericsson.com" <magnus.p.persson@stericsson.com>,
        "david.rusling@linaro.org" <david.rusling@linaro.org>,
        "arve@android.com" <arve@android.com>,
        "dsaxena@linaro.org" <dsaxena@linaro.org>,
        "john.stultz@linaro.org" <john.stultz@linaro.org>,
        "d-deao@ti.com" <d-deao@ti.com>,
        "christian.bejram@stericsson.com" <christian.bejram@stericsson.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: CoreSight framework and drivers
Message-ID: <20130103180643.GA30277@pratikp-linux.qualcomm.com>
References: <1355858365-11849-1-git-send-email-pratikp@codeaurora.org>
 <20121219112314.GA26329@mudshark.cambridge.arm.com>
 <50D1F37E.6000804@ti.com>
 <20121219212431.GC23594@pratikp-linux.qualcomm.com>
 <50D34EE5.8090407@ti.com>
 <20121220195127.GA14877@pratikp-linux.qualcomm.com>
 <50D3972E.4030607@ti.com>
 <20121221221828.GA2658@pratikp-linux.qualcomm.com>
 <20121223113239.GG16237@mudshark.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121223113239.GG16237@mudshark.cambridge.arm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 23, 2012 at 11:32:39AM +0000, Will Deacon wrote:
> On Fri, Dec 21, 2012 at 10:18:28PM +0000, Pratik Patel wrote:
> > What user interface do you plan to provide for the CTI? Maybe
> > something consistent with other CoreSight components in sysfs to
> > allow users to enable, disable, map and unmap ???
> > 
> > Please let me know your thoughts.
> 
> Rather than have your current approach of dev nodes + sysfs config files for
> each coresight device, I think it might be better to follow something closer
> to ftrace and stick per-device directories under debugfs/coresight/. Then you
> can have a pipe file and some config files in the same directory for each
> component. You also don't need to do any mapping operations with this (just
> post-process the stream directly).
> 

Thanks for the suggestion. I had initially debated between debugfs
and sysfs but chose sysfs + dev nodes since using device attributes
relieves the drivers from manually managing directories and files,
its taken care of by the device and sysfs layers. Moreover, since
these are physical devices, device attributes made sense at the
time.

The map and unmap I was referring to was for the CTI trigger
mappings. Dev nodes are currently intended to provide the raw
data collected in the sinks.

Whats the advantage in using debugfs here?

> It might also be fun to play with file redirection for sources and sinks, but
> that's probably a bit too invasive.
> 
> Will

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
