Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758689Ab2JXQAk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 12:00:40 -0400
Received: from service87.mimecast.com ([91.220.42.44]:33126 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757859Ab2JXQAj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 12:00:39 -0400
Message-ID: <1351094432.23327.42.camel@hornet>
Subject: Re: [RFC] Energy/power monitoring within the kernel
From: Pawel Moll <pawel.moll@arm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Amit Daniel Kachhap <amit.kachhap@linaro.org>,
        Zhang Rui <rui.zhang@intel.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Jean Delvare <khali@linux-fr.org>, Guenter Roeck <linux@roeck-us.net>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Jesper Juhl <jj@chaosbits.net>, Thomas Renninger <trenn@suse.de>,
        Jean Pihet <jean.pihet@newoldbits.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>
Date: Wed, 24 Oct 2012 17:00:32 +0100
In-Reply-To: <1351014187.8467.24.camel@gandalf.local.home>
References: <1351013449.9070.5.camel@hornet>
	 <1351014187.8467.24.camel@gandalf.local.home>
X-Mailer: Evolution 3.6.0-0ubuntu3
Mime-Version: 1.0
X-OriginalArrivalTime: 24 Oct 2012 16:00:32.0822 (UTC) FILETIME=[B281FD60:01CDB200]
X-MC-Unique: 112102417003600801
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-10-23 at 18:43 +0100, Steven Rostedt wrote:
> > <...>212.673126: hwmon_attr_update: hwmon4 temp1_input 34361
> > 
> > One issue with this is that some external knowledge is required to
> > relate a number to a processor core. Or maybe it's not an issue at all
> > because it should be left for the user(space)?
> 
> If the external knowledge can be characterized in a userspace tool with
> the given data here, I see no issues with this.

Ok, fine.

> > 	TP_fast_assign(
> > 		memcpy(__entry->cpus, cpus, sizeof(struct cpumask));
> 
> Copying the entire cpumask seems like overkill. Especially when you have
> 4096 CPU machines.

Uh, right. I didn't consider such use case...

> Perhaps making a field that can be a subset of cpus may be better. That
> way we don't waste the ring buffer with lots of zeros. I'm guessing that
> it will only be a group of cpus, and not a scattered list? Of course,
> I've seen boxes where the cpu numbers went from core to core. That is,
> cpu 0 was on core 1, cpu 1 was on core 2, and then it would repeat. 
> cpu 8 was on core 1, cpu 9 was on core 2, etc.
> 
> But still, this could be compressed somehow.

Sure thing. Or I could simply use cpumask_scnprintf() on the assign
stage and keep an already-formatted string. Or, as the cpumask per
sensor would be de-facto constant, I could assume keep only a pointer to
it. Will keep it in mind if this event was supposed to happen.

Thanks!

Paweł



