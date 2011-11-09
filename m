Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753493Ab1KIN7W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 08:59:22 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:52852 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753058Ab1KIN7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 08:59:21 -0500
Message-ID: <4EBA8735.902@gmail.com>
Date: Wed, 09 Nov 2011 07:59:17 -0600
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: "Cousson, Benoit" <b-cousson@ti.com>
CC: Sascha Hauer <s.hauer@pengutronix.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        devicetree-discuss@lists.ozlabs.org,
        Sascha Hauer <kernel@pengutronix.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC 6/8] of: add clock providers
References: <1320801583-12774-1-git-send-email-grant.likely@secretlab.ca> <1320801583-12774-7-git-send-email-grant.likely@secretlab.ca> <20111109091328.GY16886@pengutronix.de> <4EBA62AD.3000407@ti.com>
In-Reply-To: <4EBA62AD.3000407@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/09/2011 05:23 AM, Cousson, Benoit wrote:
> On 11/9/2011 10:13 AM, Sascha Hauer wrote:
>> On Tue, Nov 08, 2011 at 06:19:41PM -0700, Grant Likely wrote:
> 
> [...]
> 
>>> +Sources of clock signal can be represented by any node in the device
>>> +tree.  Those nodes are designated as clock providers.  Clock consumer
>>> +nodes use a phandle and clock specifier pair to connect clock provider
>>> +outputs to clock inputs.  Similar to the gpio specifiers, a clock
>>> +specifier is an array of one more more cells identifying the clock
>>> +output on a device.  The length of a clock specifier is defined by the
>>> +value of a #clock-cells property in the clock provider node.
>>> +
>>> +[1] http://patchwork.ozlabs.org/patch/31551/
>>> +
>>> +==Clock providers==
>>> +
>>> +Required properties:
>>> +#clock-cells:       Number of cells in a clock specifier; typically
>>> will be
>>> +           set to 1
>>> +
>>> +Optional properties:
>>> +clock-output-name: Recommended to be a list of strings of clock
>>> output signal
>>> +           names indexed by the first cell in the clock specifier.
>>> +           However, the meaning of clock-output-names is domain
>>> +           specific to the clock provider, and is only provided to
>>> +           encourage using the same meaning for the majority of clock
>>> +           providers.  This format may not work for clock providers
>>> +           using a complex clock specifier format.  In those cases it
>>> +           is recommended to omit this property and create a binding
>>> +           specific names property.
>>
>> If the clock-output-name property is omitted, does this mean a clock
>> provider only has a single output or does it mean that it's not known
>> how many clock outputs a provider actually has?
> 
> Allowing several outputs for a single clock node might lead to a lot of
> confusion. What will be the meaning of a clock rate if you have several
> outputs at different frequency?

You typically only have a frequency property for fixed clocks.

However, we should think about how to set frequency for programmable
clocks. Perhaps this is just making clock-frequency an array of
values in the same order as the outputs.

> I think it will be better to define a clock node as a single source of
> clock. If several outputs are needed, then we should define several
> clock nodes.
> If we let a clock node be any kind of big clock blob, we will never be
> able to define some generic reusable clock node API. Everybody will
> define its own custom clock blobs.
> 

Whether you decide to implement a blob or every single mux, divider, and
gate is independent from whether you use generic clock code or not. You
could simply define a clock controller node with lots of outputs yet
still use generic code to implement clock support in Linux. The reality
is you will probably have a mixture of generic and SOC-specific clocks.

What is our goal here? I'm skeptical we will ever get to the point that
we can fully describe the clock tree for a new SOC without any code
changes. Perhaps our goal is simply that clock differences across all
boards for an SOC can be described in DT.

Rob

