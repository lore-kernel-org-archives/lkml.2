Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750798Ab1LHFBt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 00:01:49 -0500
Received: from mail-ww0-f42.google.com ([74.125.82.42]:37330 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750739Ab1LHFBq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 00:01:46 -0500
MIME-Version: 1.0
In-Reply-To: <1323297487.4edfeacfc49ff@imp.free.fr>
References: <1323297487.4edfeacfc49ff@imp.free.fr>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 7 Dec 2011 22:01:24 -0700
Message-ID: <CAErSpo7Dcxn7tsecDUXe6AQeRAchsU9tQjL7=-WPpPmDj2OUfw@mail.gmail.com>
Subject: Re: ACPI "_PDC" - acpi_processor_set_pdc()- execution regression - Linux-3.x
To: wallak@free.fr
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        Lin Ming <ming.m.lin@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[+cc linux-acpi and Lin Ming]

On Wed, Dec 7, 2011 at 3:38 PM,  <wallak@free.fr> wrote:
> We have a regression on the ACPI stack of the last linux kernel line 3.x (3.1.4,
> 3.2-rc4...). The ACPI "_PDC" chunk is not executed on some computers (e.g. Dell
> X300; the function acpi_processor_set_pdc() is not called). This issue yield to
> an uninitialized state of some ACPI variables.
>
> A patch is available below. This patch come back to the previous linux behavior,
> and works fine.
>
> Best Regards,
> Wallak.
>
> --- linux-3.1.4-mdf/drivers/acpi/processor_core.c.orig  2011-12-07
> 23:12:57.000000000 +0100
> +++ linux-3.1.4-mdf/drivers/acpi/processor_core.c       2011-12-07
> 23:13:39.000000000 +0100
> @@ -223,8 +223,8 @@
>        type = (acpi_type == ACPI_TYPE_DEVICE) ? 1 : 0;
>        cpuid = acpi_get_cpuid(handle, type, acpi_id);
>
> -       if (cpuid == -1)
> -               return false;
> +       if ((cpuid == -1) && (num_possible_cpus() > 1))
> +               return false;
>
>        return true;
>  }
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
