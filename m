Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756295Ab2EHV0V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 17:26:21 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:55933 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751445Ab2EHV0U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 17:26:20 -0400
Message-ID: <4FA98F78.4080803@wwwdotorg.org>
Date: Tue, 08 May 2012 15:26:16 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>
CC: Laxman Dewangan <ldewangan@nvidia.com>, "lrg@ti.com" <lrg@ti.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH V1] regulator: fixed: dt: add property for gpio open drain
 flag
References: <1336386499-20408-1-git-send-email-ldewangan@nvidia.com> <4FA7E4A3.6050004@wwwdotorg.org> <4FA7E57B.30804@nvidia.com> <4FA7E841.7020100@wwwdotorg.org> <20120507162419.GK17002@opensource.wolfsonmicro.com>
In-Reply-To: <20120507162419.GK17002@opensource.wolfsonmicro.com>
X-Enigmail-Version: 1.5pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/07/2012 10:24 AM, Mark Brown wrote:
> On Mon, May 07, 2012 at 09:20:33AM -0600, Stephen Warren wrote:
> 
>> My point is that there's clear intent for of_gpio_simple_xlate()
>> to return the GPIO flags from a field in the GPIO specifier in
>> device tree, irrespective of whether some GPIO bindings don't
>> allow this, or whether this is fully documented.
> 
> It's really not idiomatic for drivers using GPIOs to allow
> configuration of their flags in the first place.  Or, quite
> frankly, to use flags. Honestly I'd not expect any bindings that
> the GPIO driver provides to have any attention at all paid to them
> most of the time, looking at the code seems to support that (though
> there's surprisingly few bindings using GPIOs at all it seems).

So, are you saying we should remove the flags from the GPIO bindings,
and do something custom in each consumer?

Right now, we can't rely on of_get_gpio_flags(), since not all GPIO
drivers actually allow flags to be represented in bindings.

However, having each client have a unique binding for things like
open-drain, inverted, ... seems bad; there are probably fewer
providers than consumers, although a single standardized
representation might admittedly have been ever better.

> Before we start doing stuff to improve this it feels like we should
> do things like get devm_ versions of gpiolib APIs in there (since
> most conversions would really benefit from that too) - I've been
> sending a patch for that but my backlog of unmerged patches for it
> keeps getting bigger rather than smaller.
> 
>> We shouldn't have two different mechanisms to represent this 
>> information. How do we resolve the situation where a particular
>> SoC's GPIO binding allows the flags to be specified, and this
>> patch allows the open-drain flag to be specified, and the two
>> values are different?
> 
>> Either we should force all bindings to have some way of
>> specifying the flags, or we should remove the flags from all
>> bindings and rely on separate properties.
> 
> There's also the case where the bindings probably should be
> ignored because the device driver knows what the connection has to
> be anyway and there's no point in forcing people to encode it in
> the binding.
> 
> It's a real shame all these bindings are driver specific, it's just
> like interrupts :(

