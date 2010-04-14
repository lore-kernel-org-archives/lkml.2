Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754961Ab0DNKrh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 06:47:37 -0400
Received: from mail-ew0-f220.google.com ([209.85.219.220]:51977 "EHLO
	mail-ew0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754737Ab0DNKrf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 06:47:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=b4w1LExTOmGUNBUhcxpWKIPrJ3Cqs56J8+jLE4CCku0GsQqw1lxD8ezOKizaJpMuUG
         +rOEH9Vs6XQPZhAsqrlejCAAxORh6tWmcGz1DsWNzAJOc2/188T+TlHrLkLhZpGsT0G2
         ouQg2fkqqj2oG+QkeQ3kZKj4s9bdJcKijVCSQ=
MIME-Version: 1.0
In-Reply-To: <20100414100946.GS30807@buzzloop.caiaq.de>
References: <20100412162947.GQ18855@one.firstfloor.org>
	 <Pine.LNX.4.44L0.1004121252310.1702-100000@iolanthe.rowland.org>
	 <20100413182233.GR30807@buzzloop.caiaq.de>
	 <k2o74fd948d1004131646k1e0e1897z7594f77a580c6b9f@mail.gmail.com>
	 <20100414100946.GS30807@buzzloop.caiaq.de>
Date: Wed, 14 Apr 2010 11:47:33 +0100
Message-ID: <t2w74fd948d1004140347k3447bffapb73856eacddfde55@mail.gmail.com>
Subject: Re: USB transfer_buffer allocations on 64bit systems
From: Pedro Ribeiro <pedrib@gmail.com>
To: linux-usb@vger.kernel.org
Cc: Alan Stern <stern@rowland.harvard.edu>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Greg KH <gregkh@suse.de>, alsa-devel@alsa-project.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14 April 2010 11:09, Daniel Mack <daniel@caiaq.de> wrote:

> Thanks! So the only thing I can do for now is submit exactly this patch.
> At least, it helps you and it shouldn't break anything. The question
> remains whether this type of memory should be used for all
> transfer_buffers.
>

Is there any chance you could push this to -stable? I don't care
because I always use the latest kernel, but the next Debian stable and
Ubuntu LTS are going to use 2.6.32.

>> Any idea why is mem=4096m different than a regular boot since I have 4GB anyway?
>
> On Fri, Apr 09, 2010 at 04:11:52PM -0600, Robert Hancock wrote:
>> If you have 4GB of RAM then almost certainly you have memory located
>> at addresses over 4GB. If you look at the e820 memory map printed at
>> the start of dmesg on bootup and see entries with addresses of
>> 100000000 or higher reported as usable, then this is the case.
>
> Could you post the these e820 line from your dmesg when booted with
> mem=4096?
>
> Daniel
>
>

This is the e820 WITHOUT mem=4096m:

[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009ec00 (usable)
[    0.000000]  BIOS-e820: 000000000009ec00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000dc000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000bd4a1000 (usable)
[    0.000000]  BIOS-e820: 00000000bd4a1000 - 00000000bd4a7000 (reserved)
[    0.000000]  BIOS-e820: 00000000bd4a7000 - 00000000bd5b8000 (usable)
[    0.000000]  BIOS-e820: 00000000bd5b8000 - 00000000bd60f000 (reserved)
[    0.000000]  BIOS-e820: 00000000bd60f000 - 00000000bd6c6000 (usable)
[    0.000000]  BIOS-e820: 00000000bd6c6000 - 00000000bd6d1000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bd6d1000 - 00000000bd6d4000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bd6d4000 - 00000000bd6d8000 (reserved)
[    0.000000]  BIOS-e820: 00000000bd6d8000 - 00000000bd6dc000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bd6dc000 - 00000000bd6df000 (reserved)
[    0.000000]  BIOS-e820: 00000000bd6df000 - 00000000bd706000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bd706000 - 00000000bd708000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bd708000 - 00000000bd90f000 (reserved)
[    0.000000]  BIOS-e820: 00000000bd90f000 - 00000000bd99f000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bd99f000 - 00000000bd9ff000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bd9ff000 - 00000000bda00000 (usable)
[    0.000000]  BIOS-e820: 00000000bdc00000 - 00000000c0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed00000 - 00000000fed00400 (reserved)
[    0.000000]  BIOS-e820: 00000000fed10000 - 00000000fed14000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed18000 - 00000000fed1a000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed1c000 - 00000000fed90000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ff800000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 000000013c000000 (usable)



This is the e820 output WITH mem=4096m

[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009ec00 (usable)
[    0.000000]  BIOS-e820: 000000000009ec00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000dc000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000bd4a1000 (usable)
[    0.000000]  BIOS-e820: 00000000bd4a1000 - 00000000bd4a7000 (reserved)
[    0.000000]  BIOS-e820: 00000000bd4a7000 - 00000000bd5b8000 (usable)
[    0.000000]  BIOS-e820: 00000000bd5b8000 - 00000000bd60f000 (reserved)
[    0.000000]  BIOS-e820: 00000000bd60f000 - 00000000bd6c6000 (usable)
[    0.000000]  BIOS-e820: 00000000bd6c6000 - 00000000bd6d1000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bd6d1000 - 00000000bd6d4000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bd6d4000 - 00000000bd6d8000 (reserved)
[    0.000000]  BIOS-e820: 00000000bd6d8000 - 00000000bd6dc000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bd6dc000 - 00000000bd6df000 (reserved)
[    0.000000]  BIOS-e820: 00000000bd6df000 - 00000000bd706000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bd706000 - 00000000bd708000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bd708000 - 00000000bd90f000 (reserved)
[    0.000000]  BIOS-e820: 00000000bd90f000 - 00000000bd99f000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bd99f000 - 00000000bd9ff000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bd9ff000 - 00000000bda00000 (usable)
[    0.000000]  BIOS-e820: 00000000bdc00000 - 00000000c0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed00000 - 00000000fed00400 (reserved)
[    0.000000]  BIOS-e820: 00000000fed10000 - 00000000fed14000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed18000 - 00000000fed1a000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed1c000 - 00000000fed90000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ff800000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 000000013c000000 (usable)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] user-defined physical RAM map:
[    0.000000]  user: 0000000000000000 - 000000000009ec00 (usable)
[    0.000000]  user: 000000000009ec00 - 00000000000a0000 (reserved)
[    0.000000]  user: 00000000000dc000 - 0000000000100000 (reserved)
[    0.000000]  user: 0000000000100000 - 00000000bd4a1000 (usable)
[    0.000000]  user: 00000000bd4a1000 - 00000000bd4a7000 (reserved)
[    0.000000]  user: 00000000bd4a7000 - 00000000bd5b8000 (usable)
[    0.000000]  user: 00000000bd5b8000 - 00000000bd60f000 (reserved)
[    0.000000]  user: 00000000bd60f000 - 00000000bd6c6000 (usable)
[    0.000000]  user: 00000000bd6c6000 - 00000000bd6d1000 (ACPI NVS)
[    0.000000]  user: 00000000bd6d1000 - 00000000bd6d4000 (ACPI data)
[    0.000000]  user: 00000000bd6d4000 - 00000000bd6d8000 (reserved)
[    0.000000]  user: 00000000bd6d8000 - 00000000bd6dc000 (ACPI NVS)
[    0.000000]  user: 00000000bd6dc000 - 00000000bd6df000 (reserved)
[    0.000000]  user: 00000000bd6df000 - 00000000bd706000 (ACPI NVS)
[    0.000000]  user: 00000000bd706000 - 00000000bd708000 (ACPI data)
[    0.000000]  user: 00000000bd708000 - 00000000bd90f000 (reserved)
[    0.000000]  user: 00000000bd90f000 - 00000000bd99f000 (ACPI NVS)
[    0.000000]  user: 00000000bd99f000 - 00000000bd9ff000 (ACPI data)
[    0.000000]  user: 00000000bd9ff000 - 00000000bda00000 (usable)
[    0.000000]  user: 00000000bdc00000 - 00000000c0000000 (reserved)
[    0.000000]  user: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  user: 00000000fec00000 - 00000000fec10000 (reserved)
[    0.000000]  user: 00000000fed00000 - 00000000fed00400 (reserved)
[    0.000000]  user: 00000000fed10000 - 00000000fed14000 (reserved)
[    0.000000]  user: 00000000fed18000 - 00000000fed1a000 (reserved)
[    0.000000]  user: 00000000fed1c000 - 00000000fed90000 (reserved)
[    0.000000]  user: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  user: 00000000ff800000 - 0000000100000000 (reserved)

So basically the BIOS is incorrectly reporting
BIOS-e820: 0000000100000000 - 000000013c000000 (usable)

right?

Thanks,
Pedro
