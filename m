Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934350Ab2JXQFT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 12:05:19 -0400
Received: from service87.mimecast.com ([91.220.42.44]:43060 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932280Ab2JXQFQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 12:05:16 -0400
Message-ID: <1351094711.23327.47.camel@hornet>
Subject: Re: [RFC] Energy/power monitoring within the kernel
From: Pawel Moll <pawel.moll@arm.com>
To: Andy Green <andy.green@linaro.org>
Cc: Amit Daniel Kachhap <amit.kachhap@linaro.org>,
        Zhang Rui <rui.zhang@intel.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Jean Delvare <khali@linux-fr.org>, Guenter Roeck <linux@roeck-us.net>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Jesper Juhl <jj@chaosbits.net>, Thomas Renninger <trenn@suse.de>,
        Jean Pihet <jean.pihet@newoldbits.com>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>
Date: Wed, 24 Oct 2012 17:05:11 +0100
In-Reply-To: <5086E6D6.8000208@linaro.org>
References: <1351013449.9070.5.camel@hornet> <5086E6D6.8000208@linaro.org>
X-Mailer: Evolution 3.6.0-0ubuntu3
Mime-Version: 1.0
X-OriginalArrivalTime: 24 Oct 2012 16:05:12.0523 (UTC) FILETIME=[5938F9B0:01CDB201]
X-MC-Unique: 112102417051500601
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-10-23 at 19:49 +0100, Andy Green wrote:
> A thought on that... from an SoC perspective there are other interesting 
> power rails than go to just the CPU core.  For example DDR power and 
> rails involved with other IP units on the SoC such as 3D graphics unit. 
>   So tying one number to specifically a CPU core does not sound like 
> it's enough.

I do realize this. I just didn't want to try to cover too much ground,
and cpufreq governor would be interested in cpu-related data anyway...

> If you turn the problem upside down to solve the representation question 
> first, maybe there's a way forward defining the "power tree" in terms of 
> regulators, and then adding something in struct regulator that spams 
> readers with timestamped results if the regulator has a power monitoring 
> capability.
> 
> Then you can map the regulators in the power tree to real devices by the 
> names or the supply stuff.  Just a thought.

Hm. Interesting idea indeed - if a regulator device was able to report
the energy being produced by it (instead of looking at cumulative energy
consumed by more than one device), defining "power domains" (by adding
selected cpus as consumers) would be straight forward and the cpufreq
could request the information that way.

I'll look into it, thanks!

Paweł


