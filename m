Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932115Ab1BRIva (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 03:51:30 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:39452 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756645Ab1BRIv1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 03:51:27 -0500
Date: Fri, 18 Feb 2011 09:51:23 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Peter Tyser <ptyser@xes-inc.com>
Cc: linux-kernel@vger.kernel.org, Alek Du <alek.du@intel.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Eric Miao <eric.y.miao@gmail.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Joe Perches <joe@perches.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH v3 1/4] gpiolib: Add "unknown" direction support
Message-ID: <20110218085123.GW22310@pengutronix.de>
References: <1297983799-4747-1-git-send-email-ptyser@xes-inc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1297983799-4747-1-git-send-email-ptyser@xes-inc.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Feb 17, 2011 at 05:03:16PM -0600, Peter Tyser wrote:
> Previously, gpiolib would unconditionally flag all GPIO pins as inputs,
> regardless of their true state.  This resulted in all GPIO output pins
> initially being incorrectly identified as "input" in the GPIO sysfs.
> 
> Since the direction of GPIOs is not known prior to having their
> direction set, instead set the default direction to "unknown" to prevent
> user confusion.  A pin with an "unknown" direction can not be written or
> read via sysfs; it must first be configured as an input or output before
> it can be used.
> 
> While we're playing with the direction flag in/out defines, rename them to
> a more descriptive FLAG_DIR_* format.
Would it make sense to reset the state to unknown on gpio_free?

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
