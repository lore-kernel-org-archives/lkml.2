Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751554Ab2LCH1v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 02:27:51 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53706 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750978Ab2LCH1u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 02:27:50 -0500
Date: Mon, 3 Dec 2012 16:27:42 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: GShark Jeong <gshark.jeong@gmail.com>
Cc: Liam Gridwood <lrg@ti.com>, Daniel Jeong <daniel.jeong@ti.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] regulator: new driver for LP8755
Message-ID: <20121203072741.GC9848@opensource.wolfsonmicro.com>
References: <1354509864-30001-1-git-send-email-gshark.jeong@gmail.com>
 <1354509864-30001-2-git-send-email-gshark.jeong@gmail.com>
 <20121203063642.GB9848@opensource.wolfsonmicro.com>
 <CAPqQCJW6TLhxRkOdw6JVe1qkepDDKdt+wagAgd5VCCsE3y6Qog@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPqQCJW6TLhxRkOdw6JVe1qkepDDKdt+wagAgd5VCCsE3y6Qog@mail.gmail.com>
X-Cookie: Reply hazy, ask again later.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 03, 2012 at 04:24:43PM +0900, GShark Jeong wrote:
> 2012/12/3 Mark Brown <broonie@opensource.wolfsonmicro.com>
> > On Mon, Dec 03, 2012 at 01:44:24PM +0900, Daniel Jeong wrote:

> > > +     if (ret < 0)
> > > +             goto out_i2c_error;
> > > +     dev_info(pchip->dev, "lp8755 : chip ID is 0x%x\n", regval);

> > This isn't actually checking anything except the I/O.  Can the chip ID
> > really vary?

> My configurations are already programmed in otp memory of chip as default
> values.
> So this comment for to others who are using different initial values with
> default data.
> I will drop it.

It seems like a better fix would be to add a check for the ID and fail
if the OTP value doesn't match, that way the driver won't try to run on
unsupported hardware.
