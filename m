Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932502Ab2JQSnh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 14:43:37 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:44512 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757447Ab2JQSnf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 14:43:35 -0400
MIME-Version: 1.0
In-Reply-To: <507E88F3.8070403@linaro.org>
References: <1350427184-11684-1-git-send-email-jwerner@chromium.org>
	<507E88F3.8070403@linaro.org>
Date: Wed, 17 Oct 2012 11:43:31 -0700
X-Google-Sender-Auth: mKVlkNQeJCurcErdZsu6M3EzI9o
Message-ID: <CAODwPW8CfgLQS+933ZQSueiat3QrAtRZh98h3iqtN8vxBOy=qg@mail.gmail.com>
Subject: Re: [PATCH] cpuidle: reinitialize power_usage values when
 adding/removing C-states
From: Julius Werner <jwerner@chromium.org>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: linux-kernel@vger.kernel.org, len.brown@intel.com, khilman@ti.com,
        rjw@sisk.pl, deepthi@linux.vnet.ibm.com, akpm@linux-foundation.org,
        g.trinabh@gmail.com, snanda@chromium.org,
        Lists Linaro-dev <linaro-dev@lists.linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This is specific to the acpi and should be handled in the
> processor_idle.c file instead of the cpuidle core code.
>
> Could be the function 'acpi_processor_cst_has_changed' the right place
> to set a dummy power value for the power in the new C-state ?

Thanks for your feedback. I think it wouldn't be wise to split the
dummy power value logic over two places, but I could submit a patch
that makes set_power_states globally accessible and calls it from
acpi_processor_cst_has_changed instead.

However, I do not think this should really be ACPI specific. It
applies to any cpuidle driver that wants to change its idle states at
runtime. Currently only the ACPI one does, but the future might bring
others that would run into the same problem. I also think that
set_power_states fits much better into cpuidle_enable_device
conceptually anyway (right next to poll_idle_init which also does
state initialization).

Let me know what you think.
