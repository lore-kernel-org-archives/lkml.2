Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753224Ab2K2RV1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 12:21:27 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:33042 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751331Ab2K2RVZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 12:21:25 -0500
Date: Thu, 29 Nov 2012 09:21:20 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Christopher Heiny <cheiny@synaptics.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        Linux Input <linux-input@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Allie Xiong <axiong@synaptics.com>, Vivian Ly <vly@synaptics.com>,
        Daniel Rosenberg <daniel.rosenberg@synaptics.com>,
        Alexandra Chin <alexandra.chin@tw.synaptics.com>,
        Joerie de Gram <j.de.gram@gmail.com>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: Re: [PATCH 2/4] Input: RMI4 - move sensor driver and F01 handler
 into the core
Message-ID: <20121129172120.GA3656@core.coreip.homeip.net>
References: <1354008098-26346-1-git-send-email-dmitry.torokhov@gmail.com>
 <1354008098-26346-2-git-send-email-dmitry.torokhov@gmail.com>
 <50B6EA88.2010506@synaptics.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50B6EA88.2010506@synaptics.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chris,
On Wed, Nov 28, 2012 at 08:54:32PM -0800, Christopher Heiny wrote:
> On 11/27/2012 01:21 AM, Dmitry Torokhov wrote:
> >There is no point in having the sensor driver and F01 handler separate
> >from the RMI core since it is not useful without them and having them
> >all together simplifies initialization among other things.
> 
> Hi Dmitry,
> 
> I've been looking at this patch as well as your patch 3/4 changes,
> and I'm not sure it's for the better.
> 
> One thing that confuses me is that these appear to go against the
> advice we've been getting over the past months to rely more on
> standard kernel bus and driver implementations, instead of the
> "roll-your-own" implementation we had been using before.
> 
> More importantly, the patches inextricably link the sensor driver
> implementation and the F01 driver implementation to the bus
> implementation, and means that any given system can have only one
> way of managing F01.  As you observed, a sensor is pretty much
> useless without an F01 handler, but I am reasonably sure that there
> will be future systems that have more than one RMI4 sensor in them,
> and there is a strong possibility that these sensors may have
> different requirements for handling F01.  In the near future, then,
> these changes will have to be refactored back to something more like
> the structure of our 2012/11/16 patch set.
> 
> Additionally, having F01 as a special case means that when we start
> implementing things such as support for request_firmware(), there
> will have to be a bunch of special case code to deal with F01, since
> it's no longer "just another function driver".  That seems to go in
> exactly the opposite direction of the simplification that you're
> trying to achieve.

But F01 continues to being "just another function driver" even with my
changes. It is still registered as rmi_fucntion_handler and uses
standard matching mechanisms to bind to rmi_functions registered by the
sensor driver. What I changed is the fact that rmi_f01 is no longer a
separate module which could be loaded after loading rmi_bus and it can't
be unloaded without unloading rmi_bus. This simplifies things and makes
it easier to have rmi core compiled as a module.

Also I do not quite follow your idea that devices might have different
requirements for handling F01. If that is true then be _can't_ implement
"F01" as "another function driver"... But that is orthogonal for the 3/4
change we are discussing here.

Thanks.

-- 
Dmitry
