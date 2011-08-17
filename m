Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753430Ab1HQNNc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 09:13:32 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:44548 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751348Ab1HQNNa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 09:13:30 -0400
Date: Wed, 17 Aug 2011 14:12:56 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Russell King <rmk@arm.linux.org.uk>
Cc: Kenneth Heitke <kheitke@codeaurora.org>, Jean Delvare <khali@linux-fr.org>,
        Ben Dooks <ben-linux@fluff.org>,
        Grant Likely <grant.likely@secretlab.ca>, davidb@codeaurora.org,
        bryanh@codeaurora.org, linux-arm-msm@vger.kernel.org,
        Sagar Dharia <sdharia@codeaurora.org>, rdunlap@xenotime.net,
        john.stultz@linaro.org, arnd@arndb.de, akpm@linux-foundation.org,
        ohad@wizery.com, gregkh@suse.de, stefanr@s5r6.in-berlin.de,
        lethal@linux-sh.org, linville@tuxdriver.com, zajec5@gmail.com,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] slimbus: Linux driver framework for SLIMbus.
Message-ID: <20110817131256.GA10209@sirena.org.uk>
References: <1313019091-15354-1-git-send-email-kheitke@codeaurora.org>
 <20110815193724.GB2465@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110815193724.GB2465@flint.arm.linux.org.uk>
X-Cookie: Being ugly isn't illegal.  Yet.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 15, 2011 at 08:37:24PM +0100, Russell King wrote:
> On Wed, Aug 10, 2011 at 05:31:28PM -0600, Kenneth Heitke wrote:

> > SLIMbus (Serial Low Power Interchip Media Bus) is a specification
> > developed by MIPI (Mobile Industry Processor Interface) alliance.

> This looks like another bus doing the same thing as SPI and I2C.

It's got some similarities with I2C and SPI but there's some important
diffferences too, in terms of software it's got many of the features of
things like USB - there's data channels, bus wide clocking and a probe
mechanism.

> 3. drivers contain essentially the same ID structure:
> #define I2C_NAME_SIZE   20
> #define I2C_MODULE_PREFIX "i2c:"
> struct i2c_device_id {

In this case the IDs should definitely be different as there's IDs in
the hardware which drivers ought to be able to bind to (in theory the
bus can be hotplugged).

I do agree that there's room for some code sharing with the
non-probeable buses.
