Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932209Ab2GBCTK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 22:19:10 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:63036 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932089Ab2GBCTI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 22:19:08 -0400
MIME-Version: 1.0
In-Reply-To: <20120702121041.01a80802af13e2cf511fe0b6@canb.auug.org.au>
References: <20120702121041.01a80802af13e2cf511fe0b6@canb.auug.org.au>
Date: Mon, 2 Jul 2012 10:19:07 +0800
Message-ID: <CAC=cRTNf2tqvGqOKKekXnWbtFM8a0co1SjcTUjLd2ZOjm9+Atg@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the libata tree
From: huang ying <huang.ying.caritas@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Jeff Garzik <jeff@garzik.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Lin Ming <ming.m.lin@intel.com>,
        Huang Ying <ying.huang@intel.com>, Bjorn Helgaas <bhelgaas@google.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Stephen,

On Mon, Jul 2, 2012 at 10:10 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Jeff,
>
> After merging the libata tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
>
> drivers/ata/libata-acpi.c: In function 'ata_acpi_set_state':
> drivers/ata/libata-acpi.c:872:5: error: too few arguments to function 'acpi_pm_device_sleep_state'
> include/acpi/acpi_bus.h:418:5: note: declared here
>
> Caused by commit 3bd46600a7a7 ("libata-acpi: add ata port runtime D3Cold
> support") from the libata tree interacting with commit ee85f543710d
> ("ACPI/PM: specify lowest allowed state for device sleep state") from the
> pci tree.
>
> I added the following merge fix patch (and can carry it as necessary):
>
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Mon, 2 Jul 2012 12:07:25 +1000
> Subject: [PATCH] libata-acpi: fix up for acpi_pm_device_sleep_state API
>  change
>
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  drivers/ata/libata-acpi.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/ata/libata-acpi.c b/drivers/ata/libata-acpi.c
> index 4112eaa..a2b16c9 100644
> --- a/drivers/ata/libata-acpi.c
> +++ b/drivers/ata/libata-acpi.c
> @@ -869,7 +869,7 @@ void ata_acpi_set_state(struct ata_port *ap, pm_message_t state)
>
>                 if (state.event != PM_EVENT_ON) {
>                         acpi_state = acpi_pm_device_sleep_state(
> -                               &dev->sdev->sdev_gendev, NULL);
> +                               &dev->sdev->sdev_gendev, NULL, ACPI_STATE_D3);
>                         if (acpi_state > 0)
>                                 acpi_bus_set_power(handle, acpi_state);
>                         /* TBD: need to check if it's runtime pm request */

The fix is good for me.  Thanks!

Best Regards,
Huang Ying
