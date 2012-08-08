Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756059Ab2HHODi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 10:03:38 -0400
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:37279 "EHLO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755594Ab2HHODe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 10:03:34 -0400
MIME-Version: 1.0
In-Reply-To: <1344434316-21141-1-git-send-email-tarun.kanti@ti.com>
References: <1344434316-21141-1-git-send-email-tarun.kanti@ti.com>
From: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>
Date: Wed, 8 Aug 2012 19:33:12 +0530
Message-ID: <CAMQu2gzi0_NS_W_DN=D=+3n6sNw_NTfkaNzaqV3QPG4mL+RoRg@mail.gmail.com>
Subject: Re: [PATCH v2] gpio/omap: add *remove* callback in platform_driver
To: Tarun Kanti DebBarma <tarun.kanti@ti.com>
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Kevin Hilman <khilman@ti.com>,
        Rajendra Nayak <rnayak@ti.com>, "Cousson, Benoit" <b-cousson@ti.com>,
        Paul Walmsley <paul@pwsan.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 8, 2012 at 7:28 PM, Tarun Kanti DebBarma <tarun.kanti@ti.com> wrote:
> Add *remove* callback so that necessary cleanup operations are
> performed when device is unregistered. The device is deleted
> from the list and associated clock handle is released by
> calling clk_put() and irq descriptor is released using the
> irq_free_desc() api.
>
> Signed-off-by: Tarun Kanti DebBarma <tarun.kanti@ti.com>
> Reported-by: Paul Walmsley <paul@pwsan.com>
> Reviewed-by: Jon Hunter <jon-hunter@ti.com>
> Cc: Kevin Hilman <khilman@ti.com>
> Cc: Rajendra Nayak <rnayak@ti.com>
> Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
> Cc: Cousson, Benoit <b-cousson@ti.com>
> Cc: Paul Walmsley <paul@pwsan.com>
> ---
> v2:
> Baseline: git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
> Commit: 0d7614f09c1ebdbaa1599a5aba7593f147bf96ee (Linux 3.6-rc1)
>
> (1) Use irq_free_descs() instead of irq_free_desc().
>     Besides, irq_free_desc() was using wrong parameter,
>     irq_base, instead of bank->irq.
> (2) irq_free_descs() moved outside spin_lock/unlock_*()
>     in order to avoid exception warnings.
>
> (3) pm_runtime_disable() added so that bind can happen successfully
>
> Test Detail:
> Step 1: Unbind gpio.5 device in order to invoke the *remove* callback.
> #echo "omap_gpio.5" > sys/bus/platform/drivers/omap_gpio/unbind
>
> Step 2: Bind gpio.5 device and confirm probe() for the device succeeds.
> #echo "omap_gpio.5" > sys/bus/platform/drivers/omap_gpio/bind
>
> Step 3: Execute read/write GPIO test case.
>
Thanks details about test. Whe  you to "Unbind->bind", do
you see that PM is not broken.

In other words, can you also test and ensure that the OMAP3 suspend and
CPUIDLE are not broken because of this patch.
PER and CORE domains should transition to low power states.

Regards
Santosh
