Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754102Ab0KBWV2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 18:21:28 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:35990 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753756Ab0KBWV0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 18:21:26 -0400
Date: Tue, 2 Nov 2010 22:21:11 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Dinh.Nguyen@freescale.com
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        s.hauer@pengutronix.de, u.kleine-koenig@pengutronix.de,
        valentin.longchamp@epfl.ch, daniel@caiaq.de, grant.likely@secretlab.ca,
        amit.kucheria@canonical.com, xiao-lizhang@freescale.com
Subject: Re: [PATCH 2/2] ARM: imx: Add mx53 support to common msl functions.
Message-ID: <20101102222111.GA5169@n2100.arm.linux.org.uk>
References: <1288736227-800-1-git-send-email-Dinh.Nguyen@freescale.com> <1288736227-800-2-git-send-email-Dinh.Nguyen@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1288736227-800-2-git-send-email-Dinh.Nguyen@freescale.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 02, 2010 at 05:17:07PM -0500, Dinh.Nguyen@freescale.com wrote:
>  static void query_silicon_parameter(void)
>  {
> -	void __iomem *rom = ioremap(MX51_IROM_BASE_ADDR, MX51_IROM_SIZE);
> +	void __iomem *rom;
>  	u32 rev;
>  
> +	if (cpu_is_mx51())
> +		rom = ioremap(MX51_IROM_BASE_ADDR, MX51_IROM_SIZE);
> +	else if (cpu_is_mx53())
> +		rom = ioremap(MX53_IROM_BASE_ADDR, MX53_IROM_SIZE);

	else
		rom is uninitialized;

I'd also suggest that the above set two variables - base and size, rather
than repeating the ioremap.  If you look at the generated code, I suspect
you'll find that the above generates two ioremap calls, whereas using
variables for base and size, and having a common ioremap will reduce the
code size.
