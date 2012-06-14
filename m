Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755687Ab2FNLSH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 07:18:07 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:56111 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755418Ab2FNLSF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 07:18:05 -0400
Date: Thu, 14 Jun 2012 12:17:46 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Felipe Balbi <balbi@ti.com>
Cc: ben-linux@fluff.org, Tony Lindgren <tony@atomide.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        w.sang@pengutronix.de, linux-i2c@vger.kernel.org,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 06/17] i2c: omap: improve 1p153 errata handling
Message-ID: <20120614111746.GB31187@n2100.arm.linux.org.uk>
References: <1339669250-9183-1-git-send-email-balbi@ti.com> <1339669250-9183-7-git-send-email-balbi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339669250-9183-7-git-send-email-balbi@ti.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 14, 2012 at 01:20:39PM +0300, Felipe Balbi wrote:
> -static int errata_omap3_1p153(struct omap_i2c_dev *dev, u16 *stat, int *err)
> +static int errata_omap3_1p153(struct omap_i2c_dev *dev)
>  {
> -	unsigned long timeout = 10000;
> +	unsigned long	timeout = 10000;
> +	u16		stat;

Eww, no, not more of this "lets add tabs to align auto variable
declarations".  This is detrimental when you add another variable whose
type is longer than the current indentation - you have to reformat the
entire block.

It's really not worth it.  Stick to just using one space, like the rest
of the kernel code.  Like the code which Linus writes.  And thereby help
to avoid future "pointless churn" whinges.
