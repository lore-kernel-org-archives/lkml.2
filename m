Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751516Ab1HLVJu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 17:09:50 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:14959 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820Ab1HLVJs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 17:09:48 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 12 Aug 2011 14:09:24 -0700
From: Stephen Warren <swarren@nvidia.com>
To: Ben Dooks <ben-i2c@fluff.org>
CC: "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jean Delvare <khali@linux-fr.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        Colin Cross <ccross@android.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Axel Lin <axel.lin@gmail.com>, Rob Herring <robherring2@gmail.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        "marc.zyngier@arm.com" <marc.zyngier@arm.com>
Date: Fri, 12 Aug 2011 14:08:52 -0700
Subject: RE: Tegra I2C driver compilation failure (was: RE: [PATCH] dt: add
	empty of_get_property for non-dt)
Thread-Topic: Tegra I2C driver compilation failure (was: RE: [PATCH] dt: add
	empty of_get_property for non-dt)
Thread-Index: AcxYiW0+Eckdj+oRSvyjfS+mlpxbwgAqSq7Q
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF04AEA24F41@HQMAIL01.nvidia.com>
References: <74CDBE0F657A3D45AFBB94109FB122FF04A0687289@HQMAIL01.nvidia.com>
 <20110812004732.GF19115@trinity.fluff.org>
In-Reply-To: <20110812004732.GF19115@trinity.fluff.org>
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

Ben Dooks wrote at Thursday, August 11, 2011 6:48 PM:
> On Tue, Aug 09, 2011 at 09:21:31AM -0700, Stephen Warren wrote:
> > Stephen Warren wrote at Monday, August 08, 2011 1:26 PM:
> > > Rob Herring wrote at Sunday, August 07, 2011 8:38 AM:
> > > > On 08/05/2011 05:50 PM, Stephen Warren wrote:
> > > > > The patch adds empty function of_get_property for non-dt build, so that
> > > > > drivers migrating to dt can save some '#ifdef CONFIG_OF'.
> > > > >
> > > > > This also fixes the current Tegra compile problem in linux-next.
> > > >
> > > > You could just use of_property_read_u32 in the driver. It already has
> > > > empty version and will simplify the driver code some.
> > >
> > > Yes, that would also work.
> > >
> > > Grant, Ben, do you have a preference for which option to choose?
> >
> > Well, all three possible fixes have been posted now:
> >
> > Add ifdef to i2c driver:
> > http://www.spinics.net/lists/linux-tegra/msg01720.html
> >
> > Implement empty of_get_property:
> > http://www.spinics.net/lists/linux-tegra/msg01881.html
> >
> > Switch i2c driver to use of_property_read_u32:
> > http://permalink.gmane.org/gmane.linux.ports.arm.kernel/127807
> >
> > Ben, please could you please pick one of the changes and apply it, so
> > that linux-next compiles for Tegra? Thanks!
> 
> I'll look into this at the weekend, of_property_read_u32 is probably
> a better function to call.

Ben,

Grant said he has merged the following solution:

> > Implement empty of_get_property:
> > http://www.spinics.net/lists/linux-tegra/msg01881.html

... although it's not in linux-next yet.

If you do still want to go ahead with using of_property_read_u32, the
patch to do that will need a fixup to avoid the unsafe cast; let me know
if you want me to update the patch for that or not.

Related, here's the list of outstanding patches for i2c-tegra.c that I'm
aware of:

[PATCH] i2c: Tegra: Add of_match_table
http://www.spinics.net/lists/linux-i2c/msg05898.html

[PATCH] i2c: tegra: add I2C_FUNC_SMBUS_EMUL to adapter functionality
http://www.spinics.net/lists/linux-i2c/msg05396.html

[PATCH] i2c: tegra: fix possible race condition after tx
http://www.spinics.net/lists/linux-i2c/msg06103.html

Hope this helps! Thanks.

-- 
nvpublic

