Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755425Ab1BWRhe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 12:37:34 -0500
Received: from www.hansjkoch.de ([178.63.77.200]:54650 "EHLO www.hansjkoch.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752375Ab1BWRhc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 12:37:32 -0500
Date: Wed, 23 Feb 2011 18:37:25 +0100
From: "Hans J. Koch" <hjk@hansjkoch.de>
To: Pratheesh Gangadhar <pratheesh@ti.com>
Cc: davinci-linux-open-source@linux.davincidsp.com, hjk@hansjkoch.de,
        gregkh@suse.de, amit.chatterjee@ti.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 1/2] PRUSS UIO driver support
Message-ID: <20110223173724.GA2801@local>
References: <1298469161-7644-1-git-send-email-pratheesh@ti.com>
 <1298469161-7644-2-git-send-email-pratheesh@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1298469161-7644-2-git-send-email-pratheesh@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 23, 2011 at 07:22:40PM +0530, Pratheesh Gangadhar wrote:
> This patch implements PRUSS (Programmable Real-time Unit Sub System)
> UIO driver which exports SOC resources associated with PRUSS like
> I/O, memories and IRQs to user space. PRUSS is dual 32-bit RISC
> processors which is efficient in performing embedded tasks that
> require manipulation of packed memory mapped data structures and
> efficient in handling system events that have tight real time
> constraints. This driver is currently supported on Texas Instruments
> DA850, AM18xx and OMAPL1-38 devices.
> For example, PRUSS runs firmware for real-time critical industrial
> communication data link layer and communicates with application stack
> running in user space via shared memory and IRQs.
> 
> Signed-off-by: Pratheesh Gangadhar <pratheesh@ti.com>
> ---
>  drivers/uio/Kconfig     |   17 ++++
>  drivers/uio/Makefile    |    1 +
>  drivers/uio/uio_pruss.c |  223 +++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 241 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/uio/uio_pruss.c
> 

[...]

> +
> +static int __devinit pruss_probe(struct platform_device *dev)
> +{
> +	int ret = -ENODEV, count = 0;
> +	struct resource *regs_prussio, *regs_l3ram, *regs_ddr;
> +	struct uio_info *p;
> +
> +	info = kzalloc(sizeof(struct uio_info) * MAX_PRUSS_EVTOUT_INSTANCE,
> +		       GFP_KERNEL);
> +	if (!info)
> +		return -ENOMEM;
> +
> +	/* Power on PRU in case its not done as part of boot-loader */
> +	pruss_clk = clk_get(&dev->dev, "pruss");
> +	if (IS_ERR(pruss_clk)) {
> +		dev_err(&dev->dev, "Failed to get clock\n");
> +		ret = PTR_ERR(pruss_clk);
> +		return ret;

You leak memory here. What about freeing "info"?

> +	} else {
> +		clk_enable(pruss_clk);
> +	}

Thanks,
Hans

