Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751947Ab2DUGjD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2012 02:39:03 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:36496 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724Ab2DUGjA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2012 02:39:00 -0400
Date: Fri, 20 Apr 2012 23:38:55 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Ashish Jangam <ashish.jangam@kpitcummins.com>
Cc: sameo@linux.intel.com, m.grzeschik@pengutronix.de, randy.dunlap@oracle.com,
        linux-kernel@vger.kernel.org
Subject: Re: [Patch] Touch: DA9052/53 touch screen driver v2
Message-ID: <20120421063855.GA2360@core.coreip.homeip.net>
References: <1334924925.3752.14.camel@dhruva>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1334924925.3752.14.camel@dhruva>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ashish,

On Fri, Apr 20, 2012 at 05:58:45PM +0530, Ashish Jangam wrote:
> +static irqreturn_t da9052_ts_pendwn_irq(int irq, void *data)
> +{
> +	struct da9052_tsi *tsi = data;
> +
> +	if (!tsi->stopped) {
> +		/* Mask PEN_DOWN event and unmask TSI_READY event */
> +		disable_irq_nosync(tsi->da9052->irq_base + tsi->irq_pendwn);
> +		enable_irq(tsi->da9052->irq_base + tsi->irq_datardy);

Why did you switch to using irq_base here? da9052_onkey driver does not
do that, should it?

Thanks.

-- 
Dmitry
