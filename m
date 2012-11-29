Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753699Ab2K2ReM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 12:34:12 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:50262 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003Ab2K2ReK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 12:34:10 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: How about a gpio_get(device *, char *) function?
To: Alex Courbot <acourbot@nvidia.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <2022442.P80mCjSeu2@percival>
References: <38620644.IyR5R8rjKP@percival> <CACRpkdaUJKs7zx=JWRUb+0Qz2dQU=R5KUK+CoM+nLCgHL99AFA@mail.gmail.com> <20121126111431.AE4C23E09C2@localhost> <2022442.P80mCjSeu2@percival>
Date: Thu, 29 Nov 2012 17:34:07 +0000
Message-Id: <20121129173407.11A543E0A04@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Nov 2012 12:38:38 +0900, Alex Courbot <acourbot@nvidia.com> wrote:
> On Monday 26 November 2012 19:14:31 Grant Likely wrote:
> > I don't have any problem with a gpio_get function, but I do agree that
> > making it return an opaque handle is how it should be written with a new
> > set of accessors. The handle should probably be simply the pointer to
> > the &gpio_desc[number] which is a private table in gpiolib.c. The
> > definition of it isn't available outside of gpiolib.c
> 
> That looks like a reasonable approach, but this would make the new API 
> available only to systems that use GPIOlib. Shouldn't we be concerned about 
> making this available to all GPIO implementations? Or is GPIOlib so widely 
> used that we don't care?

I'm tempted to say non-gpiolib is not supported. However, there isn't
anything that would prevent non-gpiolib users from implementing the api
themselves, but they'd need to provide their own handle..

g.
