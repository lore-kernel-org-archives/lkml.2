Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752230Ab0KYJly (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 04:41:54 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:43246 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752208Ab0KYJlw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 04:41:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=sRLUf6kEHDw7b4AsezeEeGTzwsz1EUW5DPtAKoJpzp37lgDgqzkMl9zelbQ16Z0taD
         NCkJuDuerE5sNszKJ9WyYihie/4oQEzReTsbC1F/1yxBJ51NMI3iJwXRYthZDyHtv4fp
         LyvtAcXU49NpVKMrWQtrxx/Rw36/KnbR94cPI=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <AANLkTimahUpEL3cV6pFhkN8KqrphfVMSOw8xAN2=9jPy@mail.gmail.com>
References: <AANLkTimahUpEL3cV6pFhkN8KqrphfVMSOw8xAN2=9jPy@mail.gmail.com>
Date: Thu, 25 Nov 2010 10:41:51 +0100
Message-ID: <AANLkTin4r6-No01A_KNr8aNuYpyWTvmuA3LTDRZ5Lag6@mail.gmail.com>
Subject: Re: [PATCH 0/13] ACPI / PM: Rework power resources management
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 25, 2010 at 10:11 AM, Sedat Dilek
<sedat.dilek@googlemail.com> wrote:
> Hi Rafael,
>
> I applied your patch-set against linux-next (next-20101124) with
> backlight-type patches from Matthew.
>
> # grep "error:" build_linux-next_next20101124.dileks.2.log
> /home/sd/src/linux-2.6/linux-2.6.37-rc3/debian/build/source_i386_none/drivers/platform/x86/fujitsu-laptop.c:692:
> error: implicit declaration of function ‘acpi_bus_get_power’
>
> Looking into the source:
>
> # grep acpi_bus_get_power -r
> /home/sd/src/linux-2.6/linux-2.6.37-rc3/debian/build/source_i386_none/drivers/platform/x86/
> /home/sd/src/linux-2.6/linux-2.6.37-rc3/debian/build/source_i386_none/drivers/platform/x86/fujitsu-laptop.c:
>   result = acpi_bus_get_power(fujitsu->acpi_handle, &state);
> /home/sd/src/linux-2.6/linux-2.6.37-rc3/debian/build/source_i386_none/drivers/platform/x86/fujitsu-laptop.c:
>   result = acpi_bus_get_power(fujitsu_hotkey->acpi_handle, &state);
>
> Checking the acpi tree:
>
> # grep "acpi_bus_get_power(" -r
> /home/sd/src/linux-2.6/linux-2.6.37-rc3/debian/build/source_i386_none/drivers/acpi/
> /home/sd/src/linux-2.6/linux-2.6.37-rc3/debian/build/source_i386_none/drivers/acpi/bus.c:static
> int __acpi_bus_get_power(struct acpi_device *device, int *state)
> /home/sd/src/linux-2.6/linux-2.6.37-rc3/debian/build/source_i386_none/drivers/acpi/bus.c:
>      result = __acpi_bus_get_power(device, &state);
> /home/sd/src/linux-2.6/linux-2.6.37-rc3/debian/build/source_i386_none/drivers/acpi/bus.c:
>      result = __acpi_bus_get_power(device, &state);
>
> Just wanna let you know.
>
> Kind Regards,
> - Sedat -
>

Guess this is conflicting with your patch
"12-13-ACPI-PM-Drop-acpi_bus_get_power.patch".

- Sedat -

P.S.: Note to myself, add the following snippet for testing purposes:

[ debian/config/i386/none/config.686 ]
...
##
## file: drivers/platform/x86/Kconfig
##
# CONFIG_FUJITSU_LAPTOP is not set
- EOT -
