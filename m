Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754813Ab1H2SuP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 14:50:15 -0400
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:50920 "EHLO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753945Ab1H2SuM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 14:50:12 -0400
From: Kevin Hilman <khilman@ti.com>
To: Keshava Munegowda <keshava_mgowda@ti.com>
Cc: linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, balbi@ti.com, gadiyar@ti.com,
        sameo@linux.intel.com, parthab@india.ti.com, tony@atomide.com,
        b-cousson@ti.com, paul@pwsan.com, johnstul@us.ibm.com,
        vishwanath.bs@ti.com, Keshava Munegowda <Keshava_mgowda@ti.com>,
        Jassi Brar <jaswinder.singh@linaro.org>
Subject: Re: [PATCH 5/5 v4] mfd: omap: usb: Runtime PM support
Organization: Texas Instruments, Inc.
References: <1312899309-24067-1-git-send-email-keshava_mgowda@ti.com>
	<1312899309-24067-2-git-send-email-keshava_mgowda@ti.com>
	<1312899309-24067-3-git-send-email-keshava_mgowda@ti.com>
	<1312899309-24067-4-git-send-email-keshava_mgowda@ti.com>
	<1312899309-24067-5-git-send-email-keshava_mgowda@ti.com>
	<1312899309-24067-6-git-send-email-keshava_mgowda@ti.com>
Date: Mon, 29 Aug 2011 11:50:03 -0700
In-Reply-To: <1312899309-24067-6-git-send-email-keshava_mgowda@ti.com>
	(Keshava Munegowda's message of "Tue, 9 Aug 2011 19:45:09 +0530")
Message-ID: <87mxesrr1g.fsf@ti.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Keshava Munegowda <keshava_mgowda@ti.com> writes:

> From: Keshava Munegowda <Keshava_mgowda@ti.com>
>
> The usbhs core driver does not enable/disable the intefrace and
> fucntional clocks; These clocks are handled by hwmod and runtime pm,
> hence insted of the clock enable/disable, the runtime pm APIS are
> used. however,the port clocks are handled by the usbhs core.
>
> Signed-off-by: Keshava Munegowda <keshava_mgowda@ti.com>

General comment: all usage of pm_runtime_put_sync() can likely be
replaced by the asynchronous versions.  I don't currently see why the
synchronous verions are needed here.

Other than that, the runtime PM parts of this look OK to me.  After
changing to asynchonous puts, feel free to add:

Reviewed-by: Kevin Hilman <khilman@ti.com>


Also, after a quick glance, it looks like this version of the series
addresses the problems seen by Jassi Brar with the TLL reset[1].  Please
confirm.

Speaking of which, it's helpful to Cc folks who have had comments on
previous versions of your series so they are sure they're previous
issues are addressed.   I've Cc'd Jassi Brar.

Thanks,

Kevin

[1] http://marc.info/?l=linux-omap&m=130921260703865&w=2

