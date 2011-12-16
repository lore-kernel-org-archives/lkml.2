Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751611Ab1LPKB1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 05:01:27 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:50563 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750900Ab1LPKBU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 05:01:20 -0500
Date: Fri, 16 Dec 2011 11:01:10 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Russell King <linux@arm.linux.org.uk>,
        Siarhei Siamashka <siarhei.siamashka@nokia.com>,
        Valdis.Kletnieks@vt.edu, Catalin Marinas <catalin.marinas@arm.com>,
        linux-kernel@vger.kernel.org, Aaro Koskinen <aaro.koskinen@nokia.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2] [RESEND] Handle instruction cache maintenance fault
 properly
Message-ID: <20111216100110.GK24496@pengutronix.de>
References: <AANLkTilVp0xvAJNns3TEe4SzEUpN8hMC9DdwmwW7i9yX@mail.gmail.com>
 <20111215215649.GJ24496@pengutronix.de>
 <20111216022205.GA28787@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20111216022205.GA28787@shutemov.name>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hallo,

On Fri, Dec 16, 2011 at 04:22:05AM +0200, Kirill A. Shutemov wrote:
> On Thu, Dec 15, 2011 at 10:56:49PM +0100, Uwe Kleine-König wrote:
> > Hello,
> > 
> > On Tue, May 11, 2010 at 01:33:14PM +0300, Kirill A. Shutemov wrote:
> > > Between "clean D line..." and "invalidate I line" operations in
> > > v7_coherent_user_range(), the memory page may get swapped out.
> > > And the fault on "invalidate I line" could not be properly handled
> > > causing the oops.
> > > 
> > > In ARMv6 "external abort on linefetch" replaced by "instruction cache
> > > maintenance fault". Let's handle it as translation fault. It fixes the
> > > issue.
> > > 
> > > I'm not sure if it's reasonable to check arch version in run-time.
> > > Let's do it in compile time for now.
> > > 
> > > Signed-off-by: Siarhei Siamashka <siarhei.siamashka@nokia.com>
> > > Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
> > I found this patch in Catalin's stack that I picked up to get support
> > for Cortex-M3. Is this still relevant?
> 
> It's in upstream. See 8c0b742.
Ah, I missed that because it applies again on top of 3.2-rc because of

	993bf4e (ARM: 6256/1: Check arch version and modify fsr_info[] depends on it at runtime)

Thanks and sorry for the noise,
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
