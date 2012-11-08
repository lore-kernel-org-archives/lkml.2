Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754090Ab2KHGVh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 01:21:37 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:18116 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752288Ab2KHGVg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 01:21:36 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 07 Nov 2012 22:08:13 -0800
From: Alex Courbot <acourbot@nvidia.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: Stephen Warren <swarren@wwwdotorg.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: How about a gpio_get(device *, char *) function?
Date: Thu, 8 Nov 2012 15:23:22 +0900
Message-ID: <1503934.I4tc7K6I6s@percival>
Organization: NVIDIA
User-Agent: KMail/4.9.2 (Linux/3.6.4-1-ARCH; KDE/4.9.2; x86_64; ; )
In-Reply-To: <CACRpkdYqCQc0Er1JR_eVzZPCycvKjd0Pph8Dcay0FbU3Q64D8A@mail.gmail.com>
References: <38620644.IyR5R8rjKP@percival> <1801189.6J3flQFRCq@percival> <CACRpkdYqCQc0Er1JR_eVzZPCycvKjd0Pph8Dcay0FbU3Q64D8A@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 08 November 2012 05:24:19 Linus Walleij wrote:
> On Tue, Nov 6, 2012 at 2:33 AM, Alex Courbot <acourbot@nvidia.com> wrote:
> > How about, in a first time (and because I'd also like to get the power
> > seqs
> > moving on), a typedef from int to gpio_handle_t and a first implementation
> > of the gpio_handle_*() API that would just call the existing
> > integer-based API (apart from gpio_handle_get())? That way things will
> > not break when we switch to a real handle.
> 
> I'm afraid of typedef:ing gpio_handle_t to int because it sort of
> encourages non-handlers to be used mixed with the old integers.
> 
> I would prefer to create, e.g. in <linux/gpio/consumer.h>
> something like:
> 
> struct gpio;
> 
> struct gpio *gpio_get(struct device *dev, const char *name);
> 
> int gpio_get_value(struct gpio *g);
> 
> Nothing more! I.e. struct gpio is an opaque cookie, nothing to be known
> about it.

However these is already a struct gpio declared in linux/gpio.h. Shall the 
opaque handler be renamed something like "struct gpioh", or is your idea to 
make both APIs mutually exclusive?

Alex.

