Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755370Ab1BWTUL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 14:20:11 -0500
Received: from mail3.caviumnetworks.com ([12.108.191.235]:10587 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751543Ab1BWTUJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 14:20:09 -0500
Message-ID: <4D655DE9.9080809@caviumnetworks.com>
Date: Wed, 23 Feb 2011 11:20:09 -0800
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: linux-mips@linux-mips.org, ralf@linux-mips.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 06/10] MIPS: Octeon: Initialize and fixup device tree.
References: <1298408274-20856-1-git-send-email-ddaney@caviumnetworks.com> <1298408274-20856-7-git-send-email-ddaney@caviumnetworks.com> <20110223174120.GG14597@angua.secretlab.ca> <4D6554A0.5010407@caviumnetworks.com> <20110223185134.GN14597@angua.secretlab.ca>
In-Reply-To: <20110223185134.GN14597@angua.secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 23 Feb 2011 19:20:09.0533 (UTC) FILETIME=[AF9D4ED0:01CBD38E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/23/2011 10:51 AM, Grant Likely wrote:
> On Wed, Feb 23, 2011 at 10:40:32AM -0800, David Daney wrote:
>> On 02/23/2011 09:41 AM, Grant Likely wrote:
>>> On Tue, Feb 22, 2011 at 12:57:50PM -0800, David Daney wrote:
>>>> Signed-off-by: David Daney<ddaney@caviumnetworks.com>
>>>> ---
>>>>   arch/mips/Kconfig                         |    2 +
>>>>   arch/mips/cavium-octeon/octeon-platform.c |  280 +++++++++++++++++++++++++++++
>>>>   arch/mips/cavium-octeon/setup.c           |   17 ++
>>>>   3 files changed, 299 insertions(+), 0 deletions(-)
>>>
>>> I've got an odd feeling of foreboding about this patch.  It makes me
>>> nervous, but I can't articulate why yet.  Gut-wise I'd rather see the
>>> device tree pruned/fixed up before it gets unflattened,
>>
>> I chose to work on the unflattened form because there were already
>> functions to do it.  I didn't see anything that would make
>> manipulating the flattened form easy.
>>
>> I agree that working on the unflattened form would be best.  At a
>> minium the /proc/device-tree structure would better reflect reality.
>>
>> What do you think about adding some helper functions to
>> drivers/of/fdt.c for the manipulation of the flattened form?
>
> It would probably be easier/safer to link libfdt into the kernel
> proper.  It's already used in the powerpc bootwrapper, and there has
> been talk about replacing some of fdt.c with libfdt.  See
> scripts/dtc/libfdt
>

I will take a look at that approach.

>>
>>> or for the
>>> kernel to have a separate .dtb linked in for each legacy platform.
>>
>> I think there are too many variants to make this viable.
>
> Out of curiosity, how many variants?
>

I don't know exactly, but for the sake of argument let's say at least 
twenty we support in-house.  That is not counting close to 100 customer 
boards.  Some of these boards have modular I/O connections (SPI-4.2 vs. 
XAIU vs. 4xSGMII, etc. across several different ports.), so the hardware 
configuration may be different each time they are powered on.

The existing legacy code handles these, so using it to configure the 
Device Tree has a certain appeal.  I would hope that moving forward a 
correct device tree is obtained from the bootloader, but for existing 
boards...

> btw, did you know about the dtc '/include/' functionality?  It is
> possible to set up .dts include files that represent a SoC and can be
> modified by the .dts files that include them.  See
> arch/powerpc/boot/dts/*5200*.dts

Yes.

Thanks,
David Daney
