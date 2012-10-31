Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757870Ab2JaPZp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 11:25:45 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:33341 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753438Ab2JaPZo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 11:25:44 -0400
Message-ID: <509142F5.4010307@wwwdotorg.org>
Date: Wed, 31 Oct 2012 09:25:41 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Alex Courbot <acourbot@nvidia.com>
CC: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: How about a gpio_get(device *, char *) function?
References: <38620644.IyR5R8rjKP@percival>
In-Reply-To: <38620644.IyR5R8rjKP@percival>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/31/2012 03:04 AM, Alex Courbot wrote:
> Hi,
> 
> Would anyone be opposed to having a gpio_get() function that works similarly 
> to e.g. regulator_get() and clk_get()?

One major stumbling block is that with device tree, each individual
binding gets to decide on the specific naming of the propert{y,ies} that
define the GPIO(s) for the device, and so there's no way to provide a
generic implementation of that function.

Related, I've always wished that DT nodes looked like:

device {
    reg = <...>;
    compatible = <...>;
    resources {
        pwms = <...>;
        regulators = <...>;
        clocks = <...>;
        gpios = <...>;
        other-devices = <...>; /* for custom API dependencies */
    };
    config {
        /* device-specific properties */
    };
    child-busses {
        0 = { ... };
        1 = { ... };
    };
};

... specifically so that all resource allocation, and perhaps even child
bus enumeration, could be completely standardized in the DT/device core.
This could also feed into deferred probe, which could then be purely
implemented inside the DT/driver core. However, that'd require something
incompatible like "device tree 2.0"
