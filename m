Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934502Ab2JXJFT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 05:05:19 -0400
Received: from vsp-authed02.binero.net ([195.74.38.226]:36794 "HELO
	vsp-authed-03-02.binero.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933757Ab2JXJFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 05:05:17 -0400
Message-ID: <5087AF40.7090105@gaisler.com>
Date: Wed, 24 Oct 2012 11:05:04 +0200
From: Andreas Larsson <andreas@gaisler.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Peter Korsgaard <jacmet@sunsite.dk>
CC: linux-i2c@vger.kernel.org, Jean Delvare <khali@linux-fr.org>,
        Ben Dooks <ben-linux@fluff.org>, Wolfram Sang <w.sang@pengutronix.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, software@gaisler.com
Subject: Re: [PATCH 1/2] i2c: i2c-ocores: Add irq support for sparc
References: <1351004637-11049-1-git-send-email-andreas@gaisler.com> <1351004637-11049-2-git-send-email-andreas@gaisler.com> <87wqyhlzfv.fsf@macbook.be.48ers.dk>
In-Reply-To: <87wqyhlzfv.fsf@macbook.be.48ers.dk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/23/2012 10:13 PM, Peter Korsgaard wrote:
>>>>>> "Andreas" == Andreas Larsson <andreas@gaisler.com> writes:
>
>   Andreas> There are no platform resources of type IORESOURCE_IRQ on
>   Andreas> sparc, so the irq number is acquired in a different manner for
>   Andreas> sparc. The general case uses platform_get_irq, that internally
>   Andreas> still uses platform_get_resource.
>
> I have no idea why sparc is being odd in this regard, but assuming this
> is how it's done, I'm fine with this change.
>
> A quick grep doesn't find any other drivers doing this though:
>
> git grep -l archdata.irqs drivers | xargs grep platform_get_irq
>
> Acked-by: Peter Korsgaard <jacmet@sunsite.dk>

Other drivers that work both on sparc and on other platforms usually use 
irq_of_parse_and_map on a corresponding device_node. For non-sparc 
architectures irq_of_parse_and_map sets up mappings that needs to be 
teared down on module exit. Sparc however has its own version of 
irq_of_parse_and_map that just returns the irq number using archdata.irq[].

I am trying to get through a patch platform_get_irq to work for sparc as 
well. If that eventually goes through, the CONFIG_SPARC stuff can then 
be removed cleanly from this driver withouth having to mess with 
irq_of_parse_and_map and tearing mappings down.

Another solution is to use irq_of_parse_and_map for the of-case if no 
irq was found using platform_get_irq. But that would make for more 
rearrangements and add the need for irq_dispose_mapping to be added on 
module exit as well (even though the disposing would do nothing for sparc).

Cheers,
Andreas Larsson

