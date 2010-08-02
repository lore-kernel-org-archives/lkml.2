Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753021Ab0HBGuE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 02:50:04 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:44824 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752493Ab0HBGuB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 02:50:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=mgMwczpAjjnfAQRiXVkqW9Lw0bBQuYPmdYqvdwbvUXY7ylSO78+Ga+9ll5cnHCJC+8
         Qyl7epJcoGjhkeo/A2MOxlHnjuEEUMu2JWlKzMcgK48OzMC8Dh6XnYIJf1GZetBINhcR
         vZPQ17PsvU6Za8LIQM/XbndgjhMcVf8v8zMXo=
MIME-Version: 1.0
In-Reply-To: <AANLkTimeFuABgQHJzq38uJ-4gTQbfSRfQBb91P+NPwCS@mail.gmail.com>
References: <AANLkTimeFuABgQHJzq38uJ-4gTQbfSRfQBb91P+NPwCS@mail.gmail.com>
Date: Sun, 1 Aug 2010 23:49:59 -0700
X-Google-Sender-Auth: XCNeD1BMNUpLV7pwBIZG3XtqeeI
Message-ID: <AANLkTimqDPvTqOZiBgUn7t4JJhgQU4ShVTsCJEzV=8fR@mail.gmail.com>
Subject: Re: oops in ioapic_write_entry
From: Yinghai Lu <yinghai@kernel.org>
To: Dave Airlie <airlied@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 1, 2010 at 10:28 PM, Dave Airlie <airlied@gmail.com> wrote:
> Hey guys,
>
> Booted 2.6.35 + my drm-next tree this morning, happened with -rc6. Now
> I changed graphics cards this morning, and my 2.6.32 based enterprise
> kernels are booting fine, and I haven't had much time to bisect this,
> but I thought it might be interesting to you guys. I've booted my
> kernel on other machines with no problems which is why I suspect its

sata_nv 0000:00:0e.0: PCI->APIC IRQ transform: INT A -> IRQ 35
sata_nv 0000:00:0e.0: Using SWNCQ mode
scsi0 : sata_nv
scsi1 : sata_nv
ata1: SATA max UDMA/133 cmd 0xfe00 ctl 0xfe10 bmdma 0xfec0 irq 35
ata2: SATA max UDMA/133 cmd 0xfe20 ctl 0xfe30 bmdma 0xfec8 irq 35
sata_nv 0000:00:0e.1: PCI->APIC IRQ transform: INT B -> IRQ 35
sata_nv 0000:00:0e.1: Using SWNCQ mode
scsi2 : sata_nv
scsi3 : sata_nv
ata3: SATA max UDMA/133 cmd 0xfe40 ctl 0xfe50 bmdma 0xfed0 irq 35
ata4: SATA max UDMA/133 cmd 0xfe60 ctl 0xfe70 bmdma 0xfed8 irq 35
sata_nv 0000:00:0e.2: PCI->APIC IRQ transform: INT C -> IRQ 35
sata_nv 0000:00:0e.2: Using SWNCQ mode
scsi4 : sata_nv
scsi5 : sata_nv
ata5: SATA max UDMA/133 cmd 0xfe80 ctl 0xfe90 bmdma 0xfef0 irq 35
ata6: SATA max UDMA/133 cmd 0xfea0 ctl 0xfeb0 bmdma 0xfef8 irq 35

the kernel is using mptable, and the  system have mcp55, so how come
with irq 35?
assume we should only have ioapic irq 0 - 23 ...

Can you send out boot log with "debug apic=debug pci=routeirq" with
2.6.32 and 2.6.35?

Yinghai
