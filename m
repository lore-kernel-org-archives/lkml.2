Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755834Ab2JVRNE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 13:13:04 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:57371 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755566Ab2JVRNC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 13:13:02 -0400
MIME-Version: 1.0
In-Reply-To: <50831CA3.2020602@linaro.org>
References: <507FBC20.50004@linaro.org>
	<1350683446-8244-1-git-send-email-jwerner@chromium.org>
	<50831CA3.2020602@linaro.org>
Date: Mon, 22 Oct 2012 10:13:01 -0700
X-Google-Sender-Auth: agWaCgLdgApCzpOErUpJvb71Gsk
Message-ID: <CAODwPW-bnECEawh9sOwhydDodD+J4x2s4f5uHpeLusuBx-itxw@mail.gmail.com>
Subject: Re: [PATCH] acpi/cpuidle: reinitialize power_usage values when
 adding/removing C-states
From: Julius Werner <jwerner@chromium.org>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: linux-kernel@vger.kernel.org, len.brown@intel.com, khilman@ti.com,
        rjw@sisk.pl, deepthi@linux.vnet.ibm.com, akpm@linux-foundation.org,
        Trinabh Gupta <g.trinabh@gmail.com>, snanda@chromium.org,
        Lists Linaro-dev <linaro-dev@lists.linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Could we just say this is always true because state[i+1] consumes less
> than state[i] ?
>
> And then just remove the 'set_power_state' function, and the field
> 'driver->power_specified' ?
>
> That will cleanup the code and fix this problem, no ?

I totally agree with your analysis. Even if a driver were to set
proper usage values (and the power_specified bit), none of the
existing governors would care about those actual numbers (and since
the vast majority of drivers uses fake values anyway, this is not
likely to change in the future). This seems to be a classic example of
unnecessary over-engineering.

I am mostly interested in getting that bug fixed right now, but
removing unnecessary code is always a good thing. If you think it
would have a good chance of getting merged, I would be happy to draft
up a larger patch that refactors power_usage away completely.
