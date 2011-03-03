Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758104Ab1CCLwy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 06:52:54 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:36809 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753150Ab1CCLww (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 06:52:52 -0500
Date: Thu, 3 Mar 2011 11:52:42 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Dinh.Nguyen@freescale.com, linux-kernel@vger.kernel.org,
        s.hauer@pengutronix.de, xiao-lizhang@freescale.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCHv1] ARM: imx: Add support for low power suspend on MX51.
Message-ID: <20110303115242.GA25891@n2100.arm.linux.org.uk>
References: <1299086278-12131-1-git-send-email-Dinh.Nguyen@freescale.com> <20110302215238.GK22310@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110302215238.GK22310@pengutronix.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 02, 2011 at 10:52:38PM +0100, Uwe Kleine-König wrote:
> > +static int __init mx5_pm_init(void)
> > +{
> > +	if (cpu_is_mx51())
> > +		suspend_set_ops(&mx5_suspend_ops);
> I'd prefer to have that called by imx51_init_early.

This function name looks fine.  As we now have an init_early in the
arch hooks, let's keep things called foo_init_early() to that use
and not start using 'early' for stuff used from initcalls.

Renaming this is a recipe for causing confusion and having grep hit
false positives.  Please leave it as is.
