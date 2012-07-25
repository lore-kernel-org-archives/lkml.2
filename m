Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754091Ab2GYPgO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 11:36:14 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:28813 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918Ab2GYPgN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 11:36:13 -0400
Message-ID: <1343230282.3010.387.camel@misato.fc.hp.com>
Subject: RE: [PATCH v2 0/4] ACPI: hotplug messages improvement
From: Toshi Kani <toshi.kani@hp.com>
To: "Pandarathil, Vijaymohan R" <vijaymohan.pandarathil@hp.com>
Cc: "lenb@kernel.org" <lenb@kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "joe@perches.com" <joe@perches.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "isimatu.yasuaki@jp.fujitsu.com" <isimatu.yasuaki@jp.fujitsu.com>,
        "liuj97@gmail.com" <liuj97@gmail.com>,
        "srivatsa.bhat@linux.vnet.ibm.com" <srivatsa.bhat@linux.vnet.ibm.com>,
        "prarit@redhat.com" <prarit@redhat.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>
Date: Wed, 25 Jul 2012 09:31:22 -0600
In-Reply-To: <EC847C0FC42FF046B94E60B168774B173164314F@G9W0337.americas.hpqcorp.net>
References: <1342803256-17514-1-git-send-email-toshi.kani@hp.com>
	 <EC847C0FC42FF046B94E60B168774B173164314F@G9W0337.americas.hpqcorp.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-07-25 at 06:15 +0000, Pandarathil, Vijaymohan R wrote:
> Hi Toshi,
> 
> Tested your patches on a KVM setup. Since all your acpi_pr* macros
> are in the error path, I didn't see an easy way to trigger them.
> Instead added an acpi_pr_err() message in the success path and tested
> out vcpu addition/deletion sequence. No regressions seen in the
> functional tests and the ACPI err message comes out on the console
> and message buffer with a valid ACPI device path.
> 
> Vijay
> 
> Tested-by: Vijay Mohan Pandarathil<vijaymohan.pandarathil@hp.com>

Hi Vijay,

Thanks for the testing!  It sounds good to me and that's how I tested as
well, i.e. copied all messages to the normal path.  I will add your
Tested-by to patch 1/4 and 2/4.

-Toshi


> -----Original Message-----
> From: Kani, Toshimitsu 
> Sent: Friday, July 20, 2012 9:54 AM
> To: lenb@kernel.org; linux-acpi@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org; joe@perches.com; bhelgaas@google.com; isimatu.yasuaki@jp.fujitsu.com; liuj97@gmail.com; srivatsa.bhat@linux.vnet.ibm.com; prarit@redhat.com; imammedo@redhat.com; Pandarathil, Vijaymohan R; Kani, Toshimitsu
> Subject: [PATCH v2 0/4] ACPI: hotplug messages improvement
> 
> This patchset improves logging messages for ACPI CPU, Memory, and
> Container hotplug notify handlers.  The patchset introduces a set of
> new macro interfaces, acpi_pr_<level>(), and updates the notify
> handlers to use them.  acpi_pr_<level>() appends "ACPI" prefix and
> ACPI object path to the messages.  This improves diagnostics in
> hotplug operations since it identifies an object that caused an
> issue in a log file.
> 
> v2:
>  - Set buffer.pointer to NULL in acpi_printk().
>  - Added acpi_pr_debug().
> 
> ---
> This patchset applies on top of the patch below.
> 
> [PATCH] ACPI: Add ACPI CPU hot-remove support
> http://marc.info/?l=linux-acpi&m=134098193327362&w=2
> 
> ---
> Toshi Kani (4):
>  ACPI: Add acpi_pr_<level>() interfaces
>  ACPI: Update CPU hotplug messages
>  ACPI: Update Memory hotplug messages
>  ACPI: Update Container hotplug messages
> 
> ---
>  drivers/acpi/acpi_memhotplug.c  |   24 ++++++++++++------------
>  drivers/acpi/container.c        |    6 +++---
>  drivers/acpi/processor_driver.c |   36 +++++++++++++++++++++---------------
>  drivers/acpi/utils.c            |   34 ++++++++++++++++++++++++++++++++++
>  include/acpi/acpi_bus.h         |   20 ++++++++++++++++++++
>  5 files changed, 90 insertions(+), 30 deletions(-)


