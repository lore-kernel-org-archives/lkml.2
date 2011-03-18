Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756448Ab1CRMwA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 08:52:00 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:37215 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753232Ab1CRMvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 08:51:54 -0400
Date: Fri, 18 Mar 2011 12:51:50 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Waldemar Rymarkiewicz <waldemar.rymarkiewicz@tieto.com>,
        linux-i2c@vger.kernel.org, sameo@linux.intel.com,
        linux-kernel@vger.kernel.org, hthebaud@insidefr.com,
        matti.j.aaltonen@nokia.com, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] NFC: Driver for Inside Secure MicroRead NFC chip
Message-ID: <20110318125150.GD27129@sirena.org.uk>
References: <1300444824-13713-1-git-send-email-waldemar.rymarkiewicz@tieto.com> <1300444824-13713-2-git-send-email-waldemar.rymarkiewicz@tieto.com> <201103181319.54191.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201103181319.54191.arnd@arndb.de>
X-Cookie: How do I get HOME?
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 18, 2011 at 01:19:53PM +0100, Arnd Bergmann wrote:
> On Friday 18 March 2011, Waldemar Rymarkiewicz wrote:

> > +
> > +	mutex_lock(&info->rx_mutex);
> > +	info->irq_state = 1;
> > +	mutex_unlock(&info->rx_mutex);
> > +
> > +	wake_up_interruptible(&info->rx_waitq);
> > +
> > +	return IRQ_HANDLED;
> > +}

> You cannot take a mutex from interrupt context, that may
> cause deadlocks.

This is a threaded IRQ handler so mutexes are fine.
