Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756883Ab2KACq3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 22:46:29 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:10983 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754681Ab2KACq2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 22:46:28 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 31 Oct 2012 19:33:39 -0700
From: Alex Courbot <acourbot@nvidia.com>
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: How about a gpio_get(device *, char *) function?
Date: Thu, 1 Nov 2012 11:48:13 +0900
Message-ID: <17133691.o4iLtizVux@percival>
Organization: NVIDIA
User-Agent: KMail/4.9.2 (Linux/3.6.3-1-ARCH; KDE/4.9.2; x86_64; ; )
In-Reply-To: <509142F5.4010307@wwwdotorg.org>
References: <38620644.IyR5R8rjKP@percival> <509142F5.4010307@wwwdotorg.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 31 October 2012 23:25:41 Stephen Warren wrote:
> On 10/31/2012 03:04 AM, Alex Courbot wrote:
> > Hi,
> > 
> > Would anyone be opposed to having a gpio_get() function that works
> > similarly to e.g. regulator_get() and clk_get()?
> 
> One major stumbling block is that with device tree, each individual
> binding gets to decide on the specific naming of the propert{y,ies} that
> define the GPIO(s) for the device, and so there's no way to provide a
> generic implementation of that function.

The idea is not to make every GPIOs declared so far accessible through this 
function - as you point out this would be tricky at best - but to also define 
how they should be properly declared (similarly to regulators and pals) for 
bindings that need to use get_gpio(). Existing bindings and drivers that can 
live without it should not be modified. And now that you mention it, the end of 
the GPIO declaration anarchy would be another point in favor of this feature.

Now I am aware that almost every subsystem comes with its own scheme for 
declaring resources in the DT and there will be an long fight to decide which 
one should apply here, but I'm willing to take that road.

> Related, I've always wished that DT nodes looked like:
> 
> device {
>     reg = <...>;
>     compatible = <...>;
>     resources {
>         pwms = <...>;
>         regulators = <...>;
>         clocks = <...>;
>         gpios = <...>;
>         other-devices = <...>; /* for custom API dependencies */
>     };
>     config {
>         /* device-specific properties */
>     };
>     child-busses {
>         0 = { ... };
>         1 = { ... };
>     };
> };
> 
> ... specifically so that all resource allocation, and perhaps even child
> bus enumeration, could be completely standardized in the DT/device core.
> This could also feed into deferred probe, which could then be purely
> implemented inside the DT/driver core. However, that'd require something
> incompatible like "device tree 2.0"

I think this would be awesome. This could even probably be implemented without 
breaking things, if everything takes place inside well-defined subnodes of the 
device.

Alex.

