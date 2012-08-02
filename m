Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754056Ab2HBQcd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 12:32:33 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:38404 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754008Ab2HBQc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 12:32:29 -0400
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Date: Thu, 02 Aug 2012 18:32:25 +0200
From: "Witold Szczeponik" <Witold.Szczeponik@gmx.net>
Message-ID: <20120802163225.6330@gmx.net>
MIME-Version: 1.0
Subject: Re: [PATCH V3 0/3] PNP: Allow PNP resources to be disabled (interface)
To: lenb@kernel.org, bhelgaas@google.com
X-Authenticated: #787645
X-Flags: 0001
X-Mailer: WWW-Mail 6100 (Global Message Exchange)
X-Priority: 3
X-Provags-ID: V01U2FsdGVkX1+YYZtPDNeYKR7jUC0AlNdI9FXRYu4iuA17GO4wp5
 bAX1dnIhjPp0ifGfSqCGohv6idgwllbmR+3g== 
X-GMX-UID: zs5ocB1jeSEqW9xnZ3Qh+MV+IGRvb0DU
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Len and Bjorn, 

is there anything that needs to be done in order for the patch series
to be included in either 3.6 or 3.7?  Except for the (viable) question
as to whether or not a sysfs interface should accept complex inputs
(as it currently does and which is not introduced by this patch series), 
there have been no comments since March, when I made some changes due 
to Bjorn's well made observations. 

The patches extend Linux's PNP capabilities and are required for some
hardware, like the IBM ThinkPad 600E (and similar machines). 

All other users of the ABI should not see any regressions (the ABI
stays the same).  

--- Witold


> Hello everybody, 
> 
> this simple patch series continues the work begun in commit 
> 18fd470a48396c8795ba7256c5973e92ffa25cb3 where ACPI PNP resource templates
> with empty/disabled resources are handled.  
> 
> The aim of this patch series is to allow to set resources as "disabled"
> using 
> the "/sys/bus/pnp/devices/*/resources" interface.  Such "disabled"
> resources 
> are needed by some vintage IBM ThinkPads like the 600E where some devices
> need 
> to have their IRQs disabled in order to support all the devices the 600E
> has. 
> 
> To better understand the motivation, let's look at an excerpt from the
> 600E's 
> DSDT:
> 
>     Name (PLPT, ResourceTemplate ()
>     {
>         StartDependentFnNoPri ()
>         {
>             IO (Decode16, 0x03BC, 0x03BC, 0x01, 0x04)
>             IRQNoFlags () {7}
>         }
>         /* Some entries deleted */
>         StartDependentFnNoPri ()
>         {
>             IO (Decode16, 0x03BC, 0x03BC, 0x01, 0x04)
>             IRQNoFlags () {}
>         }
>         EndDependentFn ()
>     })
> 
> As one can see, the IRQ line for the last option is empty/disabled.  Also,
> both 
> options share the same priority, meaning they are equal alternatives.  In
> order 
> to be able to use the IRQ 7 for some other device, it is necessary to
> select 
> the second option, which can be done with the patch series applied.
> 
> To this end, some preparatory work is done, simplifying the code, and
> fixing a
> potential issue when explicitely assigning resources. 
> 
> Here is a brief description of these patches. 
> 
> [1/3] - Factor out common some code
> [2/3] - Perform the actual setting
> [3/3] - Handle IORESOURCE_BITS in resource allocation
> 
> The patches are applied against Linux 3.5.x. 
> 
> Comments are, as always, welcome.  If the patches should be sent to
> someone
> else, please let me know. 
> 
> 
> --- Witold
> 
> 
> Changes from previous versions:
> 
> V3 -> V2: Added Bjorn Helgaas as "Reviewed by"
>           No changes in the code itself
>           Based on Linux 3.5.x
> 
> V1 -> V2: Split [V1 2/3] into [V2 2/3] and [V2 3/3]
>           Removed [V1 3/3], will be submitted separately
>           Wrote more comments in response to the previous version
>           Sent to a broader audience
>           (https://lkml.org/lkml/2012/4/11/442)
> 
> V1:       Initial version 
>           (https://lkml.org/lkml/2012/3/20/358)

