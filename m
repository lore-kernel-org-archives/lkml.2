Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757187Ab2IJR4M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 13:56:12 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38681 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757110Ab2IJR4K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 13:56:10 -0400
MIME-Version: 1.0
In-Reply-To: <20120713174216.GA10445@hp.com>
References: <20120713174216.GA10445@hp.com>
From: Mike Waychison <mikew@google.com>
Date: Mon, 10 Sep 2012 13:55:49 -0400
Message-ID: <CAGTjWtDyGrVuBXZzdDfbS961cRSQY7eZaEbb9E8HACk5-imiuQ@mail.gmail.com>
Subject: Re: [PATCH v2] Add missing attributes to EFI variable attribute print
 out from sysfs
To: Khalid Aziz <khalid.aziz@hp.com>, Greg Kroah-Hartman <gregkh@suse.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tony Luck <tony.luck@intel.com>, Matthew Garrett <mjg@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        "gong.chen@linux.intel.com" <gong.chen@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg,

Can you please pick this patch up in one of your trees?

Thanks!

Mike Waychison

On Fri, Jul 13, 2012 at 1:42 PM, Khalid Aziz <khalid.aziz@hp.com> wrote:
> Some of the EFI variable attributes are missing from print out from
> /sys/firmware/efi/vars/*/attributes. This patch adds those in. It also
> updates code to use pre-defined constants for masking current value
> of attributes.
>
> Signed-off-by: Khalid Aziz <khalid.aziz@hp.com>
> Cc: stable@vger.kernel.org
> ---
>  drivers/firmware/efivars.c |   17 ++++++++++++++---
>  1 file changed, 14 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
> index 47408e8..d10c987 100644
> --- a/drivers/firmware/efivars.c
> +++ b/drivers/firmware/efivars.c
> @@ -435,12 +435,23 @@ efivar_attr_read(struct efivar_entry *entry, char *buf)
>         if (status != EFI_SUCCESS)
>                 return -EIO;
>
> -       if (var->Attributes & 0x1)
> +       if (var->Attributes & EFI_VARIABLE_NON_VOLATILE)
>                 str += sprintf(str, "EFI_VARIABLE_NON_VOLATILE\n");
> -       if (var->Attributes & 0x2)
> +       if (var->Attributes & EFI_VARIABLE_BOOTSERVICE_ACCESS)
>                 str += sprintf(str, "EFI_VARIABLE_BOOTSERVICE_ACCESS\n");
> -       if (var->Attributes & 0x4)
> +       if (var->Attributes & EFI_VARIABLE_RUNTIME_ACCESS)
>                 str += sprintf(str, "EFI_VARIABLE_RUNTIME_ACCESS\n");
> +       if (var->Attributes & EFI_VARIABLE_HARDWARE_ERROR_RECORD)
> +               str += sprintf(str, "EFI_VARIABLE_HARDWARE_ERROR_RECORD\n");
> +       if (var->Attributes & EFI_VARIABLE_AUTHENTICATED_WRITE_ACCESS)
> +               str += sprintf(str,
> +                       "EFI_VARIABLE_AUTHENTICATED_WRITE_ACCESS\n");
> +       if (var->Attributes &
> +                       EFI_VARIABLE_TIME_BASED_AUTHENTICATED_WRITE_ACCESS)
> +               str += sprintf(str,
> +                       "EFI_VARIABLE_TIME_BASED_AUTHENTICATED_WRITE_ACCESS\n");
> +       if (var->Attributes & EFI_VARIABLE_APPEND_WRITE)
> +               str += sprintf(str, "EFI_VARIABLE_APPEND_WRITE\n");
>         return str - buf;
>  }
>
> --
> 1.7.9.5
>
> --
> Khalid Aziz
> khalid.aziz@hp.com
