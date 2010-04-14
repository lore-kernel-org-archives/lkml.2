Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754994Ab0DNLC7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 07:02:59 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:26996 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754387Ab0DNLC5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 07:02:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=A/uhzdk4oCkNLU98sq39TIl/x9VHa50uMPCA1ADGXP1LZ4zzHJCJkwFkbH/2B3uDxL
         E8NscwUNrjgEWSaJXQjZKCzAW6d5eogLdadTWK5EdoOqB/d/DdE8yI0v1qIcYSDbadm9
         w1cJYB8GrBdmRWuNNvVW7NsVtxdyEcRqiXrbE=
MIME-Version: 1.0
In-Reply-To: <t2w74fd948d1004140347k3447bffapb73856eacddfde55@mail.gmail.com>
References: <20100412162947.GQ18855@one.firstfloor.org>
	 <Pine.LNX.4.44L0.1004121252310.1702-100000@iolanthe.rowland.org>
	 <20100413182233.GR30807@buzzloop.caiaq.de>
	 <k2o74fd948d1004131646k1e0e1897z7594f77a580c6b9f@mail.gmail.com>
	 <20100414100946.GS30807@buzzloop.caiaq.de>
	 <t2w74fd948d1004140347k3447bffapb73856eacddfde55@mail.gmail.com>
Date: Wed, 14 Apr 2010 12:02:55 +0100
Message-ID: <g2u74fd948d1004140402ja7dcd22an17fa7aec6478b5@mail.gmail.com>
Subject: Re: USB transfer_buffer allocations on 64bit systems
From: Pedro Ribeiro <pedrib@gmail.com>
To: linux-usb@vger.kernel.org, Daniel Mack <daniel@caiaq.de>
Cc: Alan Stern <stern@rowland.harvard.edu>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Greg KH <gregkh@suse.de>, alsa-devel@alsa-project.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14 April 2010 11:47, Pedro Ribeiro <pedrib@gmail.com> wrote:
> On 14 April 2010 11:09, Daniel Mack <daniel@caiaq.de> wrote:
>
>> Thanks! So the only thing I can do for now is submit exactly this patch.
>> At least, it helps you and it shouldn't break anything. The question
>> remains whether this type of memory should be used for all
>> transfer_buffers.
>>
>
> Is there any chance you could push this to -stable? I don't care
> because I always use the latest kernel, but the next Debian stable and
> Ubuntu LTS are going to use 2.6.32.
>
>>> Any idea why is mem=4096m different than a regular boot since I have 4GB anyway?
>>
>> On Fri, Apr 09, 2010 at 04:11:52PM -0600, Robert Hancock wrote:
>>> If you have 4GB of RAM then almost certainly you have memory located
>>> at addresses over 4GB. If you look at the e820 memory map printed at
>>> the start of dmesg on bootup and see entries with addresses of
>>> 100000000 or higher reported as usable, then this is the case.
>>
>> Could you post the these e820 line from your dmesg when booted with
>> mem=4096?
>>
>> Daniel
>>
>>
>
> This is the e820 WITHOUT mem=4096m:
>
> [    0.000000] BIOS-provided physical RAM map:
> [    0.000000]  BIOS-e820: 0000000000000000 - 000000000009ec00 (usable)
> [    0.000000]  BIOS-e820: 000000000009ec00 - 00000000000a0000 (reserved)
> [    0.000000]  BIOS-e820: 00000000000dc000 - 0000000000100000 (reserved)
> [    0.000000]  BIOS-e820: 0000000000100000 - 00000000bd4a1000 (usable)
> [    0.000000]  BIOS-e820: 00000000bd4a1000 - 00000000bd4a7000 (reserved)
> [    0.000000]  BIOS-e820: 00000000bd4a7000 - 00000000bd5b8000 (usable)
> [    0.000000]  BIOS-e820: 00000000bd5b8000 - 00000000bd60f000 (reserved)
> [    0.000000]  BIOS-e820: 00000000bd60f000 - 00000000bd6c6000 (usable)
> [    0.000000]  BIOS-e820: 00000000bd6c6000 - 00000000bd6d1000 (ACPI NVS)
> [    0.000000]  BIOS-e820: 00000000bd6d1000 - 00000000bd6d4000 (ACPI data)
> [    0.000000]  BIOS-e820: 00000000bd6d4000 - 00000000bd6d8000 (reserved)
> [    0.000000]  BIOS-e820: 00000000bd6d8000 - 00000000bd6dc000 (ACPI NVS)
> [    0.000000]  BIOS-e820: 00000000bd6dc000 - 00000000bd6df000 (reserved)
> [    0.000000]  BIOS-e820: 00000000bd6df000 - 00000000bd706000 (ACPI NVS)
> [    0.000000]  BIOS-e820: 00000000bd706000 - 00000000bd708000 (ACPI data)
> [    0.000000]  BIOS-e820: 00000000bd708000 - 00000000bd90f000 (reserved)
> [    0.000000]  BIOS-e820: 00000000bd90f000 - 00000000bd99f000 (ACPI NVS)
> [    0.000000]  BIOS-e820: 00000000bd99f000 - 00000000bd9ff000 (ACPI data)
> [    0.000000]  BIOS-e820: 00000000bd9ff000 - 00000000bda00000 (usable)
> [    0.000000]  BIOS-e820: 00000000bdc00000 - 00000000c0000000 (reserved)
> [    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
> [    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
> [    0.000000]  BIOS-e820: 00000000fed00000 - 00000000fed00400 (reserved)
> [    0.000000]  BIOS-e820: 00000000fed10000 - 00000000fed14000 (reserved)
> [    0.000000]  BIOS-e820: 00000000fed18000 - 00000000fed1a000 (reserved)
> [    0.000000]  BIOS-e820: 00000000fed1c000 - 00000000fed90000 (reserved)
> [    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
> [    0.000000]  BIOS-e820: 00000000ff800000 - 0000000100000000 (reserved)
> [    0.000000]  BIOS-e820: 0000000100000000 - 000000013c000000 (usable)
>
>
>
> This is the e820 output WITH mem=4096m
>
> [    0.000000] BIOS-provided physical RAM map:
> [    0.000000]  BIOS-e820: 0000000000000000 - 000000000009ec00 (usable)
> [    0.000000]  BIOS-e820: 000000000009ec00 - 00000000000a0000 (reserved)
> [    0.000000]  BIOS-e820: 00000000000dc000 - 0000000000100000 (reserved)
> [    0.000000]  BIOS-e820: 0000000000100000 - 00000000bd4a1000 (usable)
> [    0.000000]  BIOS-e820: 00000000bd4a1000 - 00000000bd4a7000 (reserved)
> [    0.000000]  BIOS-e820: 00000000bd4a7000 - 00000000bd5b8000 (usable)
> [    0.000000]  BIOS-e820: 00000000bd5b8000 - 00000000bd60f000 (reserved)
> [    0.000000]  BIOS-e820: 00000000bd60f000 - 00000000bd6c6000 (usable)
> [    0.000000]  BIOS-e820: 00000000bd6c6000 - 00000000bd6d1000 (ACPI NVS)
> [    0.000000]  BIOS-e820: 00000000bd6d1000 - 00000000bd6d4000 (ACPI data)
> [    0.000000]  BIOS-e820: 00000000bd6d4000 - 00000000bd6d8000 (reserved)
> [    0.000000]  BIOS-e820: 00000000bd6d8000 - 00000000bd6dc000 (ACPI NVS)
> [    0.000000]  BIOS-e820: 00000000bd6dc000 - 00000000bd6df000 (reserved)
> [    0.000000]  BIOS-e820: 00000000bd6df000 - 00000000bd706000 (ACPI NVS)
> [    0.000000]  BIOS-e820: 00000000bd706000 - 00000000bd708000 (ACPI data)
> [    0.000000]  BIOS-e820: 00000000bd708000 - 00000000bd90f000 (reserved)
> [    0.000000]  BIOS-e820: 00000000bd90f000 - 00000000bd99f000 (ACPI NVS)
> [    0.000000]  BIOS-e820: 00000000bd99f000 - 00000000bd9ff000 (ACPI data)
> [    0.000000]  BIOS-e820: 00000000bd9ff000 - 00000000bda00000 (usable)
> [    0.000000]  BIOS-e820: 00000000bdc00000 - 00000000c0000000 (reserved)
> [    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
> [    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
> [    0.000000]  BIOS-e820: 00000000fed00000 - 00000000fed00400 (reserved)
> [    0.000000]  BIOS-e820: 00000000fed10000 - 00000000fed14000 (reserved)
> [    0.000000]  BIOS-e820: 00000000fed18000 - 00000000fed1a000 (reserved)
> [    0.000000]  BIOS-e820: 00000000fed1c000 - 00000000fed90000 (reserved)
> [    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
> [    0.000000]  BIOS-e820: 00000000ff800000 - 0000000100000000 (reserved)
> [    0.000000]  BIOS-e820: 0000000100000000 - 000000013c000000 (usable)
> [    0.000000] NX (Execute Disable) protection: active
> [    0.000000] user-defined physical RAM map:
> [    0.000000]  user: 0000000000000000 - 000000000009ec00 (usable)
> [    0.000000]  user: 000000000009ec00 - 00000000000a0000 (reserved)
> [    0.000000]  user: 00000000000dc000 - 0000000000100000 (reserved)
> [    0.000000]  user: 0000000000100000 - 00000000bd4a1000 (usable)
> [    0.000000]  user: 00000000bd4a1000 - 00000000bd4a7000 (reserved)
> [    0.000000]  user: 00000000bd4a7000 - 00000000bd5b8000 (usable)
> [    0.000000]  user: 00000000bd5b8000 - 00000000bd60f000 (reserved)
> [    0.000000]  user: 00000000bd60f000 - 00000000bd6c6000 (usable)
> [    0.000000]  user: 00000000bd6c6000 - 00000000bd6d1000 (ACPI NVS)
> [    0.000000]  user: 00000000bd6d1000 - 00000000bd6d4000 (ACPI data)
> [    0.000000]  user: 00000000bd6d4000 - 00000000bd6d8000 (reserved)
> [    0.000000]  user: 00000000bd6d8000 - 00000000bd6dc000 (ACPI NVS)
> [    0.000000]  user: 00000000bd6dc000 - 00000000bd6df000 (reserved)
> [    0.000000]  user: 00000000bd6df000 - 00000000bd706000 (ACPI NVS)
> [    0.000000]  user: 00000000bd706000 - 00000000bd708000 (ACPI data)
> [    0.000000]  user: 00000000bd708000 - 00000000bd90f000 (reserved)
> [    0.000000]  user: 00000000bd90f000 - 00000000bd99f000 (ACPI NVS)
> [    0.000000]  user: 00000000bd99f000 - 00000000bd9ff000 (ACPI data)
> [    0.000000]  user: 00000000bd9ff000 - 00000000bda00000 (usable)
> [    0.000000]  user: 00000000bdc00000 - 00000000c0000000 (reserved)
> [    0.000000]  user: 00000000e0000000 - 00000000f0000000 (reserved)
> [    0.000000]  user: 00000000fec00000 - 00000000fec10000 (reserved)
> [    0.000000]  user: 00000000fed00000 - 00000000fed00400 (reserved)
> [    0.000000]  user: 00000000fed10000 - 00000000fed14000 (reserved)
> [    0.000000]  user: 00000000fed18000 - 00000000fed1a000 (reserved)
> [    0.000000]  user: 00000000fed1c000 - 00000000fed90000 (reserved)
> [    0.000000]  user: 00000000fee00000 - 00000000fee01000 (reserved)
> [    0.000000]  user: 00000000ff800000 - 0000000100000000 (reserved)
>
> So basically the BIOS is incorrectly reporting
> BIOS-e820: 0000000100000000 - 000000013c000000 (usable)
>
> right?
>
> Thanks,
> Pedro
>

(sorry for the spam)

Actually this can't be right, because booting with mem=4096m only
gives me 3047008 kb of usable memory, versus 3949684 kb without
mem=4096m.

Pedro
