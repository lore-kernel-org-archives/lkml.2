Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934017Ab1FWUz2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 16:55:28 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:55351 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932755Ab1FWUz1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 16:55:27 -0400
MIME-Version: 1.0
In-Reply-To: <4E00F9ED.1020500@gmail.com>
References: <20110621181127.18176.1384.stgit@ponder> <20110621184503.18176.88260.stgit@ponder>
 <4E00F9ED.1020500@gmail.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Thu, 23 Jun 2011 14:55:06 -0600
X-Google-Sender-Auth: 6E8EBvHiMKZwdmUM5LMTIbKBGu8
Message-ID: <BANLkTi=x0rPAg--t+_eP-JJ2uPEYgwPPLw@mail.gmail.com>
Subject: Re: [PATCH 3/5] drivers/amba: create devices from device tree
To: Rob Herring <robherring2@gmail.com>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>,
        devicetree-discuss@lists.ozlabs.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 21, 2011 at 2:07 PM, Rob Herring <robherring2@gmail.com> wrote:
> Grant,
>
> On 06/21/2011 01:45 PM, Grant Likely wrote:
>> Add a function to create amba_devices (i.e. primecell peripherals)
>> from device tree nodes. The device tree scanning is done by the
>> of_platform_populate() function which can call of_amba_device_create
>> based on a match table entry.
>>
>> Nodes with a "arm,primecell-periphid" property can override the h/w
>> peripheral id value.
>>
>> Based on the original work by Jeremy Kerr.
>>
>> Signed-off-by: Jeremy Kerr <jeremy.kerr@canonical.com>
>> Acked-by: Linus Walleij <linus.walleij@linaro.org>
>> Signed-off-by: Rob Herring <rob.herring@calxeda.com>
>> Reviewed-by: Arnd Bergmann <arnd@arndb.de>
>> [grant.likely: add Jeremy's original s-o-b line, changes from review
>>                comments, and moved all code to drivers/of/platform.c]
>> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
>> ---
>>  .../devicetree/bindings/arm/primecell.txt          |   21 ++++++
>>  drivers/of/platform.c                              |   71 ++++++++++++++++++++
>>  2 files changed, 92 insertions(+), 0 deletions(-)
>>  create mode 100644 Documentation/devicetree/bindings/arm/primecell.txt
>>
>> diff --git a/Documentation/devicetree/bindings/arm/primecell.txt b/Documentation/devicetree/bindings/arm/primecell.txt
>> new file mode 100644
>> index 0000000..1d5d7a8
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/arm/primecell.txt
>> @@ -0,0 +1,21 @@
>> +* ARM Primecell Peripherals
>> +
>> +ARM, Ltd. Primecell peripherals have a standard id register that can be used to
>> +identify the peripheral type, vendor, and revision. This value can be used for
>> +driver matching.
>> +
>> +Required properties:
>> +
>> +- compatible : should be a specific value for peripheral and "arm,primecell"
>
> Can I review what I wrote... Perhaps we should put strings in for all
> existing drivers in the kernel. This should be a complete list:
>
> arm,pl010
> arm,pl011
> st,pl011
> arm,pl022
> st,pl022
> st,pl023
> arm,pl030
> arm,pl031
> st,pl031
> arm,pl061
> arm,pl050
> arm,pl080
> arm,pl081
> st,pl080
> arm,pl110
> arm,pl180
> arm,pl330
> arm,sp804
> arm,sp805


Yes, this whole list should be added.

g.
