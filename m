Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757233Ab2CUAK6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 20:10:58 -0400
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:60242 "EHLO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752451Ab2CUAK5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 20:10:57 -0400
From: Kevin Hilman <khilman@ti.com>
To: Robert Lee <rob.lee@linaro.org>
Cc: len.brown@intel.com, akpm@linux-foundation.org, rjw@sisk.pl,
        robherring2@gmail.com, Baohua.Song@csr.com, amit.kucheria@linaro.org,
        nicolas.ferre@atmel.com, linux@maxim.org.za, kgene.kim@samsung.com,
        amit.kachhap@linaro.org, magnus.damm@gmail.com, nsekhar@ti.com,
        daniel.lezcano@linaro.org, mturquette@linaro.org,
        vincent.guittot@linaro.org, arnd.bergmann@linaro.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linaro-dev@lists.linaro.org, patches@linaro.org,
        deepthi@linux.vnet.ibm.com, broonie@opensource.wolfsonmicro.com,
        nicolas.pitre@linaro.org, linux@arm.linux.org.uk,
        jean.pihet@newoldbits.com, venki@google.com, ccross@google.com,
        g.trinabh@gmail.com, kernel@wantstofly.org, lethal@linux-sh.org,
        jon-hunter@ti.com, tony@atomide.com, linux-omap@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [PATCH v8 0/8] Consolidate cpuidle functionality
Organization: Texas Instruments, Inc.
References: <1332274969-15782-1-git-send-email-rob.lee@linaro.org>
Date: Tue, 20 Mar 2012 17:10:52 -0700
In-Reply-To: <1332274969-15782-1-git-send-email-rob.lee@linaro.org> (Robert
	Lee's message of "Tue, 20 Mar 2012 15:22:41 -0500")
Message-ID: <87wr6evmnn.fsf@ti.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rob,

Robert Lee <rob.lee@linaro.org> writes:

> This patch series moves various functionality duplicated in platform 
> cpuidle drivers to the core cpuidle driver. Also, the platform irq
> disabling was removed as it appears that all calls into 
> cpuidle_call_idle will have already called local_irq_disable().
>
> These changes have been pulled into linux-next.
>
> Len, Andrew, can a request be made for Linus to pull these changes?
>
> Acked-by: Jean Pihet<j-pihet@ti.com>  (v6)
> Tested-by: Jean Pihet<j-pihet@ti.com>  (v6, omap3)
> Tested-by: Amit Daniel<amit.kachhap@linaro.org>  (v6, Exynos4)
> Tested-by: Robert Lee<rob.lee@linaro.org>  (imx51, imx6q)

Note that there's a space missing between the name and email in these
tags (and for Deepthi's below also.)  That seems to exist in all the
patches.

> Reviewed-by: Kevin Hilman <khilman@ti.com>

For my Reviewed-by, it only applies to the core code and the OMAP
changes.  I haven't reviewed the other platform-specific drivers.  I
believe the same applies to Jean Pihet who works with me on OMAP.

> Reviewed-by: Daniel Lezcano <daniel.lezcano@linaro.org>
> Reviewed-by: Deepthi Dharwar<deepthi@linux.vnet.ibm.com> (core cpuidle only)

Looks like you never heard from anyone actively working on at91,
shmobile, kirwood or davinci.

I'm not sure we should merge those platform-specific changes without an
ack from those platform maintainers.

For 3.4, maybe we should just merge the core code and the platforms that
have been reviewed/ack'd, and for 3.5, spent some time nagging the other
platform maintainers to review and test.

Kevin

