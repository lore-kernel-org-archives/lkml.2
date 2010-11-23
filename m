Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756285Ab0KWShZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 13:37:25 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:34386 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752033Ab0KWShX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 13:37:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=ZSasaaXKeLWh90buzf8Fn0h9zknp483/kHgfNoPEzOQETOxNTjs8fwGkl3jPXU8vTl
         X6oTV9TA3c/2MVpNE7Jpn1rPs3TmwlnEzCToajpISvtMgnDT3Ou11ZXD5PPjI/d+547T
         PvRsQOsc99x0tPcXnfcRxlR5/ksBIlzV31a7U=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <AANLkTikOub+x1oo8Cv7hBHgLPF9vjPfzmNwXzEvPPjRK@mail.gmail.com>
References: <AANLkTikzSY09i=C+A2Y=_gVa-44r_bN76P-U2-NZMnpz@mail.gmail.com>
	<20101123165657.GF18100@redhat.com>
	<AANLkTimsz2XWQq7bJ4uhWXhoPuQw-fSJbCJ6D6Xo69XM@mail.gmail.com>
	<1290536827.2072.417.camel@laptop>
	<AANLkTikOub+x1oo8Cv7hBHgLPF9vjPfzmNwXzEvPPjRK@mail.gmail.com>
Date: Tue, 23 Nov 2010 19:37:21 +0100
Message-ID: <AANLkTi=Vvi7MBbmnT7-iuLOBH4_zBzirmBt3sjwqyhmZ@mail.gmail.com>
Subject: Re: [PATCH] x86, perf, nmi: Disable perf if counters are not accessable
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Don Zickus <dzickus@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 23, 2010 at 7:29 PM, Sedat Dilek <sedat.dilek@googlemail.com> wrote:
> On Tue, Nov 23, 2010 at 7:27 PM, Peter Zijlstra <peterz@infradead.org> wrote:
>> On Tue, 2010-11-23 at 19:21 +0100, Sedat Dilek wrote:
>>> Due to BIOS l(ocal)apic is not possible:
>>>
>>> # dmesg | grep -i apic
>>> [    0.000000] Using APIC driver default
>>> [    0.000000] Local APIC disabled by BIOS -- you can enable it with "lapic"
>>> [    0.000000] APIC: disable apic facility
>>> [    0.000000] APIC: switched to apic NOOP
>>> [    0.008891] no APIC, boot with the "lapic" boot parameter to force-enable it.
>>> [    0.036141] Local APIC not detected. Using dummy APIC emulation.
>>
>> Have you tried booting with "lapic" as the second last msg suggests you
>> do?
>>
>
> Yes, I did try before there was [1], booting with "lapic" had no effect.
>
> - Sedat -
>
> [1] bugfix/x86/Skip-looking-for-ioapic-overrides-when-ioapics-are-not-present.patch
>

OK, some months went by when I last tested this option.

Now, with linux-next (next-20101123) things look better.

# cat /proc/cmdline
BOOT_IMAGE=/boot/vmlinuz-2.6.37-rc3-686
root=UUID=1ceb69a7-ecf4-47e9-a231-b74e0f0a9b62 ro radeon.modeset=1
lapic 3

# dmesg | egrep -i 'NMI|APIC'
[    0.000000] Using APIC driver default
[    0.000000] Local APIC disabled by BIOS -- reenabling.
[    0.000000] Found and enabled local APIC!
[    0.000000] Kernel command line:
BOOT_IMAGE=/boot/vmlinuz-2.6.37-rc3-686
root=UUID=1ceb69a7-ecf4-47e9-a231-b74e0f0a9b62 ro radeon.modeset=1
lapic 3
[    0.032158] Enabling APIC mode:  Flat.  Using 0 I/O APICs
[    0.036000] NMI watchdog enabled, takes one hw-pmu counter.

- Sedat -
