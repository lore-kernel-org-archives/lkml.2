Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754171Ab1I1T21 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 15:28:27 -0400
Received: from smtp-out.google.com ([216.239.44.51]:29397 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753665Ab1I1T2Y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 15:28:24 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:from:date:
	message-id:subject:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=Xusifu6EXck539KCzka6UYpZlMkeFBc5FeZbm4+MK+WIOITJk26Vbwc5FEj+K3aGL
	5EewoeCfSf9j8Grrsjx6A==
MIME-Version: 1.0
In-Reply-To: <201109280001.28857.rjw@sisk.pl>
References: <201109280001.28857.rjw@sisk.pl>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 28 Sep 2011 13:27:58 -0600
Message-ID: <CAErSpo4CpEWaKkh280Kb_nNSVWfYKGZ06HQOrpLar=T40TyDZQ@mail.gmail.com>
Subject: Re: [PATCH] PCI / PM: Remove unnecessary error variable from acpi_dev_run_wake()
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        linux-pci@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 27, 2011 at 4:01 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
>
> The error variable in acpi_dev_run_wake() is not really used, so
> remove it.
>
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> ---
>  drivers/pci/pci-acpi.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> Index: linux/drivers/pci/pci-acpi.c
> ===================================================================
> --- linux.orig/drivers/pci/pci-acpi.c
> +++ linux/drivers/pci/pci-acpi.c
> @@ -282,7 +282,6 @@ static int acpi_dev_run_wake(struct devi
>  {
>        struct acpi_device *dev;
>        acpi_handle handle;
> -       int error = -ENODEV;
>
>        if (!device_run_wake(phys_dev))
>                return -EINVAL;
> @@ -302,7 +301,7 @@ static int acpi_dev_run_wake(struct devi
>                acpi_disable_wakeup_device_power(dev);
>        }
>
> -       return error;
> +       return 0;
>  }
>
>  static void acpi_pci_propagate_run_wake(struct pci_bus *bus, bool enable)

This looks like the right thing to do, but the current changelog
suggests that we're just removing unused code.

But in fact, we'll now return 0 (success) when we used to return
-ENODEV, so the behavior of the callers will change (probably fixing
some bugs).  Do you want to mention that in the changelog as well?

I'm assuming this is for the 3.2 merge window, since it doesn't look
like a regression fix.

Bjorn
