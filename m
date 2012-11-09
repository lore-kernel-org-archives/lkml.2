Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754626Ab2KIQnw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 11:43:52 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:39891 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754024Ab2KIQns (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 11:43:48 -0500
MIME-Version: 1.0
In-Reply-To: <CAErSpo4V-0Tnaf__fKUHM_69tBvfLySWzaoCWha9gimx0va1-w@mail.gmail.com>
References: <1351928793-14375-1-git-send-email-mika.westerberg@linux.intel.com>
 <3455360.Z6cZSC3BtR@vostro.rjw.lan> <CAErSpo5xEO4M_Fb0dJ6w7Qxck-0RcKKwQjKj1QZgFxhof7X5Rw@mail.gmail.com>
 <1523215.Pon1eKPQDb@vostro.rjw.lan> <20121107095608.GX24532@intel.com>
 <CAErSpo5My6+ypp9zsxR8vh8k1px0otOWfAcacWaLNs2xjsc7UA@mail.gmail.com>
 <20121108200445.GC16012@intel.com> <CAErSpo7WT21rZ10vx9A4d8VtVaJB7FLeJqVAxKmZrZDy01FPZQ@mail.gmail.com>
 <CACxGe6v6zHcq=99JVvhNBe8DuWhyaZ_ojFai9=J2Yuu2TZw1MQ@mail.gmail.com> <CAErSpo4V-0Tnaf__fKUHM_69tBvfLySWzaoCWha9gimx0va1-w@mail.gmail.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Fri, 9 Nov 2012 16:43:27 +0000
X-Google-Sender-Auth: BseAuDtB73i1skbfAxarIq3fNn8
Message-ID: <CACxGe6vgYKv92x8qk5dbdA8UJNJPVxT_1p5Mn58NfBfVF3x+iQ@mail.gmail.com>
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

On Fri, Nov 9, 2012 at 4:35 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> On Fri, Nov 9, 2012 at 8:45 AM, Grant Likely <grant.likely@secretlab.ca> wrote:
>> On Fri, Nov 9, 2012 at 3:11 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>>> [+cc Greg, Peter, Tony since they acked the original patch [1]]
>>>
>>> On Thu, Nov 8, 2012 at 1:04 PM, Mika Westerberg
>>> <mika.westerberg@linux.intel.com> wrote:
>>>> On Thu, Nov 08, 2012 at 12:32:25PM -0700, Bjorn Helgaas wrote:
>>>>> Struct device_driver is a generic structure, so it seems strange to
>>>>> have to include non-generic things like of_device_id and now
>>>>> acpi_match_table there.
>>>>
>>>> Yes, but in a sense the DT and ACPI are "generic". So that they are used to
>>>> describe the configuration of a machine.
>>>
>>> What I meant by "generic" was "useful across all architectures."  The
>>> new acpi_match_table and acpi_handle fields [1] are not generic in
>>> that sense because they're present on all architectures but used only
>>> on x86 and ia64.  The existing of_match_table and of_node are
>>> similarly unused on many architectures.  This doesn't seem like a
>>> scalable strategy to me.  Are we going to add a pnpbios_node for x86
>>> PNPBIOS machines without ACPI, a pdc_hpa for parisc machines with PDC,
>>> etc.?
>>>
>>> [1] https://patchwork.kernel.org/patch/1677221/
>>
>> Ultimately yes, I think that is what we want to do,
>
> Just to be clear, you think we *should* add things like pnpbios_node,
> pdc_hpa, etc., to struct device, one field for every scheme of telling
> the OS about non-enumerable devices, where only one of the N fields is
> used on any given machine?  That seems surprising to me, but maybe I
> just need to be educated :)

Ah, I see what you're asking.

In the short term, yes but only because we don't have any other
alternative. What I'd really rather have is a safe way to attach datum
(ie. acpi_device or device_node) to a struct device and get it back
later in a type safe way. It would actually be useful for all manner
of things, not just ACPI/DT. I experimented a bit with trying to
implement something a year back, but never spent enough time on it.

g.
