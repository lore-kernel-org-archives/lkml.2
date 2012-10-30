Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965193Ab2J3SCL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 14:02:11 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:59844 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759668Ab2J3SCJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 14:02:09 -0400
Message-ID: <5090161D.2030702@wwwdotorg.org>
Date: Tue, 30 Oct 2012 12:02:05 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Mike Turquette <mturquette@ti.com>
CC: Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>
Subject: Re: [RFC PATCH] dt: describe base reset signal binding
References: <1351028756-22309-1-git-send-email-swarren@wwwdotorg.org> <20121029183233.18780.11964@nucleus>
In-Reply-To: <20121029183233.18780.11964@nucleus>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/29/2012 12:32 PM, Mike Turquette wrote:
> Quoting Stephen Warren (2012-10-23 14:45:56)
>> What do people think of this? Does it sound like a good idea to go ahead
>> with a reset subsystem? Should we simply add a new API to the common clock
>> subsystem instead (and assume that reset and clock domains match 1:1).
>> Should this be implemented as part of the generic power management domains;
>> see include/linux/pm_domain.h instead?
>>
> 
> Hi Stephen,
> 
> I'm not sure a "reset subsystem" is necessary, but I also do not like
> using clocks as the keys for IP reset.

I'm not sure what you're suggesting as an alternative to a reset
subsystem (or API if you want something that sounds smaller!) :-)

> I think it is more common to map IPs to struct device, no?

It is indeed probably common that there's a 1:1 mapping between IP
blocks and struct device. However, I'm sure there are plenty of
counter-examples; IP blocks with multiple reset domains (hence struct
devices that encompass multiple reset domains, or reset domains that
encompass multiple struct devices), just as there are many examples of
non-1:1 mappings between struct device and struct clk.

Even ignoring that, we'd still need to API say device_reset(struct
device *dev) or device_reset(struct device *dev, const char *conid)
wouldn't we? That's really all I meant by a reset subsystem.

An alternative here would be to simply move Tegra's
tegra_periph_reset_{de,}assert() function prototypes into a header in
include/linux rather than mach-tegra/include/mach. However, I imagine at
least some other SoC needs a similar API, so a common API might be useful?
