Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756088Ab2DQOkq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 10:40:46 -0400
Received: from frodo.hserus.net ([204.74.68.40]:39251 "EHLO frodo.hserus.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753064Ab2DQOkp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 10:40:45 -0400
X-Greylist: delayed 1644 seconds by postgrey-1.27 at vger.kernel.org; Tue, 17 Apr 2012 10:40:45 EDT
Date: Tue, 17 Apr 2012 11:13:09 -0300
From: Christian Robottom Reis <kiko@linaro.org>
To: Rob Lee <rob.lee@linaro.org>
Cc: Sascha Hauer <s.hauer@pengutronix.de>, linaro-dev@lists.linaro.org,
        patches@linaro.org, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/3] ARM: imx: Add common imx cpuidle init functionality.
Message-ID: <20120417141309.GH11786@async.com.br>
References: <1334620214-25803-1-git-send-email-rob.lee@linaro.org>
 <1334620214-25803-2-git-send-email-rob.lee@linaro.org>
 <20120417074301.GM20478@pengutronix.de>
 <CAMXH7KH41kWMPu_dEpetZc8OUD3C0-mtxGbXX0Vqd4EODPWJUg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMXH7KH41kWMPu_dEpetZc8OUD3C0-mtxGbXX0Vqd4EODPWJUg@mail.gmail.com>
Organization: http://www.linaro.org/
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 17, 2012 at 08:54:03AM -0500, Rob Lee wrote:
> >> +void __init imx_cpuidle_set_driver(struct cpuidle_driver *p)
> >> +{
> >> +     drv = p;
> >> +}
> >
> > You like it complicated, eh? Why do you introduce a function which sets
> > a variable...
> 
> This complication is used to deal with the timing of various levels of
> init calls.  More explanation below.

Regardless of how you end up solving this, it's probably a good idea
to document the rationale, perhaps cribbing from what you describe
below..

> If I called imx_cpuidle_init directly from imx5 or imx6q init
> routines, it would be getting called before the coreinit_call of core
> cpuidle causing a failure.  There were various other directions to
> take and all seemed less desirable than this one.
> 
> One alternative would be to add a function to return the pointer to
> the cpuidle driver object based on the machine type.  Functionality
> exists to identify imx5 as a machine type but not imx6q, so I couldn't
> use that machine based method without adding that extra code.
> 
> Another alternative would be to add a general platform lateinit_call
> function to each platforms that support cpuidle.

..in a comment; without it, the code indeed looks bizarre.
-- 
Christian Robottom Reis, Engineering VP
Brazil (GMT-3) | [+55] 16 9112 6430 | [+1] 612 216 4935
Linaro.org: Open Source Software for ARM SoCs
