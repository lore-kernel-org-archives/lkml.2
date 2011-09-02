Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754337Ab1IBSYs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 14:24:48 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:7273 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754045Ab1IBSYp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 14:24:45 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 02 Sep 2011 11:24:06 -0700
From: Stephen Warren <swarren@nvidia.com>
To: Greg Kroah-Hartman <gregkh@suse.de>, Jean Delvare <khali@linux-fr.org>,
        Jonathan Cameron <jic23@cam.ac.uk>
CC: Ben Dooks <ben-linux@fluff.org>, Grant Likely <grant.likely@secretlab.ca>,
        Arnd Bergmann <arnd@arndb.de>, Russell King <linux@arm.linux.org.uk>,
        Andrew Chew <AChew@nvidia.com>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "spi-devel-general@lists.sourceforge.net" 
	<spi-devel-general@lists.sourceforge.net>
Date: Fri, 2 Sep 2011 11:24:04 -0700
Subject: RE: [PATCH V3 1/5] i2c: Add irq_gpio field to struct i2c_client,
  i2c_board_info.
Thread-Topic: [PATCH V3 1/5] i2c: Add irq_gpio field to struct i2c_client,
  i2c_board_info.
Thread-Index: AcxpUib9V2Xclml7Qcq2PXcEbrc2gwASw1UA
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF04B327A628@HQMAIL01.nvidia.com>
References: <1314914676-28397-1-git-send-email-swarren@nvidia.com>
	<20110902085620.4ad918c4@endymion.delvare>	<4E609F9C.5020403@cam.ac.uk>
 <20110902112435.69c9e8f7@endymion.delvare>
In-Reply-To: <20110902112435.69c9e8f7@endymion.delvare>
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

Jean Delvare wrote at Friday, September 02, 2011 3:25 AM:
> Hi Jonathan,
> 
> On Fri, 02 Sep 2011 10:19:24 +0100, Jonathan Cameron wrote:
> > On 09/02/11 07:56, Jean Delvare wrote:
> > > Stephen,
> > >
> > > Can you please fix your e-mail client / system / whatever so that your
> > > patch series are no longer sent duplicated?
> > >
> > > On Thu,  1 Sep 2011 16:04:27 -0600, Stephen Warren wrote:
> > >> Some devices use a single pin as both an IRQ and a GPIO. In that case,
> > >> irq_gpio is the GPIO ID for that pin. Not all drivers use this feature.
> > >> Where they do, and the use of this feature is optional, and the system
> > >> wishes to disable this feature, this field must be explicitly set to a
> > >> defined invalid GPIO ID, such as -1.
> > >>
> > >> Signed-off-by: Stephen Warren <swarren@nvidia.com>
> > >> ---
> > >> v3: Also add the field to i2c_board_info, and copy the field from
> > >>     i2c_board_info to i2c_client upon instantiation
> > >
> > > I don't get the idea. The i2c core doesn't make any use of the field,
> > > and that field will only be used by a few drivers amongst the 420+
> > > i2c drivers in the tree. This looks like a waste of memory. What's wrong
> > > with including the new field in the private platform or arch data
> > > structure for drivers which need it?
> >
> > Why not make it platform data for now and 'if' it becomes way more common
> > (probably won't) we can always propose adding as a general field at a later
> > date.
> 
> Yes, this sounds like a much more reasonable approach.

BTW, if that's the direction that's decided, just take the first version
of the patchset I posted, plus Jonathan Cameron's subsequent patch to
modify ak8975 to accept GPIO ID through platform data.

-- 
nvpublic

