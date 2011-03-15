Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757671Ab1COMv7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 08:51:59 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:38228 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757548Ab1COMv6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 08:51:58 -0400
Date: Tue, 15 Mar 2011 12:51:49 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: Arnd Bergmann <arnd@arndb.de>, Jean Delvare <khali@linux-fr.org>,
        mems applications <mems.applications@st.com>, rdunlap@xenotime.net,
        carmine.iascone@st.com, matteo.dameno@st.com, rubini@cvml.unipv.it,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Guenter Roeck <guenter.roeck@ericsson.com>, Greg KH <greg@kroah.com>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>
Subject: Re: [PATCH] Add STMicroelectronics LPS001WP pressure sensor device
	driver into misc
Message-ID: <20110315125149.GC17277@sirena.org.uk>
References: <1300128906-1066-1-git-send-email-matteo.dameno@st.com> <20110314224244.3d6d23ba@endymion.delvare> <4D7EA38F.5070002@cam.ac.uk> <201103151038.40559.arnd@arndb.de> <4D7F4944.4070507@cam.ac.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D7F4944.4070507@cam.ac.uk>
X-Cookie: Do, or do not
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 15, 2011 at 11:11:00AM +0000, Jonathan Cameron wrote:
> On 03/15/11 09:38, Arnd Bergmann wrote:

[Reflowed Jonathan's text into 80 columns for legibility.]

> > Do you think it would help to split the iio codebase into a smaller part
> > for the relatively clean drivers that can be put into shape for
> > drivers/iio, and the bulk of the code that stays in staging for a bit
> > longer, until it gets converted to the new one in small chunks?

> 1) Spit functionality out in staging. This would give a core set that
> is basically the sysfs only stuff.  To do that we'd have to define a
> struct iio_dev_basic and make it an element of the iio_dev.  Prior to
> that we'd probably need to make pretty much all accesses into iio_dev
> via macros / inline functions which would not be a trivial
> undertaking.

> Then we could switch those drivers doing the minimum to the _basic
> form.  At that point we could perhaps attempt to move a couple of
> drivers and the abi docs out of staging.

> The disadvantages of this that come to mind are: * Makes the path to
> driver addition that I'd prefer trickier.  You write a basic sysfs
> only driver first, then add on stuff like events and buffering as
> separate patches. We could go the other way around like v4l2-subdev
> and have a base structure with the option of pointers to structures
> offering different combinations of features.  * Not many of the
> drivers I'd consider to be ready to go at the moment are actually in
> this _basic class. 

For what it's worth I have a few drivers I'd like to do which fall into
this category.  I've been put off working on them by the fact that I'm
not seeing a route out of staging for the subsystem.

> 2) Basically make a copy.  This would look like the original patch set did when we went

A third option is just to lift everything out of staging roughly as it
is now with anything that definitely needs redoing dropped, addressing
any review comments for mainline but not doing much else, and then
resume working on adding additional stuff.  It sounds like the userspace
interfaces that are there at present are mostly OK and most of the
issues are in-kernel?

You could perhaps have a Kconfig control for disabling any experimental
features in the API if you want to give people hints about areas that
are likely to churn.
