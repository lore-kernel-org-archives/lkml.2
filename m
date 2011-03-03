Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758154Ab1CCMrB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 07:47:01 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:60331 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754019Ab1CCMrA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 07:47:00 -0500
Date: Thu, 3 Mar 2011 13:46:58 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Dinh.Nguyen@freescale.com, linux-kernel@vger.kernel.org,
        s.hauer@pengutronix.de, xiao-lizhang@freescale.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCHv1] ARM: imx: Add support for low power suspend on MX51.
Message-ID: <20110303124658.GR22310@pengutronix.de>
References: <1299086278-12131-1-git-send-email-Dinh.Nguyen@freescale.com>
 <20110302215238.GK22310@pengutronix.de>
 <20110303115242.GA25891@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110303115242.GA25891@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 03, 2011 at 11:52:42AM +0000, Russell King - ARM Linux wrote:
> On Wed, Mar 02, 2011 at 10:52:38PM +0100, Uwe Kleine-König wrote:
> > > +static int __init mx5_pm_init(void)
> > > +{
> > > +	if (cpu_is_mx51())
> > > +		suspend_set_ops(&mx5_suspend_ops);
> > I'd prefer to have that called by imx51_init_early.
> 
> This function name looks fine.  As we now have an init_early in the
> arch hooks, let's keep things called foo_init_early() to that use
> and not start using 'early' for stuff used from initcalls.
> 
> Renaming this is a recipe for causing confusion and having grep hit
> false positives.  Please leave it as is.
It seems you and Thomas both didn't notice the "by" in my sentence.
Or maybe it's not proper English? The thing I wanted to express is that
instead of introducing another initcall I prefer that imx51_init_early
calls mx5_pm_init instead. The name mx5_pm_init is fine for me, though
imx51_pm_init would still be better.

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
