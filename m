Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758565Ab0GHU1S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 16:27:18 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:45997 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754997Ab0GHU1R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 16:27:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=f7C428B4vqsP1WRa7c4vgJ8lF/9rfdv7wgjmab+3aivr8/qnkxLioHgLNzx03XJlQg
         85AvxSvMbPHDZ8us2wnipZFbEFRD0Y7IOZh3oVle0lYBeVEYPUBDx6bgxYUHa3Ox1sPH
         GTJfMoJ64yVb16jUIdbs+t7eqHYKd3wsN7+Yk=
MIME-Version: 1.0
In-Reply-To: <alpine.SOC.1.00.1007081644200.15817@math.ut.ee>
References: <alpine.SOC.1.00.1007081644200.15817@math.ut.ee>
Date: Thu, 8 Jul 2010 13:27:16 -0700
X-Google-Sender-Auth: do82xeXDfYPezBItwiyKVz3gr84
Message-ID: <AANLkTinwbPAsCAwrbYVj7_K-YsgKAPyjXlUlQNDZ7eqa@mail.gmail.com>
Subject: Re: 2.6.35-rc* regression: ERROR: Unable to locate IOAPIC for GSI *
From: Yinghai Lu <yinghai@kernel.org>
To: Meelis Roos <mroos@linux.ee>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 8, 2010 at 6:53 AM, Meelis Roos <mroos@linux.ee> wrote:
> Just tried 2.6.35-rc4-00086-g2aa72f6 on Celeron 900 + i815 chipset PC.
> I get these errors during bootup, and all interrupts become XT-PIC:
>
> [    0.087302] pnp: PnP ACPI init
> [    0.087482] ACPI: bus type pnp registered
> [    0.087999] ERROR: Unable to locate IOAPIC for GSI 8
> [    0.087999] ERROR: Unable to locate IOAPIC for GSI 13
> [    0.087999] ERROR: Unable to locate IOAPIC for GSI 12
> [    0.088091] ERROR: Unable to locate IOAPIC for GSI 1
> [    0.089013] ERROR: Unable to locate IOAPIC for GSI 6
> [    0.090612] ERROR: Unable to locate IOAPIC for GSI 4
> [    0.092235] ERROR: Unable to locate IOAPIC for GSI 3
> [    0.094382] ERROR: Unable to locate IOAPIC for GSI 7
> [    0.097470] pnp: PnP ACPI: found 13 devices
> [    0.097625] ACPI: ACPI bus type pnp unregistered
>
> 2.6.35-rc2-00001-g386f40c behaves the same.
>
> 2.6.34 worked fine, it reports just
> [    0.104513] pnp: PnP ACPI init
> [    0.104683] ACPI: bus type pnp registered
> [    0.116002] pnp: PnP ACPI: found 13 devices
> [    0.116158] ACPI: ACPI bus type pnp unregistered

Do you have bootlog for 2.6.34 with "debug apic=debug"?

>
> Will bisect but it takes some time.
>
> Full dmesg:
> [    0.000000] ACPI: RSDP 000ff980 00014 (v00 AMI   )
> [    0.000000] ACPI: RSDT 1fff0000 0002C (v01 D815EA D815EEA2 20021106 MSFT 00001011)
> [    0.000000] ACPI: FACP 1fff1000 00074 (v01 D815EA EA81510A 20021106 MSFT 00001011)
> [    0.000000] ACPI: DSDT 1ffe0000 030E4 (v01 D815E2 EA81520A 00000023 MSFT 0100000B)
> [    0.000000] ACPI: FACS 1fff8000 00040
> [    0.000000] ACPI: SSDT 1ffe30e4 00035 (v01 D815EA EA81510A 00000015 MSFT 0100000B)

no MADT

> [    0.000000] ACPI: PM-Timer IO Port: 0x408
> [    0.000000] Found and enabled local APIC!
> [    0.000000] nr_irqs_gsi: 16

> [    0.021087] Enabling APIC mode:  Flat.  Using 0 I/O APICs
no io apic.

YH
