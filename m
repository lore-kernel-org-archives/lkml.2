Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751813Ab0KYJLI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 04:11:08 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:49450 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374Ab0KYJLH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 04:11:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:date:message-id:subject:from:to:cc
         :content-type:content-transfer-encoding;
        b=DvFm+21f7BzoOpO83arPqK6a1dcJyCPKATWrjgmRcsWaPb009hQyYn8MKoReBYlNnW
         71Yu/Zht3XLNPcXPDwbfJd7I0a9GZynQREptq4Tsd2s0pCgA5bA5NwakkDO4CwIx0ZNq
         VmEzDW5MTnzL2QKwJdz3c8wRNAuB6WhfFwX4g=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
Date: Thu, 25 Nov 2010 10:11:06 +0100
Message-ID: <AANLkTimahUpEL3cV6pFhkN8KqrphfVMSOw8xAN2=9jPy@mail.gmail.com>
Subject: Re: [PATCH 0/13] ACPI / PM: Rework power resources management
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael,

I applied your patch-set against linux-next (next-20101124) with
backlight-type patches from Matthew.

# grep "error:" build_linux-next_next20101124.dileks.2.log
/home/sd/src/linux-2.6/linux-2.6.37-rc3/debian/build/source_i386_none/drivers/platform/x86/fujitsu-laptop.c:692:
error: implicit declaration of function ‘acpi_bus_get_power’

Looking into the source:

# grep acpi_bus_get_power -r
/home/sd/src/linux-2.6/linux-2.6.37-rc3/debian/build/source_i386_none/drivers/platform/x86/
/home/sd/src/linux-2.6/linux-2.6.37-rc3/debian/build/source_i386_none/drivers/platform/x86/fujitsu-laptop.c:
   result = acpi_bus_get_power(fujitsu->acpi_handle, &state);
/home/sd/src/linux-2.6/linux-2.6.37-rc3/debian/build/source_i386_none/drivers/platform/x86/fujitsu-laptop.c:
   result = acpi_bus_get_power(fujitsu_hotkey->acpi_handle, &state);

Checking the acpi tree:

# grep "acpi_bus_get_power(" -r
/home/sd/src/linux-2.6/linux-2.6.37-rc3/debian/build/source_i386_none/drivers/acpi/
/home/sd/src/linux-2.6/linux-2.6.37-rc3/debian/build/source_i386_none/drivers/acpi/bus.c:static
int __acpi_bus_get_power(struct acpi_device *device, int *state)
/home/sd/src/linux-2.6/linux-2.6.37-rc3/debian/build/source_i386_none/drivers/acpi/bus.c:
      result = __acpi_bus_get_power(device, &state);
/home/sd/src/linux-2.6/linux-2.6.37-rc3/debian/build/source_i386_none/drivers/acpi/bus.c:
      result = __acpi_bus_get_power(device, &state);

Just wanna let you know.

Kind Regards,
- Sedat -
