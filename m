Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759911Ab2EISqg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 14:46:36 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:16040 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752964Ab2EISqf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 14:46:35 -0400
Message-ID: <1336589042.16730.170.camel@misato.fc.hp.com>
Subject: Re: [PATCH v2 0/7] ACPI: Add _OST support for ACPI hotplug
From: Toshi Kani <toshi.kani@hp.com>
To: shuahkhan@gmail.com
Cc: lenb@kernel.org, linux-acpi@vger.kernel.org, bhelgaas@google.com,
        linux-kernel@vger.kernel.org
Date: Wed, 09 May 2012 12:44:02 -0600
In-Reply-To: <1336585000.2498.23.camel@lorien2>
References: <1336507944-10219-1-git-send-email-toshi.kani@hp.com>
	 <1336585000.2498.23.camel@lorien2>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-09 at 11:36 -0600, Shuah Khan wrote:
> On Tue, 2012-05-08 at 14:12 -0600, Toshi Kani wrote:
> > This patchset supports ACPI OSPM Status Indication (_OST) method for
> > ACPI CPU/memory/container hotplug operations and sysfs eject. After
> > ACPI hotplug operation has completed, OSPM calls _OST to indicate the
> > status of the operation to the platform. If _OST is not present, this
> > patchset has no effect on the platform.
> > 
> > This _OST support can be enabled or disabled with a new config option
> > CONFIG_ACPI_HOTPLUG_OST. This option is disabled by default. When
> > this option is disabled, this patchset has no effect on the platform.
> > 
> > The _OST definition can be found in section 6.3.5 of ACPI 5.0 spec.
> > The HPPF spec below also describes hotplug flows with _OST.
> > 
> >   DIG64 Hot-Plug & Partitioning Flow (HPPF) Specification R1.0
> >   http://www.dig64.org/home/DIG64_HPPF_R1_0.pdf
> > 
> > The changes have been tested with simulated _OST methods.
> > 
> > v2:
> >  - Added CONFIG_ACPI_HOTPLUG_OST option. 
> >  - Added _OST support for container hotplug and sysfs eject.
> >  - Reordered patchset to enable _OST support bit of _OSC in the 
> >    last patch.
> > 
> > ---
> > Toshi Kani (7):
> >  ACPI: Add CONFIG_HOTPLUG_OST option
> >  ACPI: Add an interface to evaluate _OST
> >  ACPI: Add _OST support for sysfs eject
> >  ACPI: Add _OST support for ACPI CPU hotplug
> >  ACPI: Add _OST support for ACPI memory hotplug
> >  ACPI: Add _OST support for ACPI container hotplug
> >  ACPI: Set hotplug _OST support bit to _OSC
> > 
> 
> Did you look into implementing this maybe in a generic way by adding a
> new device_ops that adds the ability to return status back to firmware?
> It can be left null on systems that don't implement _OST. This way it
> might be cleaner and can extend to other means of returning status back
> to firmware if any.

As Bjorn pointed out in his review comments, if the OS indicates hotplug
_OST support to _OSC, it needs to evaluate _OST for any devices.
Therefore, we should not provide a way for each device to have different
ways of supporting _OST.  This patchset is designed to provide
consistent behavior among multiple devices.


> Adding _OST support the way it is done in this patch set is rather
> invasive and CONFIG_HOTPLUG_OST only helps disable just the evaluation
> of _OST method. Other code changes do get executed on all platforms.

This _OST config option, as it is defined, enables or disables _OST
support.  The _OST code changes are limited to the scope of hotplug
operation code paths, which can also be enabled / disabled with their
HOTPLUG config options.


Thanks,
-Toshi






