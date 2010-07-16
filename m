Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936123Ab0GPJId (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 05:08:33 -0400
Received: from adelie.canonical.com ([91.189.90.139]:53500 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936052Ab0GPJIc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 05:08:32 -0400
Message-ID: <4C40218A.4090806@canonical.com>
Date: Fri, 16 Jul 2010 10:08:26 +0100
From: Lee Jones <lee.jones@canonical.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.10) Gecko/20100527 Thunderbird/3.0.5
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] Stop ARM boards crashing when CUPS is loaded -	2.6.35-rc5
References: <4C3C72C6.4000005@canonical.com> <20100715130214.4c9303b2.akpm@linux-foundation.org> <20100715200618.GA6773@n2100.arm.linux.org.uk>
In-Reply-To: <20100715200618.GA6773@n2100.arm.linux.org.uk>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15/07/10 21:06, Russell King - ARM Linux wrote:
> On Thu, Jul 15, 2010 at 01:02:14PM -0700, Andrew Morton wrote:
>>> BugLink: http://bugs.launchpad.net/bugs/601226
>>>
>>> When CUPS loads, it tries to load several drivers that it may need.
>>> When one of these drivers, specifically parport_pc is loaded on ARM
>>> based systems, it causes a segmentation fault as the ISA addresses
>>> which are attempted are not writable on non-PC based architectures.
>>> This code prevents ISA addresses from being attempted except on x86.
>>>
>>
>> That sounds like a pretty serious problem.  But presumably it isn't -
>> otherwise it would have been fixed earlier!

Well it is a problem on OMAP based boards.

I've personally tested it on OMAP3 and OMAP4 based machines. 

Perhaps the memory is not reserved correctly.

>> So what actions are required to trigger this bug and why aren't others
>> seeing it?

Probably because most other chips either manage to reserve the memory 
successfully, or do not attempt to load the parport_pc driver, either as
a module or built-in.

All I have to do to recreate this bug is load the module or build in the
parport_pc driver.

> Note that we have machines which have ISA parallel ports, so it's not
> this simple.

Do they have ISA parallel ports, or do they just pretend to?

I found this scattered about:

/*
 * We don't actually have real ISA nor PCI buses, but there is so many
 * drivers out there that might just work if we fake them...
 */

Clearly parport_pc isn't one of them. :)

> Why not just avoid selecting and building parport_pc on these machines?

> I mean, the Beagleboard doesn't have PCI nor ISA, so why is parport_pc
> being built for production use?

I am happy to make a Kconfig change to disallow OMAP builds from building
the parport_pc driver. Do you think this would be more sensible?





