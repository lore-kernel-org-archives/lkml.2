Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755577Ab1LMTK1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 14:10:27 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:39515 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754029Ab1LMTK0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 14:10:26 -0500
Message-ID: <4EE7A31E.7080301@gmail.com>
Date: Tue, 13 Dec 2011 13:10:22 -0600
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111124 Thunderbird/8.0
MIME-Version: 1.0
To: Kyle Moffett <Kyle.D.Moffett@boeing.com>
CC: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        Liam Girdwood <lrg@ti.com>, Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [REPOST RFC PATCH 0/3] New "gpio-poweroff" driver to turn off
 platform devices with GPIOs
References: <1323800614-12642-1-git-send-email-Kyle.D.Moffett@boeing.com>
In-Reply-To: <1323800614-12642-1-git-send-email-Kyle.D.Moffett@boeing.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/13/2011 12:23 PM, Kyle Moffett wrote:
> Hello again,
> 
> I posted this patch series a few weeks ago and saw no responses, so I
> tweaked the CC list and am reposting it again for review.
> 
> I'm working on support for some custom hardware of ours, and part of
> the support code is the ability for the software to shutdown the power
> supply using GPIOs (via an I2C GPIO controller).
> 
> I previously had this in my platform code, but it seemed generically
> useful, so I split it out into a separate module for others to use.
> 
> The first two patches are generic of_gpio enhancements, providing some
> new library functions for requesting lots of GPIOs at once.
> 
> The third patch is the actual driver itself.  The driver can be used to
> instantiate a platform device as a whole-machine-poweroff device as we
> use it on our hardware.  Alternatively it can instantiate multiple
> platform devs at specific locations on the device tree which trigger
> from the platform_driver->shutdown() callback.
> 
> For architectures which are still stuck in the dark ages, this driver
> also supports being instantiated via legacy platform_data.

Leave them there... :)

> The OpenFirmware binding documentation is added in the third patch.
> Since this is my first cut, it's a little rough, so please be gentle.
> 
> I'm interested to know what you all think.

Does the regulator framework gpio-regulator not work for this?

The DT gpio patches look useful on their own.

Rob
