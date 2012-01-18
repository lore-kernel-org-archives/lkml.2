Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757578Ab2ARTyF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 14:54:05 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:19468 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752091Ab2ARTyD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 14:54:03 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 18 Jan 2012 11:52:29 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Thomas Abraham <thomas.abraham@linaro.org>
CC: Dong Aisheng-B29396 <B29396@freescale.com>,
        "linus.walleij@stericsson.com" <linus.walleij@stericsson.com>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "cjb@laptop.org" <cjb@laptop.org>,
        "Simon Glass (sjg@chromium.org)" <sjg@chromium.org>,
        Dong Aisheng <dongas86@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>
Date: Wed, 18 Jan 2012 11:52:27 -0800
Subject: RE: Pinmux bindings proposal
Thread-Topic: Pinmux bindings proposal
Thread-Index: AczV2vZo6IZjwdpJRhWCzEyghMUjSAAPzpCQ
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF1780DAAEB8@HQMAIL01.nvidia.com>
References: <74CDBE0F657A3D45AFBB94109FB122FF17801D202F@HQMAIL01.nvidia.com>
 <CAJuYYwSNuMAcjaTNeCq=LmeP8KrvGNjcn1FP6VY0NarEhkY_aA@mail.gmail.com>
In-Reply-To: <CAJuYYwSNuMAcjaTNeCq=LmeP8KrvGNjcn1FP6VY0NarEhkY_aA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Abraham wrote at Wednesday, January 18, 2012 5:16 AM:
> On 14 January 2012 02:09, Stephen Warren <swarren@nvidia.com> wrote:
> > I thought a bit more about pinmux DT bindings. I came up with something
> > that I like well enough, and is pretty similar to the binding that Dong
> > posted recently. I think it'll work for both Tegra's and IMX's needs.
> > Please take a look!
...
> The pinmux_get() function checks if there is an active user of the
> pinmux and declines requests if the pinmux has been taken. With the dt
> bindings that you have listed, can such a check be still enforced.

I believe so.

I see these bindings as simply providing the data to populate the same
pinmux mapping table that's currently used by the pinctrl subsystem.
therefore, there are no changes to the operation of the pinctrl subsystem
(beyond a little extra code to parse the map from DT instead of receiving
a static table from a board file), and no changes to the way drivers
use the pinctrl APIs. Hence, all that error-checking will still operate
as-is.

> Also, will it be possible to support runtime pinmuxing with the above
> listed dt bindings?

Yes, the pinctrl/pinctrl-names properties allow defining a set of names
states, just like the mapping table does, and a driver can get one,
release it, then get a different named state, etc.

-- 
nvpublic

