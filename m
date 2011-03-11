Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755539Ab1CKPUk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 10:20:40 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33978 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753842Ab1CKPUj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 10:20:39 -0500
Date: Fri, 11 Mar 2011 15:20:37 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>, linux-kernel@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH 1/4] regulator: add set_voltage_time[_sel]
 infrastructure
Message-ID: <20110311152037.GL1760@opensource.wolfsonmicro.com>
References: <1299840868-20613-1-git-send-email-linus.walleij@stericsson.com>
 <20110311122536.GG1760@opensource.wolfsonmicro.com>
 <AANLkTim+woyefRXw83RxEDFLmbxHKc25MPa7XQB2_fxE@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTim+woyefRXw83RxEDFLmbxHKc25MPa7XQB2_fxE@mail.gmail.com>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 11, 2011 at 03:45:39PM +0100, Linus Walleij wrote:
> On Fri, Mar 11, 2011 at 1:25 PM, Mark Brown

> +               /*
> +                * If we can't obtain the old selector there is not enough
> +                * info to call set_voltage_time_sel().
> +                */
> +               if (rdev->desc->ops->set_voltage_time_sel &&
> +                   rdev->desc->ops->get_voltage_sel) {
> +                       unsigned int old_selector = 0;
> +
> +                       ret = rdev->desc->ops->get_voltage_sel(rdev);
> +                       if (ret < 0)
> +                               return ret;
> +                       old_selector = ret;
> +                       delay = rdev->desc->ops->set_voltage_time_sel(rdev,
> +                                               old_selector, selector);
> +               }
> +

Hrm, right.  This means we can only support this for selector based
get_voltage().  That's probably fine, I think.

> > I also think we should be exporting this to consumers as things like
> > cpufreq are interested in the latency for voltage changes.

> Can we take that when we have a consumer that wants it? Looking
> at it it becomes rather complex, since consumers don't know the
> core-internal selectors, just discrete enumerated voltages, so these
> have to be mapped back to selectors etc, that's pretty much ovehead
> code that sits unused.

> (If you insist, I will implement it.)

Consumers know about the set of selectors as they are used to enumerate
the supported voltages via list_voltage().  An existing cpufreq driver
such as the s3c64xx one would be able to take advantage of this very
quickly.
