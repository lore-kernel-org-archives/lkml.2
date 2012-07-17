Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754516Ab2GQPnb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 11:43:31 -0400
Received: from na3sys009aog121.obsmtp.com ([74.125.149.145]:55263 "EHLO
	na3sys009aog121.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751855Ab2GQPn3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 11:43:29 -0400
Date: Tue, 17 Jul 2012 08:42:54 -0700
From: Mike Turquette <mturquette@ti.com>
To: Prashant Gaikwad <pgaikwad@nvidia.com>
Cc: Mike Turquette <mturquette@linaro.org>, "paul@pwsan.com" <paul@pwsan.com>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "viresh.kumar@linaro.org" <viresh.kumar@linaro.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        "rnayak@ti.com" <rnayak@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "ccross@android.com" <ccross@android.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 2/2] [RFC] cpufreq: omap: scale regulator from clk
 notifier
Message-ID: <20120717154254.GA3340@gmail.com>
References: <1342225001-22962-1-git-send-email-mturquette@linaro.org>
 <1342225001-22962-3-git-send-email-mturquette@linaro.org>
 <5004F638.6020301@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5004F638.6020301@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20120717-10:50, Prashant Gaikwad wrote:
> On Saturday 14 July 2012 05:46 AM, Mike Turquette wrote:
> >+	/* scaling up?  scale voltage before frequency */
> >+	if (cnd->new_rate>  cnd->old_rate) {
> >+		dev_dbg(mpu_dev, "cpufreq-omap: %d mV -->  %d mV\n",
> >+				volt_old, volt_new);
> >+
> >+		ret = regulator_set_voltage(mpu_reg, volt_new - tol, volt_new + tol);
> >+
> >+		if (ret<  0) {
> >+			dev_warn(mpu_dev, "%s: unable to scale voltage up.\n",
> >+				 __func__);
> >+			return NOTIFY_BAD;
> >+		}
> >+	}
> >+
> >+	/* scaling down?  scale voltage after frequency */
> >+	if (cnd->new_rate<  cnd->old_rate) {
> >+		dev_dbg(mpu_dev, "cpufreq-omap: %d mV -->  %d mV\n",
> >+				volt_old, volt_new);
> >+
> >+		ret = regulator_set_voltage(mpu_reg, volt_new - tol, volt_new + tol);
> >+
> >+		if (ret<  0) {
> >+			dev_warn(mpu_dev, "%s: unable to scale voltage down.\n",
> >+				 __func__);
> >+			return NOTIFY_BAD;
> >+		}
> >  	}
> 
> How are you checking pre and post rate change condition here? Need
> switch case for event?
>

Oops.  This version of the patch is missing that.  I previously had a
version of the patch which did pre/post checking but all of this code
was in arch/arm/mach-omap2/.  It looks like when I moved things around I
accidentally dropped that bit.

Anyways that is trivial to do and simply changes like the following:

if (cnd->new_rate > cnd->old_rate && flags & CLK_PRE_RATE_CHANGE)
	...

if (cnd->new_rate < cnd->old_rate && flags & CLK_POST_RATE_CHANGE)
	...

Regards,
Mike
