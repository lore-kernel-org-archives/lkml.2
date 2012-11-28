Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752413Ab2K1Diq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 22:38:46 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:3576 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751879Ab2K1Dip (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 22:38:45 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 27 Nov 2012 19:38:31 -0800
From: Alex Courbot <acourbot@nvidia.com>
To: Grant Likely <grant.likely@secretlab.ca>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: How about a gpio_get(device *, char *) function?
Date: Wed, 28 Nov 2012 12:38:38 +0900
Message-ID: <2022442.P80mCjSeu2@percival>
Organization: NVIDIA
User-Agent: KMail/4.9.3 (Linux/3.6.7-1-ARCH; KDE/4.9.3; x86_64; ; )
In-Reply-To: <20121126111431.AE4C23E09C2@localhost>
References: <38620644.IyR5R8rjKP@percival> <CACRpkdaUJKs7zx=JWRUb+0Qz2dQU=R5KUK+CoM+nLCgHL99AFA@mail.gmail.com> <20121126111431.AE4C23E09C2@localhost>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 26 November 2012 19:14:31 Grant Likely wrote:
> I don't have any problem with a gpio_get function, but I do agree that
> making it return an opaque handle is how it should be written with a new
> set of accessors. The handle should probably be simply the pointer to
> the &gpio_desc[number] which is a private table in gpiolib.c. The
> definition of it isn't available outside of gpiolib.c

That looks like a reasonable approach, but this would make the new API 
available only to systems that use GPIOlib. Shouldn't we be concerned about 
making this available to all GPIO implementations? Or is GPIOlib so widely 
used that we don't care?

Right now I have a very simple wrapper (for testing purposes) around the 
current integer-base GPIO namespace that accepts tables mapping consumers to 
GPIO numbers, much like Thierry did for the PWM subsystem. Integrating it into 
GPIOlib does not seem to be much more difficult ; it would require some 
refactoring though as most of the code should be shared by the two APIs.

This also seems to be the right opportunity (although not directly related) to 
switch the gpio_desc table into something more flexible. Two approaches come to 
mind: either a linked-list of gpio_chips ordered by base GPIO, or a radix-
tree. The small number of gpio chips in a system seem to make the first 
approach reasonable enough - GPIO lookup time would become linear instead of 
constant, but it should not be noticeable from the consumer perspective.

Alex.

