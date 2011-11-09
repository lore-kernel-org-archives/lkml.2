Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752745Ab1KINb2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 08:31:28 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:35303 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344Ab1KINb1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 08:31:27 -0500
Message-ID: <4EBA80AC.30604@gmail.com>
Date: Wed, 09 Nov 2011 07:31:24 -0600
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Sascha Hauer <s.hauer@pengutronix.de>
CC: Grant Likely <grant.likely@secretlab.ca>,
        devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org,
        Sascha Hauer <kernel@pengutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [RFC 6/8] of: add clock providers
References: <1320801583-12774-1-git-send-email-grant.likely@secretlab.ca> <1320801583-12774-7-git-send-email-grant.likely@secretlab.ca> <20111109091328.GY16886@pengutronix.de>
In-Reply-To: <20111109091328.GY16886@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/09/2011 03:13 AM, Sascha Hauer wrote:
> On Tue, Nov 08, 2011 at 06:19:41PM -0700, Grant Likely wrote:
>> Based on work by Ben Herrenschmidt and Jeremy Kerr, this patch adds an
>> of_clk_get function to allow platforms to retrieve clock data from the
>> device tree.
>>
>> Platform register a provider through of_clk_add_provider, which will be
>> called when a device references the provider's OF node for a clock
>> reference.
>>
>> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
>> ---
>>  .../devicetree/bindings/clock/clock-bindings.txt   |  109 +++++++++++++++++
>>  drivers/of/Kconfig                                 |    6 +
>>  drivers/of/Makefile                                |    1 +
>>  drivers/of/clock.c                                 |  129 ++++++++++++++++++++
>>  include/linux/of_clk.h                             |   37 ++++++
>>  5 files changed, 282 insertions(+), 0 deletions(-)
>>  create mode 100644 Documentation/devicetree/bindings/clock/clock-bindings.txt
>>  create mode 100644 drivers/of/clock.c
>>  create mode 100644 include/linux/of_clk.h
>>
>> diff --git a/Documentation/devicetree/bindings/clock/clock-bindings.txt b/Documentation/devicetree/bindings/clock/clock-bindings.txt
>> new file mode 100644
>> index 0000000..4770c7e
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/clock/clock-bindings.txt
>> @@ -0,0 +1,109 @@
>> +This binding is a work-in-progress, and are based on some experimental
>> +work by benh[1].
>> +
>> +Sources of clock signal can be represented by any node in the device
>> +tree.  Those nodes are designated as clock providers.  Clock consumer
>> +nodes use a phandle and clock specifier pair to connect clock provider
>> +outputs to clock inputs.  Similar to the gpio specifiers, a clock
>> +specifier is an array of one more more cells identifying the clock
>> +output on a device.  The length of a clock specifier is defined by the
>> +value of a #clock-cells property in the clock provider node.
>> +
>> +[1] http://patchwork.ozlabs.org/patch/31551/
>> +
>> +==Clock providers==
>> +
>> +Required properties:
>> +#clock-cells:	   Number of cells in a clock specifier; typically will be
>> +		   set to 1
>> +
>> +Optional properties:
>> +clock-output-name: Recommended to be a list of strings of clock output signal
>> +		   names indexed by the first cell in the clock specifier.
>> +		   However, the meaning of clock-output-names is domain
>> +		   specific to the clock provider, and is only provided to
>> +		   encourage using the same meaning for the majority of clock
>> +		   providers.  This format may not work for clock providers
>> +		   using a complex clock specifier format.  In those cases it
>> +		   is recommended to omit this property and create a binding
>> +		   specific names property.
> 
> If the clock-output-name property is omitted, does this mean a clock
> provider only has a single output or does it mean that it's not known
> how many clock outputs a provider actually has?

Neither. It's similar to how interrupt bindings work. For a clock
consumer, you have a phandle to the parent and some number of cells to
describe the connection. Often this is just the index or local interrupt
number. Obviously, interrupt numbers make more sense than clock numbers,
so having names is more useful in the clocks case if you have many outputs.

The name strings are just additional information. Keep in mind that the
clock node name can also be used if you need to attach a name to a clock.

Rob

