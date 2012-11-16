Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751333Ab2KPH3y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 02:29:54 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:33388 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750968Ab2KPH3w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 02:29:52 -0500
Date: Thu, 15 Nov 2012 23:26:43 -0800
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: Stephen Warren <swarren@nvidia.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Mark Zhang <markz@nvidia.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        David Woodhouse <dwmw2@infradead.org>, Arnd Bergmann <arnd@arndb.de>,
        Leela Krishna Amudala <l.krishna@samsung.com>,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fbdev@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-pm@vger.kernel.org, Alexandre Courbot <gnurou@gmail.com>
Subject: Re: [PATCH v8 1/3] Runtime Interpreted Power Sequences
Message-ID: <20121116072642.GA22291@lizard>
References: <1353047903-14363-1-git-send-email-acourbot@nvidia.com>
 <1353047903-14363-2-git-send-email-acourbot@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1353047903-14363-2-git-send-email-acourbot@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alexandre,

The code looks neat, thanks for you work!

Just a couple of comments...

On Fri, Nov 16, 2012 at 03:38:21PM +0900, Alexandre Courbot wrote:
[...]
> +
> +#include "power_seq_delay.c"
> +#include "power_seq_regulator.c"
> +#include "power_seq_pwm.c"
> +#include "power_seq_gpio.c"

This is odd, although I remember you already explained why you have to
include the .c files, instead of linking them separately. But I forgot the
reason. :) I think this deserves a comment in the code.

> +static int of_power_seq_parse_step(struct device *dev,
> +				   struct device_node *node,
> +				   struct power_seq *seq,
> +				   unsigned int step_nbr,
> +				   struct list_head *resources)
> +{
> +	struct power_seq_step *step = &seq->steps[step_nbr];
> +	struct power_seq_resource res, *res2;
> +	const char *type;
> +	int i, err;

nit: one variable declaration per line.

Thanks,
Anton.
