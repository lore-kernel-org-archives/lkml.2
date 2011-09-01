Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932501Ab1IAPhQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 11:37:16 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:8920 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932469Ab1IAPhN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 11:37:13 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 01 Sep 2011 08:36:54 -0700
From: Stephen Warren <swarren@nvidia.com>
To: Arnd Bergmann <arnd@arndb.de>, Jonathan Cameron <jic23@cam.ac.uk>
CC: Andrew Chew <AChew@nvidia.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Date: Thu, 1 Sep 2011 08:36:53 -0700
Subject: RE: [PATCH 1/3] staging:iio:magnetometer:ak8975 Don't use
 irq_to_gpio()
Thread-Topic: [PATCH 1/3] staging:iio:magnetometer:ak8975 Don't use
 irq_to_gpio()
Thread-Index: Acxol0jWQxfaxMjxQwOpDjKVtIVX1wAJWOXQ
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF04B327A2A4@HQMAIL01.nvidia.com>
References: <1314819657-828-1-git-send-email-swarren@nvidia.com>
 <643E69AA4436674C8F39DCC2C05F76383CF3C784A3@HQMAIL03.nvidia.com>
 <4E5F49F4.2080208@cam.ac.uk> <201109011306.50936.arnd@arndb.de>
In-Reply-To: <201109011306.50936.arnd@arndb.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote at Thursday, September 01, 2011 5:07 AM:
> On Thursday 01 September 2011, Jonathan Cameron wrote:
> > On 08/31/11 20:45, Andrew Chew wrote:
> > >> Subject: [PATCH 1/3] staging:iio:magnetometer:ak8975 Don't
> > >> use irq_to_gpio()
> > >>
> > >> Tegra doesn't have irq_to_gpio() any more, and ak8975 is included in
> > >> tegra_defconfig. This causes a build failure. Solve this with
> > >> a heavy-handed
> > >> method for now.
> > >>
> > >> I suspect the long-term solution is to pass both the IRQ and GPIO IDs
> > >> to the driver; the GPIO ID coming from either platform data,
> > >> or perhaps
> > >> enhancing struct i2c_client to add a gpio field alongside irq.
> > >>
> > >> Signed-off-by: Stephen Warren <swarren@nvidia.com>
> > >> ---
> > >
> > > The three patches in this set LGTM.
> > >
> > > Acked-by: Andrew Chew <achew@nvidia.com>
> > >
> >
> > Hmm.. I'd like to see some means of passing that in. Perhaps as simple as passing
> > a pointer to an int in as platform_data.  Patch to follow.
> 
> My feeling is that we should just add another field to
> struct i2c_client. There are probably more drivers that
> need the same thing, making it appropriate to increase
> the size of that struct for everything device instead of
> adding platform_data to a subset of the devices.

That sounds reasonable to me.

One question: When we add this field, how do drivers tell whether a value
of 0 is an uninitialized field, or a legitimate GPIO value of 0? Should we
add a flag to indicate validity, or just work hard to not enable driver-
side code to use this value until we've fixed up all places that instantiate
the driver to initialize the field to some invalid value like -1?

-- 
nvpublic

