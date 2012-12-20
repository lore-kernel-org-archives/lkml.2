Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752278Ab2LTA6d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 19:58:33 -0500
Received: from mail-vc0-f176.google.com ([209.85.220.176]:42254 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751616Ab2LTA6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 19:58:25 -0500
MIME-Version: 1.0
In-Reply-To: <CAPnjgZ30MQS1OT3GOFLG9HntoD8NrzNw6bB_d1fiJEgHcMDGUA@mail.gmail.com>
References: <1355464254-12768-1-git-send-email-ch.naveen@samsung.com>
 <1355464254-12768-2-git-send-email-ch.naveen@samsung.com> <20121219123201.B636A3E0AD7@localhost>
 <20121219171423.GW4985@opensource.wolfsonmicro.com> <CAPnjgZ30MQS1OT3GOFLG9HntoD8NrzNw6bB_d1fiJEgHcMDGUA@mail.gmail.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Thu, 20 Dec 2012 00:58:05 +0000
X-Google-Sender-Auth: 5LJEdpugLqoTnTjGo2e65atRn90
Message-ID: <CACxGe6vyK80pvV1CE=zu7LNEmeKDZg3cpQ5PKZjaVjvL+gc2yg@mail.gmail.com>
Subject: Re: [PATCH 1/2] i2c-core: Add gpio based bus arbitration implementation
To: Simon Glass <sjg@chromium.org>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        lk <linux-kernel@vger.kernel.org>, linux-samsung-soc@vger.kernel.org,
        Wolfram Sang <w.sang@pengutronix.de>,
        Jean Delvare <khali@linux-fr.org>, Ben Dooks <ben-linux@fluff.org>,
        Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Grant Grundler <grundler@chromium.org>,
        Naveen Krishna <naveen@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 20, 2012 at 12:17 AM, Simon Glass <sjg@chromium.org> wrote:
> On Wed, Dec 19, 2012 at 9:14 AM, Mark Brown
> <broonie@opensource.wolfsonmicro.com> wrote:
>> On Wed, Dec 19, 2012 at 12:32:01PM +0000, Grant Likely wrote:
>>
>>> I'm not convinced on the design of this protocol. It won't scale beyond
>>> 2 bus masters and it seems very specific to the design of a specific
>>> piece of hardware. I don't think it is mature enough to bake into the
>>
>> I ought to point out that the original patch would've baked this into
>> the Samsung I2C driver but I asked for it to be split out as it's
>> nothing to do with the controller really and I'm sure I've seen it
>> before.
>
> Grant your idea looks nice to me. I only worry if we should wait until
> we have a second user before going so far with it. But it is certainly
> a nice general solution.
>
> The scaling beyond two bus masters would require the code to be
> changed to check more input lines from other masters. Best avoided for
> now I think until we have a use for it.

There is two parts to this; the design of the binding, and the
implementation. Of the two, the binding is the most difficult to
change, so it is important to get something we can live with long term
sorted out now. The implementation can start somewhat naive, with a
plan for how to extend it.

Regarding the scaling to multiple devices, it is a much smaller issue
(if an issue at all) if the arbitration back end is pluggable. Then it
becomes easy to support hardware with a different arbitration
protocol. If it gets baked into the core i2c code, then we've got a
problem and a lot more scrutiny needs to be put into this specific
protocol.

g.
