Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756942Ab0FRHkL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 03:40:11 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:41022 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756433Ab0FRHkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 03:40:04 -0400
Date: Fri, 18 Jun 2010 09:39:50 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
       Magnus Damm <damm@opensource.se>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Paul Mundt <lethal@linux-sh.org>, Dmitry Torokhov <dtor@mail.ru>,
       Eric Miao <eric.y.miao@gmail.com>, netdev@vger.kernel.org
Subject: Re: [PATCH 2/2] Driver core: reduce duplicated code
Message-ID: <20100618073950.GA12822@pengutronix.de>
References: <1276591677-4678-1-git-send-email-u.kleine-koenig@pengutronix.de> <1276591677-4678-2-git-send-email-u.kleine-koenig@pengutronix.de> <20100615090500.GA17595@pengutronix.de> <20100616205332.GB15837@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100616205332.GB15837@kroah.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On Wed, Jun 16, 2010 at 01:53:32PM -0700, Greg KH wrote:
> On Tue, Jun 15, 2010 at 11:05:00AM +0200, Uwe Kleine-König wrote:
> > On Tue, Jun 15, 2010 at 10:47:56AM +0200, Uwe Kleine-König wrote:
> > > This makes the two similar functions platform_device_register_simple
> > > and platform_device_register_data one line inline functions using a new
> > > generic function platform_device_register_resndata.
> > I forgot to add some comments to this mail, ... sorry.
> > 
> >  - I'm not completely happy with the name of the new function.  If
> >    someone has a better name please tell me.
> 
> I don't like it either, what is "resndata" supposed to stand for?
resources and data -> res'n'data -> resndata.

> >  - can platform_device_register_resndata be moved to __init_or_module?
> 
> I doubt it, but try it and see if a build warns about it.
for x86_64_defconfig + MODULES=n there are two section mismatches:
	dock_add
	regulatory_init

regulatory_init is only called from

	static int __init cfg80211_init(void)

.  (I just sent a patch[1] that moves regulatory_init to .init.text.)

dock_add (in drivers/acpi/dock.c) is a bit harder.  I will take a look
later if it can go to .init.text (together with a few more functions),
too.

> >  - I moved the kernel docs to the header but didn't test if they are
> >    picked up when generating docs.  Even if not, there is no better
> >    place, is there?
> 
> No, that's the proper place, but make sure the docbook source is also
> picking up the .h file, I don't know if it currently does.
It does not, will fix in a v2.

Thanks
Uwe

[1] http://mid.gmane.org/1276846735-12105-2-git-send-email-u.kleine-koenig@pengutronix.de
-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
