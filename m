Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932444Ab2IDQas (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 12:30:48 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:58099 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757086Ab2IDQaq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 12:30:46 -0400
MIME-Version: 1.0
In-Reply-To: <1346774117-2277-11-git-send-email-mjg@redhat.com>
References: <1346774117-2277-1-git-send-email-mjg@redhat.com>
	<1346774117-2277-11-git-send-email-mjg@redhat.com>
Date: Tue, 4 Sep 2012 10:30:46 -0600
Message-ID: <CAKocOONvci0Otb9wDgw6he48HkCvvhh+TMrv63AwgZLtmv4_Kg@mail.gmail.com>
Subject: Re: [PATCH 10/11] acpi: Ignore acpi_rsdp kernel parameter in a secure
 boot environment
From: Shuah Khan <shuahkhan@gmail.com>
To: Matthew Garrett <mjg@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-efi@vger.kernel.org, Josh Boyer <jwboyer@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 4, 2012 at 9:55 AM, Matthew Garrett <mjg@redhat.com> wrote:
> From: Josh Boyer <jwboyer@redhat.com>
>
> This option allows userspace to pass the RSDP address to the kernel.  This
> could potentially be used to circumvent the secure boot trust model.
> We ignore the setting if we don't have the CAP_SECURE_FIRMWARE capability.

Does this mean, acpi_rsdp is disabled on all current platforms that
don't support CAP_SECURE_FIRMWARE?

-- Shuah
>
> Signed-off-by: Josh Boyer <jwboyer@redhat.com>
> ---
>  drivers/acpi/osl.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
> index 9eaf708..50c94e4 100644
> --- a/drivers/acpi/osl.c
> +++ b/drivers/acpi/osl.c
> @@ -246,7 +246,7 @@ early_param("acpi_rsdp", setup_acpi_rsdp);
>  acpi_physical_address __init acpi_os_get_root_pointer(void)
>  {
>  #ifdef CONFIG_KEXEC
> -       if (acpi_rsdp)
> +       if (acpi_rsdp && capable(CAP_SECURE_FIRMWARE))
>                 return acpi_rsdp;
>  #endif
>
> --
> 1.7.11.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
