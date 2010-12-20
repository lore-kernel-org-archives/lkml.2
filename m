Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757902Ab0LTPAz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 10:00:55 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45123 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757760Ab0LTPAy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 10:00:54 -0500
Date: Mon, 20 Dec 2010 15:00:52 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Rabin Vincent <rabin@rab.in>, stern@rowland.harvard.edu,
        linux-pm@lists.linux-foundation.org, linux-i2c@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: platform/i2c busses: pm runtime and system sleep
Message-ID: <20101220150051.GI26706@rakim.wolfsonmicro.main>
References: <AANLkTinyDE3OxKup_aqsN8HJH_r5LcwkP17OtuMRpACx@mail.gmail.com>
 <201012181354.58077.rjw@sisk.pl>
 <20101218132029.GA22273@opensource.wolfsonmicro.com>
 <201012181559.50347.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201012181559.50347.rjw@sisk.pl>
X-Cookie: Reapply as necessary.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 18, 2010 at 03:59:50PM +0100, Rafael J. Wysocki wrote:

> Second, the situation at hand is that the bus type implements dev_pm_ops,
> but the driver doesn't.  Now, pm_generic_suspend() is called with a struct
> device pointer, so it would have to go back to dev->bus, find the
> ->legacy_suspend() callback (as opposed to ->suspend(), which also is legacy,
> but is called by the PM core instead).  May I call that confusing?

Well, the trouble is that the whole situation is already pretty
confusing for what should be very simple buses, each one needs to write
a bunch of not really bus specific code in order to get basic behaviour
which allows the drivers to make use of runtime PM, requiring more
thought and care per bus than I'd expect given that they've nothing
really to contribute.  This leads to the sort of random variations
between buses that Rabin is reporting, and means that updates keep
having to get done in multiple different places.

The overall effect is that from the point of view of trying to use
runtime PM in drivers which work with these simple buses everything
feels like it's much harder work than it should be.  Moving all the
decision making out of the buses and into the PM core seems like a win
here.
