Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751938Ab2LWLvc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2012 06:51:32 -0500
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:46915 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750947Ab2LWLvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2012 06:51:31 -0500
X-Greylist: delayed 1098 seconds by postgrey-1.27 at vger.kernel.org; Sun, 23 Dec 2012 06:51:30 EST
Date: Sun, 23 Dec 2012 11:32:39 +0000
From: Will Deacon <will.deacon@arm.com>
To: Pratik Patel <pratikp@codeaurora.org>
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
Message-ID: <20121223113239.GG16237@mudshark.cambridge.arm.com>
References: <1355858365-11849-1-git-send-email-pratikp@codeaurora.org>
 <20121219112314.GA26329@mudshark.cambridge.arm.com>
 <50D1F37E.6000804@ti.com>
 <20121219212431.GC23594@pratikp-linux.qualcomm.com>
 <50D34EE5.8090407@ti.com>
 <20121220195127.GA14877@pratikp-linux.qualcomm.com>
 <50D3972E.4030607@ti.com>
 <20121221221828.GA2658@pratikp-linux.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121221221828.GA2658@pratikp-linux.qualcomm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 21, 2012 at 10:18:28PM +0000, Pratik Patel wrote:
> What user interface do you plan to provide for the CTI? Maybe
> something consistent with other CoreSight components in sysfs to
> allow users to enable, disable, map and unmap ???
> 
> Please let me know your thoughts.

Rather than have your current approach of dev nodes + sysfs config files for
each coresight device, I think it might be better to follow something closer
to ftrace and stick per-device directories under debugfs/coresight/. Then you
can have a pipe file and some config files in the same directory for each
component. You also don't need to do any mapping operations with this (just
post-process the stream directly).

It might also be fun to play with file redirection for sources and sinks, but
that's probably a bit too invasive.

Will
