Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754325Ab1JTGDX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 02:03:23 -0400
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:4844 "EHLO
	VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753176Ab1JTGDW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 02:03:22 -0400
X-SpamScore: -9
X-BigFish: VS-9(zz1432N98dKzz1202hzzz2dh2a8h668h839h944h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Thu, 20 Oct 2011 14:14:09 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Rajendra Nayak <rnayak@ti.com>
CC: <broonie@opensource.wolfsonmicro.com>, <grant.likely@secretlab.ca>,
        <patches@linaro.org>, <tony@atomide.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <lrg@ti.com>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 3/5] regulator: helper routine to extract
 regulator_init_data
Message-ID: <20111020061408.GE32007@S2100-06.ap.freescale.net>
References: <1318263578-7407-1-git-send-email-rnayak@ti.com>
 <1318263578-7407-4-git-send-email-rnayak@ti.com>
 <20111018132032.GD30703@S2100-06.ap.freescale.net>
 <4E9EB61C.1040207@ti.com>
 <20111019144215.GA32007@S2100-06.ap.freescale.net>
 <4E9FAF42.5060200@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4E9FAF42.5060200@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 20, 2011 at 10:48:58AM +0530, Rajendra Nayak wrote:
> >Let's look at mc13892-regulator driver.  There are 23 regulators defined
> >in array mc13892_regulators.  Needless to say, there is a dev behind
> >mc13892-regulator driver.  And when getting probed, this driver will
> >call regulator_register() to register those 23 regulators individually.
> >That said, for non-dt world, we have 1 + 23 'dev' with that 1 as the
> >parent of all other 23 'dev' (wrapped by regulator_dev).  But with the
> >current DT implementation, we will have at least 1 + 23 * 2 'dev'.
> >These extra 23 'dev' is totally new with DT.
> >
> 
> but thats only because the mc13892-regulator driver is implemeted in
> such a way that all the regulators on the platform are bundled in as
> *one* device.

I did not look into too many regulator drivers, but I expect this is
way that most regulator drivers are implemented in.  Having
mc13892-regulator being probed 23 times to register these 23 regulators
just makes less sense to me.

> It would again depend on how you would pass these from
> the DT, if you indeed stick to the same way of bundling all regulators
> as one device from DT, the mc13892-regulator probe would just get called
> once and there would be one device associated, no?
> 
Yes, I indeed would stick to the same way of bundling the registration
of all regulators with mc13892-regulator being probed once.  The problem
I have with the current regulator core DT implementation is that it
assumes the device_node of rdev->dev (dev wrapped in regulator_dev) is
being attached to rdev->dev.parent rather than itself.  Back to
mc13892-regulator example, that said, it requires the dev of
mc13892-regulator have the device_node of individual regulator attached
to.  IOW, the current implementation forces mc13892-regulator to be
probed 23 times to register those 23 regulators.  This is wrong to me.

-- 
Regards,
Shawn

