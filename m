Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755710Ab1DUXrP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 19:47:15 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:40339 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755529Ab1DUXrO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 19:47:14 -0400
MIME-Version: 1.0
In-Reply-To: <20110421120855.GC2135@pengutronix.de>
References: <1303116654-5042-1-git-send-email-monstr@monstr.eu>
 <20110418160658.GD23814@pengutronix.de> <BANLkTimFnfgiQ5aMq_KwqHP8p92pjOJJwg@mail.gmail.com>
 <20110421120855.GC2135@pengutronix.de>
From: John Williams <john.williams@petalogix.com>
Date: Fri, 22 Apr 2011 09:46:53 +1000
Message-ID: <BANLkTinBZxBcc3fRo_jc4=VuY3D2pbaAzg@mail.gmail.com>
Subject: Re: [PATCH v3] uio/pdrv_genirq: Add OF support
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: Michal Simek <monstr@monstr.eu>, devicetree-discuss@lists.ozlabs.org,
        grant.likely@secretlab.ca, linux-kernel@vger.kernel.org,
        hjk@hansjkoch.de, arnd@arndb.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wolfram,

On Thu, Apr 21, 2011 at 10:08 PM, Wolfram Sang <w.sang@pengutronix.de> wrote:
> On Tue, Apr 19, 2011 at 11:58:25AM +1000, John Williams wrote:
>
>> As we discussed at ELC, putting a real vendor/device in there is also
>> broken because all instances in the system wil bind to the generic
>> uio, which is not necessarily what is desired.
>
> IIRC I pointed you to mpc5200b-psc devices which also have multiple functions
> and have seperate bindings for these functions. It fits the "hardware
> description" character of a dt, because it says this PSC is a UART or an
> SPI or whatever.

Right, and my interpretation of that was basically - modify the device
tree as required to make the correct driver bind to the device.

Is that correct?

It's the same underlying piece of silicon, you are just using the
device tree to tell Linux how it should behave at runtime, and which
driver to bind.

If so, it seems to be exactly what Arnd and Grant don't want - having
the device tree describe Linux behaviour.

In the hardware, it's a multifunction device, so surely a clean DTS
would just have 'mpc5200b', but no attempt to describe how Linux
should bind to it and configure it.  Instead this should be done at
runtime, using some yet-to-be-determined mechanism.

The difference between what you are doing for these multifunction
devices, versus the generic-uio approach, is surely only a matter of
degree rather than fundamentals?

Regards,

John
