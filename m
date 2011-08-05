Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755738Ab1HEACA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 20:02:00 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38327 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753864Ab1HEAB6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 20:01:58 -0400
Date: Fri, 5 Aug 2011 09:01:50 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Warren <swarren@nvidia.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Liam Girdwood <lrg@ti.com>,
        Chris Ball <cjb@laptop.org>, ccross@android.com, olof@lixom.net,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        alsa-devel@alsa-project.org, linux-mmc@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH 1/3] irq: If an IRQ is a GPIO, request and configure it
Message-ID: <20110805000148.GB13321@opensource.wolfsonmicro.com>
References: <1312498820-2275-1-git-send-email-swarren@nvidia.com>
 <1312498820-2275-2-git-send-email-swarren@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1312498820-2275-2-git-send-email-swarren@nvidia.com>
X-Cookie: You now have Asian Flu.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 04, 2011 at 05:00:18PM -0600, Stephen Warren wrote:

> +	} else {
> +		gpio = irq_to_gpio(irq);
> +		if (gpio_is_valid(gpio)) {
> +			ret = gpio_request(gpio, new->name);
> +			if (ret < 0)
> +				goto out_mask;
> +			ret = gpio_direction_input(gpio);
> +			if (ret < 0)
> +				goto out_mask;
> +		}

If you treat failures as an error what happens when a driver is using a
GPIO as both an interrupt and a GPIO?  For example a driver which
monitors the level on a GPIO and uses edge triggered IRQs to be notified
of state changes.
