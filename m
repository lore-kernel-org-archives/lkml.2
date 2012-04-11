Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932957Ab2DKSwB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 14:52:01 -0400
Received: from g6t0187.atlanta.hp.com ([15.193.32.64]:44857 "EHLO
	g6t0187.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932889Ab2DKSv7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 14:51:59 -0400
Message-ID: <1334170247.20190.34.camel@misato.fc.hp.com>
Subject: Re: [PATCH 0/5] ACPI: Add _OST support for ACPI hotplug
From: Toshi Kani <toshi.kani@hp.com>
To: shuahkhan@gmail.com
Cc: lenb@kernel.org, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 11 Apr 2012 12:50:47 -0600
In-Reply-To: <1334161991.2226.18.camel@lorien2>
References: <1334096510-17319-1-git-send-email-toshi.kani@hp.com>
	 <1334161991.2226.18.camel@lorien2>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-04-11 at 10:33 -0600, Shuah Khan wrote:
> On Tue, 2012-04-10 at 16:21 -0600, Toshi Kani wrote:
> > This series of patches supports ACPI _OST (OSPM Status Indication)
> > method for ACPI-based CPU and memory hotplug operations.  After
> > ACPI-based hotplug operation completed, OSPM calls _OST to convey
> > the completion status to ACPI firmware.  If _OST is not present,
> > this change has no effect on the platform.
> > 
> > The _OST definition can be found in section 6.3.5 of ACPI 5.0 spec.
> > The HPPF spec below also describes hotplug flows with _OST.
> > 
> >   DIG64 Hot-Plug & Partitioning Flow (HPPF) Specification R1.0
> >   http://www.dig64.org/home/DIG64_HPPF_R1_0.pdf
> > 
> > The change was tested by overriding DSDT with fake _OST methods.
> 
> Could you please elaborate what it means by fake _OST method? I am
> assuming based on the above that this patch set was never tested on real
> hardware that has support for _OST method? Is that correct? If so why
> not wait until you have the opportunity to test it on real hardware
> before sending the patch?

Hi Shuah,

The fake _OST methods print arguments to verify successful execution of
the methods.  Since the purpose of _OST is firmware-internal
communication, there is no difference in testing on real firmware from
the OS perspective.  Overriding DSDT with fake ACPI methods is a
well-established and widely used testing method as well.

Pre-enablement of new features will benefit us because:

 1. There is a timeline gap between support in the upstream kernel and
distribution kernels.  Also, a new platform often needs to support older
stable kernels as well.

 2. Pre-enablement in the OS allows platform vendors to design new
platforms that utilize the new feature.

Thanks,
-Toshi


> -- Shuah
> > 
> > ---
> > Toshi Kani (4):
> >  ACPI: Set hotplug _OST support bit to _OSC
> >  ACPI: Add acpi_evaluate_ost() for calling _OST
> >  ACPI: Add _OST support for ACPI CPU hotplug
> >  ACPI: Add _OST support for ACPI memory hotplug
> > 
> >  drivers/acpi/acpi_memhotplug.c  |   43 +++++++++++++++++++++++++++++----------
> >  drivers/acpi/bus.c              |    5 ++++
> >  drivers/acpi/processor_driver.c |   28 ++++++++++++++++++-------
> >  drivers/acpi/utils.c            |   34 ++++++++++++++++++++++++++++++
> >  include/acpi/acpi_bus.h         |    3 ++
> >  include/linux/acpi.h            |   26 ++++++++++++++++++++++-
> >  6 files changed, 119 insertions(+), 20 deletions(-)
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> > 
> 
> 


