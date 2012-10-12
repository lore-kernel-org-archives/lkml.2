Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759828Ab2JLQfw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 12:35:52 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:52182 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759809Ab2JLQfu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 12:35:50 -0400
From: Kevin Hilman <khilman@deeprootsystems.com>
To: Sourav <sourav.poddar@ti.com>
Cc: Paul Walmsley <paul@pwsan.com>, Felipe Balbi <balbi@ti.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        <gregkh@linuxfoundation.org>, <tony@atomide.com>,
        <linux-kernel@vger.kernel.org>, <santosh.shilimkar@ti.com>,
        <linux-serial@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <alan@linux.intel.com>
Subject: Re: [RFT/PATCH] serial: omap: prevent resume if device is not suspended.
Organization: Deep Root Systems, LLC
References: <1347972050-3509-1-git-send-email-sourav.poddar@ti.com>
	<CAKdam572krJZcayRdJ_AciCUZH3LuzD9yoHenhxrB6j9xDZ6JQ@mail.gmail.com>
	<20120925083029.GG31374@n2100.arm.linux.org.uk>
	<20120925083118.GI9137@arwen.pp.htv.fi>
	<20120925091228.GI31374@n2100.arm.linux.org.uk>
	<20120925091112.GK9137@arwen.pp.htv.fi>
	<20120925092118.GJ31374@n2100.arm.linux.org.uk>
	<CAKdam57bpTJ94Gn=mKVw1Fm-76fVPp3DGjFuNu_HfesybM1hPg@mail.gmail.com>
	<87ipas2y4h.fsf@deeprootsystems.com>
	<alpine.DEB.2.00.1210111748010.5736@utopia.booyaka.com>
	<50784458.9080806@ti.com>
Date: Fri, 12 Oct 2012 09:35:54 -0700
In-Reply-To: <50784458.9080806@ti.com> (Sourav's message of "Fri, 12 Oct 2012
	21:54:56 +0530")
Message-ID: <877gqv7imt.fsf@deeprootsystems.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sourav <sourav.poddar@ti.com> writes:

> Hi Paul,
>
> There are
> On Thursday 11 October 2012 11:58 PM, Paul Walmsley wrote:
>> Hi Sourav, Felipe,
>>
>> any progress on fixing the N800 problem?  Would be good to keep it booting
>> since we use it as our primary 2420 test platform.
>>
>>
>> - Paul
> The patch sent inlined below might help us to get rid of the serial
> init issue.
> Unfortunately, I dont have a N800 board with me to test it and will require
> your help to do so.
> -----------
> From: Sourav Poddar <sourav.poddar@ti.com>
> Date: Wed, 1 Aug 2012 15:44:12 +0530
> Subject: [RFT/PATCH] serial: omap: Fix N800 serial init issue.
>
>
> This patch might solve the N800 serial init issue.
>
> This patch will also give pointers if there is any mux settings issue
> with N800 OR
> a mismatch between the initial harware state, runtime PM state and
> omap hwmod state.

> I don't have a N800 schematics to check about the mux settings getting used.
>
> The observation on beagle board XM with this patch on different boards
> looks flaky,
> so your feedback on beagle board will also be very helpful.
>
> Cc: Felipe Balbi <balbi@ti.com>
> Signed-off-by: Sourav Poddar <sourav.poddar@ti.com>
> ---
>  drivers/tty/serial/omap-serial.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/tty/serial/omap-serial.c
> b/drivers/tty/serial/omap-serial.c
> index 6ede6fd..3fbc7f7 100644
> --- a/drivers/tty/serial/omap-serial.c
> +++ b/drivers/tty/serial/omap-serial.c
> @@ -1414,6 +1414,7 @@ static int __devinit serial_omap_probe(struct
> platform_device *pdev)
>         INIT_WORK(&up->qos_work, serial_omap_uart_qos_work);
>
>         platform_set_drvdata(pdev, up);
> +       pm_runtime_set_active(&pdev->dev);

NAK.

This will obviously break platforms where the UARTs are not active
before driver loads.

Kevin

>         pm_runtime_enable(&pdev->dev);
>         pm_runtime_use_autosuspend(&pdev->dev);
>         pm_runtime_set_autosuspend_delay(&pdev->dev,
