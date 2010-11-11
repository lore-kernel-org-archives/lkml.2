Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756299Ab0KKOP4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 09:15:56 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:41940 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755358Ab0KKOPy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 09:15:54 -0500
Date: Thu, 11 Nov 2010 14:15:46 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "Lighthart, EricX" <ericx.lighthart@intel.com>
Cc: "dmitry.torokhov@gmail.com" <dmitry.torokhov@gmail.com>,
        "pb@handhelds.org" <pb@handhelds.org>,
        "ext-mika.1.westerberg@nokia.com" <ext-mika.1.westerberg@nokia.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] input: Add sysfs interface to on/off state of GPIO
	keys and switches
Message-ID: <20101111141545.GB5043@sirena.org.uk>
References: <E559D19195578B4E9ECB3919FF99F9792A585A8BB1@orsmsx509.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E559D19195578B4E9ECB3919FF99F9792A585A8BB1@orsmsx509.amr.corp.intel.com>
X-Cookie: What fools these morals be!
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 11, 2010 at 06:03:35AM -0800, Lighthart, EricX wrote:
> User space cannot learn the current state of a GPIO key or switch.
> Input system reports only changes, not state.
> 
> Add two sysfs attributes, one each for keys and switches, that
> report lists of keys or switches currently "on."

There's EVIOCG* ioctl()s for this.  Something sysfs (or a widely
distributed utility) would be very helpful but there is actually a
facility to read the state.

>  drivers/input/keyboard/gpio_keys.c |   68 ++++++++++++++++++++++++++++--------

If something is needed here it should be done as part of the input
layer, not in a driver specific fashion - there's nothing specific to
GPIO keys here.
