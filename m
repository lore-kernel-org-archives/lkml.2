Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754092Ab1AFGz2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 01:55:28 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:52007 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753940Ab1AFGz0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 01:55:26 -0500
Date: Thu, 6 Jan 2011 15:53:29 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Stefani Seibold <stefani@seibold.net>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        linux-fbdev@vger.kernel.org, adaplas@gmail.com,
        Maik Broemme <mbroemme@plusserver.de>, Dave Airlie <airlied@linux.ie>
Subject: Re: [PATCH] fix i810 i2c bug
Message-ID: <20110106065329.GF15340@linux-sh.org>
References: <1294046939.20021.12.camel@wall-e>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1294046939.20021.12.camel@wall-e>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 03, 2011 at 10:28:59AM +0100, Stefani Seibold wrote:
> These patch fix a longstanding bug in the i810 frame buffer driver. 
> 
> The handling of the i2c bus is wrong: A 1 bit should not written to the
> i2c, these will be done by switch the i2c to input. Driving an 1 bit
> active is against the i2c spec.
> 
> An active driven of a 1 bit will result in very strange error, depending
> which side is the more powerful one. In my case it depends on the
> temperature of the Display-Controller-EEprom: With an cold eprom a got
> the correct EDID datas, with a warm one some of the 1 bits was 0 :-(
> 
> The same bug is also in the intelfb driver in the file
> drivers/video/intelfb/intelfb_i2c.c. The functions intelfb_gpio_setscl()
> and intelfb_gpio_setsda() do drive the 1 bit active to the i2c bus. But
> since i have no card which is used by the intelfb driver i cannot fix
> it.
> 
> The patch is against linux next-20101231
> 
> - Stefani
> 
> Signed-off-by: Stefani Seibold <stefani@seibold.net>

Applied, thanks.

Also adding intelfb people to the Cc so they're aware of the problem, and
can follow suit.
