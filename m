Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752632Ab2GZTYJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 15:24:09 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:52541 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752142Ab2GZTYD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 15:24:03 -0400
MIME-Version: 1.0
In-Reply-To: <1343257978-7085-5-git-send-email-toshi.kani@hp.com>
References: <1343257978-7085-1-git-send-email-toshi.kani@hp.com> <1343257978-7085-5-git-send-email-toshi.kani@hp.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 26 Jul 2012 13:23:41 -0600
Message-ID: <CAErSpo4Xqn9b21w1s0BLPwUJ4SeBPQjQOJ=Ar14iQKF1ZWnyHQ@mail.gmail.com>
Subject: Re: [PATCH v3 4/4] ACPI: Update Container hotplug messages
To: Toshi Kani <toshi.kani@hp.com>
Cc: lenb@kernel.org, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        joe@perches.com, isimatu.yasuaki@jp.fujitsu.com, liuj97@gmail.com,
        srivatsa.bhat@linux.vnet.ibm.com, prarit@redhat.com,
        imammedo@redhat.com, vijaymohan.pandarathil@hp.com
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 25, 2012 at 5:12 PM, Toshi Kani <toshi.kani@hp.com> wrote:
> Updated Container hotplug log messages with acpi_pr_<level>()
> and pr_<level>().
>
> Signed-off-by: Toshi Kani <toshi.kani@hp.com>
> ---
>  drivers/acpi/container.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/acpi/container.c b/drivers/acpi/container.c
> index 01a986d..643e962 100644
> --- a/drivers/acpi/container.c
> +++ b/drivers/acpi/container.c
> @@ -99,7 +99,7 @@ static int acpi_container_add(struct acpi_device *device)
>
>
>         if (!device) {
> -               printk(KERN_ERR PREFIX "device is NULL\n");
> +               pr_err(PREFIX "device is NULL\n");
>                 return -EINVAL;
>         }

This whole "if (!device)" check and the printk should be deleted.  If
the ACPI core calls .add() with a null acpi_device pointer, it's a
core bug, and it's better to take the oops and get the backtrace.

>
> @@ -164,7 +164,7 @@ static void container_notify_cb(acpi_handle handle, u32 type, void *context)
>         case ACPI_NOTIFY_BUS_CHECK:
>                 /* Fall through */
>         case ACPI_NOTIFY_DEVICE_CHECK:
> -               printk(KERN_WARNING "Container driver received %s event\n",
> +               pr_warn("Container driver received %s event\n",
>                        (type == ACPI_NOTIFY_BUS_CHECK) ?
>                        "ACPI_NOTIFY_BUS_CHECK" : "ACPI_NOTIFY_DEVICE_CHECK");

This message looks dubious.  Receiving this event should be a normal
occurrence, so the message might be useful for debugging, but doesn't
seem like a KERN_WARNING event for the user.

>
> @@ -185,7 +185,7 @@ static void container_notify_cb(acpi_handle handle, u32 type, void *context)
>
>                 result = container_device_add(&device, handle);
>                 if (result) {
> -                       pr_warn("Failed to add container\n");
> +                       acpi_pr_warn(handle, "Failed to add container\n");
>                         break;
>                 }
>
> --
> 1.7.7.6
>
