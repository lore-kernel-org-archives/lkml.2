Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030286Ab2GYPbY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 11:31:24 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:13763 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030232Ab2GYPbV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 11:31:21 -0400
Message-ID: <1343229989.3010.383.camel@misato.fc.hp.com>
Subject: Re: [PATCH 0/4] ACPI: hotplug messages improvement
From: Toshi Kani <toshi.kani@hp.com>
To: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: lenb@kernel.org, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        bhelgaas@google.com, liuj97@gmail.com,
        srivatsa.bhat@linux.vnet.ibm.com, prarit@redhat.com,
        imammedo@redhat.com, vijaymohan.pandarathil@hp.com
Date: Wed, 25 Jul 2012 09:26:29 -0600
In-Reply-To: <500F6BE3.8060508@jp.fujitsu.com>
References: <1342644027-19559-1-git-send-email-toshi.kani@hp.com>
	 <500F6BE3.8060508@jp.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-07-25 at 12:45 +0900, Yasuaki Ishimatsu wrote:
> Hi Toshi,
> 
> 2012/07/19 5:40, Toshi Kani wrote:
> > This patchset improves logging messages for ACPI CPU, Memory, and
> > Container hotplug notify handlers.  The patchset introduces a set of
> > new macro interfaces, acpi_pr_<level>(), and updates the notify
> > handlers to use them.  acpi_pr_<level>() appends "ACPI" prefix and
> > ACPI object path to the messages.  This improves diagnostics in
> > hotplug operations since it identifies an object that caused an
> > issue in a log file.
> >
> 
> The log message looks good to me.

Hi Yasuaki,

Thanks for reviewing!

> But I could not understand when to use it instead of pr_{warn, info, ...}
> or ACPI_{WARNING, INFO, ...}. Do you have the policy?

acpi_pr_<level>() is used when ACPI device path is used to identify an
ACPI object for the message, such as error message to the object.  The
usage model is similar to dev_<level>(), which appends device object to
the message.  acpi_pr_<level>() is intended for ACPI drivers, and can be
used when device object is not created / valid, such as the case for
ACPI hotplug handlers.

pr_<level>() is the regular printk() interfaces with message level, and
continues to be used when ACPI device path does not have to be appended
to the message.  I expect non-error messages (such as boot-up messages)
continue to use pr_<level>().

ACPI_[WARNING|INFO|ERROR]() are ACPICA internal interfaces, and are not
intended for ACPI drivers.

Additionally, ACPI drivers can also use dev_<level>() when device object
is valid.  You find such examples in patch 2/4.

I will add more descriptions to the patchset.


> > ---
> > This patchset applies on top of the patch below.
> > 
> > [PATCH] ACPI: Add ACPI CPU hot-remove support
> > http://marc.info/?l=linux-acpi&m=134098193327362&w=2
> > 
> > ---
> > Toshi Kani (4):
> >   ACPI: Add acpi_pr_<level>() interfaces
> >   ACPI: Update CPU hotplug messages
> >   ACPI: Update Memory hotplug messages
> >   ACPI: Update Container hotplug messages
> 
> I think you need update other component, which are driver/acpi/{acpi_pad.c,
> battery.c, button.c}. Do you have the plan to update them?

I won't be ready to include them in this round, but will look at them
and change them later as necessary.  I need to make sure that I can test
these drivers when making such changes.

Thanks,
-Toshi


> 
> Thanks,
> Yasuaki Ishimatsu
> 
> > ---
> >   drivers/acpi/acpi_memhotplug.c  |   24 ++++++++++++------------
> >   drivers/acpi/container.c        |    6 +++---
> >   drivers/acpi/processor_driver.c |   36 +++++++++++++++++++++---------------
> >   drivers/acpi/utils.c            |   32 ++++++++++++++++++++++++++++++++
> >   include/acpi/acpi_bus.h         |   18 ++++++++++++++++++
> >   5 files changed, 86 insertions(+), 30 deletions(-)
> > 
> 
> 


