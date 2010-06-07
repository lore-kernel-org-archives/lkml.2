Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755305Ab0FGM2q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 08:28:46 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:32988 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751699Ab0FGM2p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 08:28:45 -0400
Date: Mon, 7 Jun 2010 13:28:41 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: sonic zhang <sonic.adi@gmail.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       uclinux-dist-devel <uclinux-dist-devel@blackfin.uclinux.org>
Subject: Re: [PATCH v6] regulator: new drivers for AD5398 and AD5821
Message-ID: <20100607122840.GA13287@rakim.wolfsonmicro.main>
References: <1275626446.1515.5.camel@eight.analog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1275626446.1515.5.camel@eight.analog.com>
X-Cookie: Warp 7 -- It's a law we can live with.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 04, 2010 at 12:40:46PM +0800, sonic zhang wrote:

> The AD5398 and AD5821 are single 10-bit DAC with 120 mA output current
> sink capability. They feature an internal reference and operates from
> a single 2.7 V to 5.5 V supply.

> This driver supports both the AD5398 and the AD5821.  It adapts into the
> voltage and current framework.

> Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

but

> +static int __init ad5398_init(void)
> +{
> +	return i2c_add_driver(&ad5398_driver);
> +}
> +module_init(ad5398_init);

at least some systems are likely to want this to be subsys_initcall() to
make sure the regulator is available prior to the consumers.  Please
send an incremental change for this rather than repostnig the full
thing.
