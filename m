Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758198Ab1CCNqc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 08:46:32 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:42347 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756155Ab1CCNqc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 08:46:32 -0500
Date: Thu, 3 Mar 2011 13:45:51 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Dinh.Nguyen@freescale.com, linux-kernel@vger.kernel.org,
        s.hauer@pengutronix.de, xiao-lizhang@freescale.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCHv1] ARM: imx: Add support for low power suspend on MX51.
Message-ID: <20110303134551.GC25891@n2100.arm.linux.org.uk>
References: <1299086278-12131-1-git-send-email-Dinh.Nguyen@freescale.com> <20110302215238.GK22310@pengutronix.de> <20110303115242.GA25891@n2100.arm.linux.org.uk> <20110303124658.GR22310@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110303124658.GR22310@pengutronix.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 03, 2011 at 01:46:58PM +0100, Uwe Kleine-König wrote:
> On Thu, Mar 03, 2011 at 11:52:42AM +0000, Russell King - ARM Linux wrote:
> > On Wed, Mar 02, 2011 at 10:52:38PM +0100, Uwe Kleine-König wrote:
> > > > +static int __init mx5_pm_init(void)
> > > > +{
> > > > +	if (cpu_is_mx51())
> > > > +		suspend_set_ops(&mx5_suspend_ops);
> > > I'd prefer to have that called by imx51_init_early.
> > 
> > This function name looks fine.  As we now have an init_early in the
> > arch hooks, let's keep things called foo_init_early() to that use
> > and not start using 'early' for stuff used from initcalls.
> > 
> > Renaming this is a recipe for causing confusion and having grep hit
> > false positives.  Please leave it as is.
> It seems you and Thomas both didn't notice the "by" in my sentence.
> Or maybe it's not proper English? The thing I wanted to express is that
> instead of introducing another initcall I prefer that imx51_init_early
> calls mx5_pm_init instead. The name mx5_pm_init is fine for me, though
> imx51_pm_init would still be better.

Is there a reason to set this really really early?  What's that reason
exactly?

You can't suspend the system until the scheduler is up and running.
Neither can you use cpuidle.  So it seems there isn't a pressing reason
to place this stuff really early in the fragile part of kernel
initialization.
