Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753452Ab2G2TQk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2012 15:16:40 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:33794 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753330Ab2G2TQj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2012 15:16:39 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Witold Szczeponik <Witold.Szczeponik@gmx.net>
Subject: Re: [PATCH V3 0/3] PNP: Allow PNP resources to be disabled (interface)
Date: Sun, 29 Jul 2012 21:22:28 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0+; KDE/4.6.0; x86_64; ; )
Cc: bhelgaas@google.com, lenb@kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org
References: <50158321.4030007@gmx.net>
In-Reply-To: <50158321.4030007@gmx.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201207292122.28249.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sunday, July 29, 2012, Witold Szczeponik wrote:
> Hello everybody, 
> 
> this simple patch series continues the work begun in commit 
> 18fd470a48396c8795ba7256c5973e92ffa25cb3 where ACPI PNP resource templates 
> with empty/disabled resources are handled.  
> 
> The aim of this patch series is to allow to set resources as "disabled" using 
> the "/sys/bus/pnp/devices/*/resources" interface.  Such "disabled" resources 
> are needed by some vintage IBM ThinkPads like the 600E where some devices need 
> to have their IRQs disabled in order to support all the devices the 600E has. 
> 
> To better understand the motivation, let's look at an excerpt from the 600E's 
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
> As one can see, the IRQ line for the last option is empty/disabled.  Also, both 
> options share the same priority, meaning they are equal alternatives.  In order 
> to be able to use the IRQ 7 for some other device, it is necessary to select 
> the second option, which can be done with the patch series applied.

Do I understand correctly that you want to disable those things through
sysfs?

Rafael
