Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756298Ab1JTJiI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 05:38:08 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:57477 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755119Ab1JTJiG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 05:38:06 -0400
From: qemulist@gmail.com
Date: Thu, 20 Oct 2011 17:37:30 +0800
To: Gong Chen <clumsycg@gmail.com>
Cc: pingfank@linux.vnet.ibm.com, aliguori@us.ibm.com, seabios@seabios.org,
        qemu-devel@nongnu.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, shaohua.li@intel.com,
        dave@linux.vnet.ibm.com, lenb@kernel.org
Subject: Re: [Qemu-devel] [PATCH 1/1] ACPI: Call ACPI remove handler when
 handling ACPI eject event
Message-ID: <20111020093730.GA18393@oc8440477808.ibm.com>
References: <1318992470-10195-1-git-send-email-pingfank@linux.vnet.ibm.com>
 <1318992470-10195-2-git-send-email-pingfank@linux.vnet.ibm.com>
 <CAMJ_OhjLvsZ3Vir3hVX2Ha+jA-ORX=3PBapY=B+aZP-ynqbB6A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMJ_OhjLvsZ3Vir3hVX2Ha+jA-ORX=3PBapY=B+aZP-ynqbB6A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 19, 2011 at 09:35:46PM +0800, Gong Chen wrote:
> On Wed, Oct 19, 2011 at 10:47 AM,  <pingfank@linux.vnet.ibm.com> wrote:
> > From: Liu Ping Fan <pingfank@linux.vnet.ibm.com>
> >
> > Call the remove handler for ACPI_NOTIFY_EJECT_REQUEST
> >
> > Signed-off-by: Liu Ping Fan <pingfank@linux.vnet.ibm.com>
> > ---
> >  drivers/acpi/bus.c      |    2 +-
> >  drivers/acpi/scan.c     |    2 +-
> >  include/acpi/acpi_bus.h |    2 ++
> >  3 files changed, 4 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/acpi/bus.c b/drivers/acpi/bus.c
> > index 437ddbf..d06ec6d 100644
> > --- a/drivers/acpi/bus.c
> > +++ b/drivers/acpi/bus.c
> > @@ -764,7 +764,7 @@ static void acpi_bus_notify(acpi_handle handle, u32 type, void *data)
> >                break;
> >
> >        case ACPI_NOTIFY_EJECT_REQUEST:
> > -               /* TBD */
> > +               acpi_os_hotplug_execute(acpi_bus_hot_remove_device, handle);
> >                break;
> >
> >        case ACPI_NOTIFY_DEVICE_CHECK_LIGHT:
> > diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
> > index 449c556..3b97b61 100644
> > --- a/drivers/acpi/scan.c
> > +++ b/drivers/acpi/scan.c
> > @@ -83,7 +83,7 @@ acpi_device_modalias_show(struct device *dev, struct device_attribute *attr, cha
> >  }
> >  static DEVICE_ATTR(modalias, 0444, acpi_device_modalias_show, NULL);
> >
> > -static void acpi_bus_hot_remove_device(void *context)
> > +void acpi_bus_hot_remove_device(void *context)
> >  {
> >        struct acpi_device *device;
> >        acpi_handle handle = context;
> > diff --git a/include/acpi/acpi_bus.h b/include/acpi/acpi_bus.h
> > index 6cd5b64..b19c09d 100644
> > --- a/include/acpi/acpi_bus.h
> > +++ b/include/acpi/acpi_bus.h
> > @@ -310,6 +310,8 @@ extern int unregister_acpi_notifier(struct notifier_block *);
> >
> >  extern int register_acpi_bus_notifier(struct notifier_block *nb);
> >  extern void unregister_acpi_bus_notifier(struct notifier_block *nb);
> > +extern void acpi_bus_hot_remove_device(void *context);
> > +
> >  /*
> >  * External Functions
> >  */
> > --
> > 1.7.4.4
> >
> 
> I preferred the patch from Shen before. Here is the link:
> https://lkml.org/lkml/2011/9/24/15
> As Bjorn said, "long-term goal to move the hotplug flow out of drivers and into
> the ACPI core". An arbitrary change in the global level just mess up the codes.
Got it, thanks. And so will this feature emerge in upstream soon?

Thanks and regards,
pingfan
