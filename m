Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751639Ab1GONKi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 09:10:38 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59046 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750770Ab1GONKh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 09:10:37 -0400
Date: Fri, 15 Jul 2011 22:10:26 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: Greg KH <greg@kroah.com>, Grant Likely <grant@secretlab.ca>,
        Ben Dooks <ben-linux@fluff.org>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Samuel Oritz <sameo@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] regulator: Convert tps65023 to use regmap API
Message-ID: <20110715131023.GC10026@opensource.wolfsonmicro.com>
References: <20110715062215.GN32716@opensource.wolfsonmicro.com>
 <1310710992-24462-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1310710992-24462-4-git-send-email-broonie@opensource.wolfsonmicro.com>
 <20110715123121.735688a6@endymion.delvare>
 <20110715121646.GA10026@opensource.wolfsonmicro.com>
 <20110715145848.750a85aa@endymion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110715145848.750a85aa@endymion.delvare>
X-Cookie: You should go home.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 15, 2011 at 02:58:48PM +0200, Jean Delvare wrote:
> On Fri, 15 Jul 2011 21:16:50 +0900, Mark Brown wrote:

> > regmap API.  As far as I can tell this isn't really a big deal except
> > for those device classes like hwmon which are frequently deployed in
> > PCs, anything else just won't care.

> Mostly correct. There are a few other devices which can also be found
> on PCs: multiplexers and EEPROMs at least.

I did say "device classes like" for a reason :)

> > This should be reasonably simple to handle in the regmap API, just teach
> > the I2C module to fall back to using the SMBus operations if the
> > controller is limited to that.  This should be done incrementally as it
> > adds complexity, and ideally would be done by someone with some access
> > to hardware that can use the SMBus API (I don't have any myself) so they
> > can test.

> You do have access ;) The i2c core will translate SMBus to I2C as
> needed, so all you have to do is temporarily alter the regmap core to
> unconditionally translate to SMBus. This will be inefficient (regmap ->
> SMBus -> I2C) but should be suitable for testing.

I have access to host controllers obviously, what I don't have is access
to any client devices with suitable register maps.

> > > >  static int tps_65023_set_bits(struct tps_pmic *tps, u8 reg, u8 mask)
> > > >  {
> > > > -	int err, data;

> > *Please* could people delete unneeded context from mails?

> ? There were more comments from me in the rest of the code, which is
> why I left it.

You should delete all the text that isn't directly related to your
comments, you appeared to have not deleted any content at all from the
mail.  There were pages and pages of stuff with no comments at all.

This really helpful both for finding the content (it's really easy to
just page past stuff) and for those of us who read mail on mobile
devices.
