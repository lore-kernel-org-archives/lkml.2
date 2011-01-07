Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753792Ab1AGAW4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 19:22:56 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:38124 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752671Ab1AGAWy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 19:22:54 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: David Brownell <david-b@pacbell.net>
Subject: Re: [linux-pm] [PATCH 10/11] ACPI: Drop device flag wake_capable
Date: Fri, 7 Jan 2011 01:22:12 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37+; KDE/4.4.4; x86_64; ; )
Cc: Len Brown <lenb@kernel.org>,
        "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
References: <511724.91814.qm@web180315.mail.gq1.yahoo.com>
In-Reply-To: <511724.91814.qm@web180315.mail.gq1.yahoo.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201101070122.12578.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, January 07, 2011, David Brownell wrote:
> 
> --- On Thu, 1/6/11, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> 
> 
> > 
> > The wake_capable ACPI device flag is not necessary, because
> > it is
> > only used in scan.c for recording the information
> 
> 
> Only  for ACPI, yes? Generically, it records data for any
> wake-capable dvice, and is not ACPI-specific...

You're wrong, sorry.  It _is_ ACPI-specific.

> My bias is that ACPI should  work the way other PM
> solutions/hardware work, not collect special cases
> unique to ACPI (kind of like this.) ...

So this patch is going into the right direction, isn't it?

>  that _PRW
> > is
> > present for the given device.  That information is
> > only used by
> > acpi_add_single_object() to decide whether or not to call
> > acpi_bus_get_wakeup_device_flags(), so the flag may be
> > dropped
> > if the _PRW check is moved to
> > acpi_bus_get_wakeup_device_flags().
> 
> Only if you presume ACPI ....

What do you mean _exactly_?  This flags is _not_ used anywhere outside of
drivers/acpi/scan.c, so what's the problem?

> I'm glad to see that generic-vs-ACPI duplication
> of flags vanishing; way back when I started to add
> wakeup support, I had to stop part way through ACPI
> in large part because wake didn't work well yet in the Linux PM
> framework, except for select non-ACPI HW.
> (Starting with a USB subset: OTG and hub port sleep and ewakeup); oh, also GPIO wake on some HW, e.g.
> or buttons, and switches like MMC/SD card detect. ISTR that stuff still wierds out a bit as it goes
> through Linux-ACPI.
> 
> Also, to the extent that the ACPI code was supposed
> to be generic and not Linux-specific, I thought Len
> or someone from Intel should drive such issues.

Again, please be more specific.

It appears you haven't been following the development in this area for years
and now you're making comments I can't really understand.  What's up, really?

Rafael
