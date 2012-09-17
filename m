Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754391Ab2IQKkW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 06:40:22 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33229 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752668Ab2IQKkV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 06:40:21 -0400
Date: Mon, 17 Sep 2012 06:40:18 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "Opensource [Anthony Olech]" <anthony.olech.opensource@diasemi.com>
Cc: Liam Girdwood <lrg@ti.com>, Guenter Roeck <linux@roeck-us.net>,
        Jean Delvare <khali@linux-fr.org>, Randy Dunlap <rdunlap@xenotime.net>,
        LKML <linux-kernel@vger.kernel.org>,
        David Dajun Chen <david.chen@diasemi.com>
Subject: Re: [NEW DRIVER V3 8/8] DA9058 REGULATOR driver
Message-ID: <20120917104017.GB5401@opensource.wolfsonmicro.com>
References: <201208151518.q7FFILAM011604@latitude.olech.com>
 <20120827165057.GK4339@opensource.wolfsonmicro.com>
 <24DF37198A1E704D9811D8F72B87EB51032CC96A@NB-EX-MBX02.diasemi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <24DF37198A1E704D9811D8F72B87EB51032CC96A@NB-EX-MBX02.diasemi.com>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 17, 2012 at 10:29:43AM +0000, Opensource [Anthony Olech] wrote:

> > Why is this function writing to the hardware, especially writing the same value
> > every time?

> the ramp_register is DA9058_SUPPLY_REG and it is marked as volitile.
> Writing to the ramp enable bit starts the voltage change. When the PMIC has
> finished making the change it resets the bit. Thus to make another voltage
> change the bit needs to be set again.

This function is retrieving the amount of time it would take to set the
voltage.  Why would it be starting a voltage ramp?  The fact that it's
not setting the new voltage in the hardware ought to be a warning sign
here...
