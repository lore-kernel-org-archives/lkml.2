Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753542Ab1KDVO7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 17:14:59 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42419 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753240Ab1KDVO6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 17:14:58 -0400
Date: Fri, 4 Nov 2011 21:14:48 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Olof Johansson <olof@lixom.net>
Cc: Rajendra Nayak <rnayak@ti.com>, grant.likely@secretlab.ca,
        patches@linaro.org, tony@atomide.com,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, lrg@ti.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 1/4] regulator: helper routine to extract
 regulator_init_data
Message-ID: <20111104211447.GC2541@opensource.wolfsonmicro.com>
References: <1319721864-30067-1-git-send-email-rnayak@ti.com>
 <20111104202905.GA3918@quad.lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111104202905.GA3918@quad.lixom.net>
X-Cookie: You will be married within a year.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 04, 2011 at 01:29:05PM -0700, Olof Johansson wrote:
> On Thu, Oct 27, 2011 at 06:54:24PM +0530, Rajendra Nayak wrote:

> > @@ -0,0 +1,33 @@
> > +Voltage/Current Regulators

> There should be a mandatory compatible field here, right? I.e. a topmost
> generic one, "regulator" or similar.

It's not really useful for the regulator subsystem to directly bind to
the device as something needs to actually control it, the idea is that
this binding is included by reference in the bindings for specific
devices.

> Also, lower-caps is common instead of V and A.

On the other hand the case is pretty important for SI units

> > +- <name>-supply: phandle to the parent supply/regulator node

> Having a fixed name here instead of a free form string would probably be a good
> idea?

The name will be fixed by the individual device bindings, this is
specifying the general form of a supply property.  Each device binding
will define the set of supplies that the device can use.
