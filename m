Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752835Ab2KEHa5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 02:30:57 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:4683 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751699Ab2KEHaz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 02:30:55 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Sun, 04 Nov 2012 23:29:31 -0800
From: Alex Courbot <acourbot@nvidia.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: Grant Likely <grant.likely@secretlab.ca>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: How about a gpio_get(device *, char *) function?
Date: Mon, 5 Nov 2012 16:31:23 +0900
Message-ID: <7471321.6NJDeDGfYW@percival>
Organization: NVIDIA
User-Agent: KMail/4.9.2 (Linux/3.6.4-1-ARCH; KDE/4.9.2; x86_64; ; )
In-Reply-To: <CACRpkdZc3cEGfSKW-b=G31yuw_E-GOXid3jkxZ0tuKYGYRE5Nw@mail.gmail.com>
References: <38620644.IyR5R8rjKP@percival> <CACRpkdZc3cEGfSKW-b=G31yuw_E-GOXid3jkxZ0tuKYGYRE5Nw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus, thanks for the reply!

On Monday 05 November 2012 02:04:33 Linus Walleij wrote:
> On Wed, Oct 31, 2012 at 10:04 AM, Alex Courbot <acourbot@nvidia.com> wrote:
> > Would anyone be opposed to having a gpio_get() function that works
> > similarly to e.g. regulator_get() and clk_get()?
> 
> I understand the concept and why you want to do this.
> 
> However I think the global GPIO numberspace defeats the
> purpose.
> 
> gpio_get() should get an abstract handle just like clk_get() or
> regulator_get(), not a fixed numeral.
> 
> That is the only way to really transit away from the global GPIO
> numberspace.

Interesting. I see you already gave the whole thing a thought. What I don't 
understand however is what is so wrong with the current GPIO numberspace that 
you want to replace it? Whether we use simple integers or blind pointers, the 
adressable space will basically remain the same. GPIO numbers can actually be 
considered as handles, and actually I would not mind typedef'ing "int" to a 
GPIO handle type in order to add more opacity to the framework.

Also the current DT bindings will likely continue to require the legacy API 
anyway, so I am not sure we can make it go away.

My initial thought was to build something on top of the existing scheme to 
address my immediate needs - what you are talking about is much more scary. :) 
Could you elaborate on your motivations for such a radical direction? 

Thanks,
Alex.

