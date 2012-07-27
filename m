Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753202Ab2G0C5f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 22:57:35 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:13240 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752774Ab2G0C5d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 22:57:33 -0400
Message-ID: <1343357562.3010.533.camel@misato.fc.hp.com>
Subject: Re: [PATCH v3 4/4] ACPI: Update Container hotplug messages
From: Toshi Kani <toshi.kani@hp.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: lenb@kernel.org, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        joe@perches.com, isimatu.yasuaki@jp.fujitsu.com, liuj97@gmail.com,
        srivatsa.bhat@linux.vnet.ibm.com, prarit@redhat.com,
        imammedo@redhat.com, vijaymohan.pandarathil@hp.com
Date: Thu, 26 Jul 2012 20:52:42 -0600
In-Reply-To: <CAErSpo4Xqn9b21w1s0BLPwUJ4SeBPQjQOJ=Ar14iQKF1ZWnyHQ@mail.gmail.com>
References: <1343257978-7085-1-git-send-email-toshi.kani@hp.com>
	 <1343257978-7085-5-git-send-email-toshi.kani@hp.com>
	 <CAErSpo4Xqn9b21w1s0BLPwUJ4SeBPQjQOJ=Ar14iQKF1ZWnyHQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-07-26 at 13:23 -0600, Bjorn Helgaas wrote:
> On Wed, Jul 25, 2012 at 5:12 PM, Toshi Kani <toshi.kani@hp.com> wrote:
> > Updated Container hotplug log messages with acpi_pr_<level>()
> > and pr_<level>().
> >
> > Signed-off-by: Toshi Kani <toshi.kani@hp.com>
> > ---
> >  drivers/acpi/container.c |    6 +++---
> >  1 files changed, 3 insertions(+), 3 deletions(-)
> >
> > diff --git a/drivers/acpi/container.c b/drivers/acpi/container.c
> > index 01a986d..643e962 100644
> > --- a/drivers/acpi/container.c
> > +++ b/drivers/acpi/container.c
> > @@ -99,7 +99,7 @@ static int acpi_container_add(struct acpi_device *device)
> >
> >
> >         if (!device) {
> > -               printk(KERN_ERR PREFIX "device is NULL\n");
> > +               pr_err(PREFIX "device is NULL\n");
> >                 return -EINVAL;
> >         }
> 
> This whole "if (!device)" check and the printk should be deleted.  If
> the ACPI core calls .add() with a null acpi_device pointer, it's a
> core bug, and it's better to take the oops and get the backtrace.

Agreed. Delete the check.

> >
> > @@ -164,7 +164,7 @@ static void container_notify_cb(acpi_handle handle, u32 type, void *context)
> >         case ACPI_NOTIFY_BUS_CHECK:
> >                 /* Fall through */
> >         case ACPI_NOTIFY_DEVICE_CHECK:
> > -               printk(KERN_WARNING "Container driver received %s event\n",
> > +               pr_warn("Container driver received %s event\n",
> >                        (type == ACPI_NOTIFY_BUS_CHECK) ?
> >                        "ACPI_NOTIFY_BUS_CHECK" : "ACPI_NOTIFY_DEVICE_CHECK");
> 
> This message looks dubious.  Receiving this event should be a normal
> occurrence, so the message might be useful for debugging, but doesn't
> seem like a KERN_WARNING event for the user.

Changed to pr_debug() for now.


Thanks!
-Toshi


> >
> > @@ -185,7 +185,7 @@ static void container_notify_cb(acpi_handle handle, u32 type, void *context)
> >
> >                 result = container_device_add(&device, handle);
> >                 if (result) {
> > -                       pr_warn("Failed to add container\n");
> > +                       acpi_pr_warn(handle, "Failed to add container\n");
> >                         break;
> >                 }
> >
> > --
> > 1.7.7.6
> >


