Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762049Ab2KAQUF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 12:20:05 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:38250 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755404Ab2KAQUB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 12:20:01 -0400
MIME-Version: 1.0
In-Reply-To: <14394066.j8A8VXQzU7@vostro.rjw.lan>
References: <1421417.rIOjExM5Pt@vostro.rjw.lan>
	<1992450.Ke1VSjeX8X@vostro.rjw.lan>
	<CAE9FiQURGWOUzHc5j4pHCfcXE9y4a3WaPCEg=RewUpA=u8pSAQ@mail.gmail.com>
	<14394066.j8A8VXQzU7@vostro.rjw.lan>
Date: Thu, 1 Nov 2012 09:19:59 -0700
X-Google-Sender-Auth: LHyvFyOUvns7DvAm2zIIYTIec3A
Message-ID: <CAE9FiQUXk9AcR87B8PyLoW3JJveZMd7SqB9pDmfA8F320SCLng@mail.gmail.com>
Subject: Re: [PATCH 5/5] ACPI: Add support for platform bus type
From: Yinghai Lu <yinghai@kernel.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Len Brown <lenb@kernel.org>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Lv Zheng <lv.zheng@intel.com>, Huang Ying <ying.huang@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86 list <x86@kernel.org>,
        Tony Luck <tony.luck@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 1, 2012 at 7:35 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> > @@ -1544,8 +1553,13 @@ static acpi_status acpi_bus_check_add(ac
>> >          */
>> >         device = NULL;
>> >         acpi_bus_get_device(handle, &device);
>> > -       if (ops->acpi_op_add && !device)
>> > +       if (ops->acpi_op_add && !device) {
>> >                 acpi_add_single_object(&device, handle, type, sta, ops);
>> > +               /* Is the device a known good platform device? */
>> > +               if (device
>> > +                   && !acpi_match_device_ids(device, acpi_platform_device_ids))
>> > +                       acpi_create_platform_device(device);
>> > +       }
>>
>> That is ugly! any reason for not using acpi_driver for them.
>
> Yes, a couple of reasons.  First off, there are existing platform drivers for
> these things already and there's no reason for creating a "glue" layer between
> those drivers and struct acpi_device objects.  Second, we're going to get rid
> of acpi_driver things entirely going forward (the existing ones will be replaced
> by platform drivers or included into the ACPI core).

that should be glue between acpi_device and platform_device.

how are you going to handle removing path ? aka when acpi_device get
trimed, how those platform get deleted?

>
>> there is not reason to treat those platform_device different from pci
>> root device and other pnp device.
>
> Well, I agree. :-)
>
> So those things you're talking about we'll be platform devices too in the
> future.
>
>> something like attached patch. .add of acpi_driver ops could call
>> acpi_create_platform_device.
>
> Been there, decided to do it differently this time.
>

So you are going to replace acpi_device/acpi_driver with
platform_device/platform_driver ?

Did you ever try to start to the work to see if it is doable? aka do
you have draft version to do that?

Yinghai
