Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752466Ab0CTUZI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Mar 2010 16:25:08 -0400
Received: from bamako.nerim.net ([62.4.17.28]:52617 "EHLO bamako.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751474Ab0CTUZF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Mar 2010 16:25:05 -0400
Date: Sat, 20 Mar 2010 21:25:01 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Wolfram Sang <w.sang@pengutronix.de>, kernel-janitors@vger.kernel.org,
       linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
       Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH 13/24] mfd: fix dangling pointers
Message-ID: <20100320212501.138b1644@hyperion.delvare>
In-Reply-To: <20100320172241.GD1549@opensource.wolfsonmicro.com>
References: <1269094385-16114-1-git-send-email-w.sang@pengutronix.de>
	<1269094385-16114-14-git-send-email-w.sang@pengutronix.de>
	<20100320172241.GD1549@opensource.wolfsonmicro.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 20 Mar 2010 17:22:41 +0000, Mark Brown wrote:
> On Sat, Mar 20, 2010 at 03:12:54PM +0100, Wolfram Sang wrote:
> > Fix I2C-drivers which missed setting clientdata to NULL before freeing the
> > structure it points to. Also fix drivers which do this _after_ the structure
> > was freed already.
> 
> Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> 
> but it really does seem like this is something that the I2C core ought
> to handle - the assignment to null is boiler plate code that's getting
> added to the overwhelming majority of I2C devices in their teardown
> path, it'd seem a lot more sensible for the core to just trash driver
> data after the driver is unbound if it's important that this happens.

This is an interesting point. Do you know of any other subsystem doing
this? The core touching private data seems wrong to me, but I have to
agree that it would avoid a lot of duplication across drivers.

Can someone find a reasonable use case for client data surviving the
driver's .remove() call?

-- 
Jean Delvare
