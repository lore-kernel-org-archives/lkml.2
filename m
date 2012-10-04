Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752557Ab2JDHYd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 03:24:33 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:64128 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752003Ab2JDHYb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 03:24:31 -0400
Date: Thu, 4 Oct 2012 00:24:26 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: "Poddar, Sourav" <sourav.poddar@ti.com>
Cc: devicetree-discuss@lists.ozlabs.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org, b-cousson@ti.com, balbi@ti.com,
        santosh.shilimkar@ti.com
Subject: Re: [PATCHv3 2/4] Input: keypad: Add smsc ece1099 keypad driver
Message-ID: <20121004072426.GB14217@core.coreip.homeip.net>
References: <1349089310-22134-1-git-send-email-sourav.poddar@ti.com>
 <20121002061829.GA3853@core.coreip.homeip.net>
 <CAKdam55BEQi9tJb1yzKJWNhO7sHrW5NFHfsZjicw2NGYDEFovQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKdam55BEQi9tJb1yzKJWNhO7sHrW5NFHfsZjicw2NGYDEFovQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 03, 2012 at 11:26:46AM +0530, Poddar, Sourav wrote:
> Hi Dmitry,
> 
> On Tue, Oct 2, 2012 at 11:48 AM, Dmitry Torokhov
> <dmitry.torokhov@gmail.com> wrote:
> > Hi Sourav,
> >
> > On Mon, Oct 01, 2012 at 04:31:50PM +0530, Sourav Poddar wrote:
> >> From: G, Manjunath Kondaiah <manjugk@ti.com>
> >>
> >> +
> >> +     /* Enable smsc keypad interrupts */
> >> +     ret = smsc_write(dev, SMSC_KP_INT_MASK, 0xff);
> >> +     if (ret < 0)
> >> +             goto err2;
> >> +
> >> +     return 0;
> >> +
> >> +err2:
> >> +     input_unregister_device(input);
> >> +err1:
> >> +     input_free_device(input);
> >
> > Double free.
> >
> I believe what you are trying to say here is that we dont really
> need a " input_unregister_device" (as also I checked in other keypad
> implementations) and do a "unregister_device" in the remove api ??

What I was trying to say is that if input device has been registered
then you need to call input_unregister_device() to unregister and free
it, otherwise you need to call input_free_device(), but not both.

Thanks.

-- 
Dmitry
