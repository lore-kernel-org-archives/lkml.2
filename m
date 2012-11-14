Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933034Ab2KNRQB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 12:16:01 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:64618 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933000Ab2KNRP7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 12:15:59 -0500
MIME-Version: 1.0
In-Reply-To: <50A37ADD.8040000@linaro.org>
References: <1352843563-16392-1-git-send-email-jwerner@chromium.org>
	<50A37ADD.8040000@linaro.org>
Date: Wed, 14 Nov 2012 09:15:58 -0800
X-Google-Sender-Auth: eimobxR5PetcoCRf4EHfCes7nU4
Message-ID: <CAODwPW873M32d9zFT9fpJT9+PuMbz8htzUxdF1TNE+J1zR3jYA@mail.gmail.com>
Subject: Re: [PATCH] cpuidle: Measure idle state durations with monotonic clock
From: Julius Werner <jwerner@chromium.org>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: linux-kernel@vger.kernel.org, Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Kevin Hilman <khilman@ti.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org,
        Deepthi Dharwar <deepthi@linux.vnet.ibm.com>,
        Trinabh Gupta <g.trinabh@gmail.com>,
        Sameer Nanda <snanda@chromium.org>,
        Lists Linaro-dev <linaro-dev@lists.linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Maybe you can remove all these computations and set the flag
> en_core_tk_irqen for the driver ? That will be handled by the cpuidle
> framework, no ?
>
> Same comment for the intel_idle driver.

Yeah, I thought about that, too. I was a little too afraid of touching
the sched_clock_idle_wakeup_event() parameter that is tied to the
measurement, but it seems to have been vestigial for some time now and
other drivers also just set it 0. I will whip up another version of
the patch (won't change the PPC further though, if this version works
I would just leave it at that... thanks for testing, Deepthi).
