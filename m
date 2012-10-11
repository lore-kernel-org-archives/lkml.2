Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932981Ab2JKP3h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 11:29:37 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:36309 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756791Ab2JKP3d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 11:29:33 -0400
Message-ID: <1349968938.23493.52.camel@misato.fc.hp.com>
Subject: Re: [PATCH v5 0/5] ACPI: hotplug messages improvement
From: Toshi Kani <toshi.kani@hp.com>
To: lenb@kernel.org
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org, joe@perches.com,
        bhelgaas@google.com, isimatu.yasuaki@jp.fujitsu.com,
        vijaymohan.pandarathil@hp.com, shaohua.li@intel.com
Date: Thu, 11 Oct 2012 09:22:18 -0600
In-Reply-To: <1349790175.23493.1.camel@misato.fc.hp.com>
References: <1346180581-12641-1-git-send-email-toshi.kani@hp.com>
	 <1349790175.23493.1.camel@misato.fc.hp.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Len,

Can you please review this patchset?

Thanks,
-Toshi

On Tue, 2012-10-09 at 07:42 -0600, Toshi Kani wrote:
> Hi Len,
> 
> Can you please review this patch?  Please let me know if there is
> anything I need to do for 3.7.
> 
> Thanks,
> -Toshi
> 
> 
> On Tue, 2012-08-28 at 13:02 -0600, Toshi Kani wrote:
> > This patchset improves logging messages for ACPI CPU, Memory, 
> > Container and Dock hotplug notify handlers.  The patchset 
> > introduces a set of new macro interfaces, acpi_pr_<level>(),
> > and uses them to update the notify handlers.  acpi_pr_<level>()
> > appends "ACPI" prefix and ACPI object path to the messages,
> > which has similar usage model as dev_<level>().  This improves
> > diagnosis of hotplug operations since an error message in 
> > a log file now identifies an object that caused an issue.
> > 
> > v5:
> >  - Added update for ACPI Dock hotplug error messages.
> >  - Added error status / ID info to the messages where needed.
> >  - Rebased on 3.6-rc3.
> > 
> > v4:
> >  - Changed to use dev_<level>() where it is appropriate.
> > 
> > v3:
> >  - Changed acpi_pr_debug() to NOP when !DEBUG and !DYNAMIC_DEBUG.
> >    DYNAMIC_DEBUG will be supported later when necessary.
> >  - Added const to a path variable in acpi_printk().
> >  - Added more descriptions to the change log of patch 1/4.
> > 
> > v2:
> >  - Set buffer.pointer to NULL in acpi_printk().
> >  - Added acpi_pr_debug().
> > 
> > ---
> > This patchset applies on top of the patch below.
> > 
> > [PATCH v2] ACPI: Add ACPI CPU hot-remove support
> > https://lkml.org/lkml/2012/8/24/419
> > 
> > ---
> > Toshi Kani (5):
> >  ACPI: Add acpi_pr_<level>() interfaces
> >  ACPI: Update CPU hotplug error messages
> >  ACPI: Update Memory hotplug error messages
> >  ACPI: Update Container hotplug error messages
> >  ACPI: Update Dock hotplug error messages
> > 
> > ---
> >  drivers/acpi/acpi_memhotplug.c  |   25 +++++++++++++------------
> >  drivers/acpi/container.c        |   10 ++--------
> >  drivers/acpi/dock.c             |   29 +++++++++++++----------------
> >  drivers/acpi/processor_driver.c |   38 +++++++++++++++++++++++---------------
> >  drivers/acpi/utils.c            |   34 ++++++++++++++++++++++++++++++++++
> >  include/acpi/acpi_bus.h         |   31 +++++++++++++++++++++++++++++++
> >  6 files changed, 116 insertions(+), 51 deletions(-)
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> > 
> > 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


