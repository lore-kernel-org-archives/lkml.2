Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754911Ab1BQLFx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 06:05:53 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:47678 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751859Ab1BQLFv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 06:05:51 -0500
Date: Thu, 17 Feb 2011 12:05:47 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Eric Miao <eric.y.miao@gmail.com>
Cc: Peter Tyser <ptyser@xes-inc.com>, linux-kernel@vger.kernel.org,
        Alek Du <alek.du@intel.com>, Samuel Ortiz <sameo@linux.intel.com>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Joe Perches <joe@perches.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH v2 1/4] gpiolib: Add "unknown" direction support
Message-ID: <20110217110547.GN22310@pengutronix.de>
References: <1297904216-15219-1-git-send-email-ptyser@xes-inc.com>
 <AANLkTi=yZZgh0v+-_Cw0JudAxxTZuBWeVCEZ-dBtENPw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTi=yZZgh0v+-_Cw0JudAxxTZuBWeVCEZ-dBtENPw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 17, 2011 at 03:33:42PM +0800, Eric Miao wrote:
> On Thu, Feb 17, 2011 at 8:56 AM, Peter Tyser <ptyser@xes-inc.com> wrote:
> > Previously, gpiolib would unconditionally flag all GPIO pins as inputs,
> > regardless of their true state.  This resulted in all GPIO output pins
> > initially being incorrectly identified as "input" in the GPIO sysfs.
> >
> > Since the direction of GPIOs is not known prior to having their
> > direction set, instead set the default direction to "unknown" to prevent
> > user confusion.  A pin with an "unknown" direction can not be written or
> > read via sysfs; it must first be configured as an input or output before
> > it can be used.
> >
> 
> Hrm... that's why I don't like the original definition of gpio_request()
> which is vague on the pin configurations. The pin configuration should
> be clear upon requesting, otherwise it's a potential issue.
I don't know (state: "unknown" :-) what you would prefer here.  An
implicit gpio_direction_input()?  Or gpio_reserve_and_direction_input()?

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
