Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759932Ab2BNLI5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 06:08:57 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:32914 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756521Ab2BNLI4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 06:08:56 -0500
Date: Tue, 14 Feb 2012 11:08:36 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Matt Porter <mporter@ti.com>
Cc: Tony Lindgren <tony@atomide.com>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: OMAP2+: gpmc-smsc911x: add required smsc911x
	regulators
Message-ID: <20120214110836.GE15338@n2100.arm.linux.org.uk>
References: <1329151422-2146-1-git-send-email-mporter@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1329151422-2146-1-git-send-email-mporter@ti.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Two more points:

On Mon, Feb 13, 2012 at 11:43:42AM -0500, Matt Porter wrote:
> This fixes smsc911x support on platforms using gpmc_smsc911x_init().
> Commit c7e963f6888816f04d1f5da0e07bec4e0092f227 added the requirement

Always include the commit summary as well here, so:

Commit c7e963f6888816 (net/smsc911x: Add regulator support) added the ...

> @@ -55,6 +94,11 @@ void __init gpmc_smsc911x_init(struct omap_smsc911x_platform_data *board_data)
>  
>  	gpmc_cfg = board_data;
>  
> +	if (platform_device_register(&gpmc_smsc911x_regulator) < 0) {
> +		pr_err("Unable to register smsc911x regulators\n");
> +		return;
> +	}

It's always a good idea to indicate why something failed:

	err = platform_device_register(&gpmc_smsc911x_regulator);
	if (err < 0) {
		pr_err("Unable to register smsc911x regulators: %d\n", err);
		return;
	}

so that people can see not only what failed, but also why it failed.
