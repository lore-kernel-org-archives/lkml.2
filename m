Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755495Ab2ISChO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 22:37:14 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:56430 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755369Ab2ISChH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 22:37:07 -0400
Date: Tue, 18 Sep 2012 22:37:02 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "Opensource [Anthony Olech]" <anthony.olech.opensource@diasemi.com>
Cc: Liam Girdwood <lrg@ti.com>, Guenter Roeck <linux@roeck-us.net>,
        Jean Delvare <khali@linux-fr.org>, Randy Dunlap <rdunlap@xenotime.net>,
        LKML <linux-kernel@vger.kernel.org>,
        David Dajun Chen <david.chen@diasemi.com>
Subject: Re: [NEW DRIVER V3 8/8] DA9058 REGULATOR driver
Message-ID: <20120919023702.GG8832@opensource.wolfsonmicro.com>
References: <201208151518.q7FFILAM011604@latitude.olech.com>
 <20120827165057.GK4339@opensource.wolfsonmicro.com>
 <24DF37198A1E704D9811D8F72B87EB51032CC96A@NB-EX-MBX02.diasemi.com>
 <20120917104017.GB5401@opensource.wolfsonmicro.com>
 <24DF37198A1E704D9811D8F72B87EB51032CC993@NB-EX-MBX02.diasemi.com>
 <20120917111550.GE5401@opensource.wolfsonmicro.com>
 <24DF37198A1E704D9811D8F72B87EB51032CC9BB@NB-EX-MBX02.diasemi.com>
 <20120917113248.GF5401@opensource.wolfsonmicro.com>
 <24DF37198A1E704D9811D8F72B87EB51032CC9D3@NB-EX-MBX02.diasemi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <24DF37198A1E704D9811D8F72B87EB51032CC9D3@NB-EX-MBX02.diasemi.com>
X-Cookie: It's all in the mind, ya know.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 17, 2012 at 12:07:11PM +0000, Opensource [Anthony Olech] wrote:

> > > Can you suggest a future proofed way of using the new regulator API
> > > that would solve my problem?

> > As I said you should set the voltage as part of the set voltage operation.

> So I will have to write my own set_voltage_sel() callback instead of using
> the default regulator_set_voltage_sel_regmap() ??

Yes.

> Well, I did try hard to use your defaults, but I suppose there is nothing to
> stop me calling regulator_set_voltage_sel_regmap() explicitly as the first
> part of my set_voltage_sel() callback before setting the ramp_enable bit.
> Then my implemenation of the set_voltage_time_sel() callback needs to
> just simply return the ramp time.

The point with using the framework stuff is that you should factor out
common code, if what you have is not common code then don't do crazy
things in other ops to try to paper over that.
