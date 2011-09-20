Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751775Ab1ITEQd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 00:16:33 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:51145 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750944Ab1ITEQb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 00:16:31 -0400
Date: Mon, 19 Sep 2011 22:16:29 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Jean Delvare <khali@linux-fr.org>
Cc: Stephen Warren <swarren@nvidia.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        Ben Dooks <ben-linux@fluff.org>, Jonathan Cameron <jic23@cam.ac.uk>,
        Arnd Bergmann <arnd@arndb.de>, Russell King <linux@arm.linux.org.uk>,
        Andrew Chew <achew@nvidia.com>, linux-iio@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-i2c@vger.kernel.org,
        spi-devel-general@lists.sourceforge.net
Subject: Re: [PATCH V3 1/5] i2c: Add irq_gpio field to struct i2c_client,
 i2c_board_info.
Message-ID: <20110920041629.GC30517@ponder.secretlab.ca>
References: <1314914676-28397-1-git-send-email-swarren@nvidia.com>
 <20110902085620.4ad918c4@endymion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110902085620.4ad918c4@endymion.delvare>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 02, 2011 at 08:56:20AM +0200, Jean Delvare wrote:
> Stephen,
> 
> Can you please fix your e-mail client / system / whatever so that your
> patch series are no longer sent duplicated?
> 
> On Thu,  1 Sep 2011 16:04:27 -0600, Stephen Warren wrote:
> > Some devices use a single pin as both an IRQ and a GPIO. In that case,
> > irq_gpio is the GPIO ID for that pin. Not all drivers use this feature.
> > Where they do, and the use of this feature is optional, and the system
> > wishes to disable this feature, this field must be explicitly set to a
> > defined invalid GPIO ID, such as -1.
> > 
> > Signed-off-by: Stephen Warren <swarren@nvidia.com>
> > ---
> > v3: Also add the field to i2c_board_info, and copy the field from
> >     i2c_board_info to i2c_client upon instantiation
> 
> I don't get the idea. The i2c core doesn't make any use of the field,
> and that field will only be used by a few drivers amongst the 420+
> i2c drivers in the tree. This looks like a waste of memory. What's wrong
> with including the new field in the private platform or arch data
> structure for drivers which need it?

I have to second the concern; but for a different reason.  This
shouldn't even remotely be necessary.  If the pin is used as an
interrupt, then interrupt controller driver (which I would assume is
also the gpio controller driver) should be responsible for setting up
the pin so that it can be used correctly as a irq line.  Why does the
gpio number need to be explicitly passed?

g.

