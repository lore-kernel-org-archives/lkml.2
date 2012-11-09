Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753957Ab2KIPpl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 10:45:41 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:39468 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753842Ab2KIPpj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 10:45:39 -0500
MIME-Version: 1.0
In-Reply-To: <CAErSpo7WT21rZ10vx9A4d8VtVaJB7FLeJqVAxKmZrZDy01FPZQ@mail.gmail.com>
References: <1351928793-14375-1-git-send-email-mika.westerberg@linux.intel.com>
 <3455360.Z6cZSC3BtR@vostro.rjw.lan> <CAErSpo5xEO4M_Fb0dJ6w7Qxck-0RcKKwQjKj1QZgFxhof7X5Rw@mail.gmail.com>
 <1523215.Pon1eKPQDb@vostro.rjw.lan> <20121107095608.GX24532@intel.com>
 <CAErSpo5My6+ypp9zsxR8vh8k1px0otOWfAcacWaLNs2xjsc7UA@mail.gmail.com>
 <20121108200445.GC16012@intel.com> <CAErSpo7WT21rZ10vx9A4d8VtVaJB7FLeJqVAxKmZrZDy01FPZQ@mail.gmail.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Fri, 9 Nov 2012 15:45:18 +0000
X-Google-Sender-Auth: YStmvFU4C0TTBMFXMKaT-O0uVh8
Message-ID: <CACxGe6v6zHcq=99JVvhNBe8DuWhyaZ_ojFai9=J2Yuu2TZw1MQ@mail.gmail.com>
Subject: Re: [PATCH 2/3] spi / ACPI: add ACPI enumeration support
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
        lenb@kernel.org, rafael.j.wysocki@intel.com,
        broonie@opensource.wolfsonmicro.com, linus.walleij@linaro.org,
        khali@linux-fr.org, ben-linux@fluff.org, w.sang@pengutronix.de,
        mathias.nyman@linux.intel.com, linux-acpi@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 9, 2012 at 3:11 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> [+cc Greg, Peter, Tony since they acked the original patch [1]]
>
> On Thu, Nov 8, 2012 at 1:04 PM, Mika Westerberg
> <mika.westerberg@linux.intel.com> wrote:
>> On Thu, Nov 08, 2012 at 12:32:25PM -0700, Bjorn Helgaas wrote:
>>> Struct device_driver is a generic structure, so it seems strange to
>>> have to include non-generic things like of_device_id and now
>>> acpi_match_table there.
>>
>> Yes, but in a sense the DT and ACPI are "generic". So that they are used to
>> describe the configuration of a machine.
>
> What I meant by "generic" was "useful across all architectures."  The
> new acpi_match_table and acpi_handle fields [1] are not generic in
> that sense because they're present on all architectures but used only
> on x86 and ia64.  The existing of_match_table and of_node are
> similarly unused on many architectures.  This doesn't seem like a
> scalable strategy to me.  Are we going to add a pnpbios_node for x86
> PNPBIOS machines without ACPI, a pdc_hpa for parisc machines with PDC,
> etc.?
>
> [1] https://patchwork.kernel.org/patch/1677221/

Ultimately yes, I think that is what we want to do, but there is first
the non-trivial problem to solve of figuring out how ACPI/DT/whatever
data maps into what the driver expects. For example, say a device uses
two GPIOs (A & B) and we have a generic get_gpio(int index) function
that works for both ACPI and DT. But what if the ACPI binding has the
gpios in the order A,B and DT orders them B,A? I do want to coordinate
between the DT and ACPI camps to avoid those situations as much as
possible, but they will happen. When they do the driver will still
need firmware specific data. It doesn't make any sense to put that
stuff outside the driver because only that specific driver needs the
extra information.

g.
