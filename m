Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756161Ab0EZPSj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 11:18:39 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:58791 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756045Ab0EZPSi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 11:18:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type;
        b=lneHNmhRk3CetOT02infPKS8KRHI+ZlsD5bMMfFMMHZN7LljvuWMsj9wM8PhzBijCU
         5EdnnBW5rpZq6IfmQH0F8eHZTnXQR7G/BSWV3geqMlmkm5KeZKlXfx7OQBlrQNP5cZB0
         TVnMCToKg5rGxZov6rB9EMH5UFa1NQDHPM0aw=
MIME-Version: 1.0
In-Reply-To: <20100526135628.GA9127@a1.tnic>
References: <AANLkTinHkcWaHs8Hf6zvRjftC5hPkpHbC2LTaz-h4TJ3@mail.gmail.com>
	 <20100524065909.GA21310@liondog.tnic>
	 <AANLkTinVaesYF60kbSHnASQUuO2g_LdN58EBpouYUqXT@mail.gmail.com>
	 <20100526135628.GA9127@a1.tnic>
Date: Wed, 26 May 2010 17:18:36 +0200
Message-ID: <AANLkTikpTSMz5efs9iAMwyz4CgciNpiYLf_5SnpRJTCr@mail.gmail.com>
Subject: Re: CPU #1 not responding Problem
From: Jacek J <69rydzyk69@gmail.com>
To: Borislav Petkov <bp@alien8.de>, Jacek J <69rydzyk69@gmail.com>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Many thanks for answer.
Greetings,
Jack

On Wed, May 26, 2010 at 3:56 PM, Borislav Petkov <bp@alien8.de> wrote:
> From: Jacek J <69rydzyk69@gmail.com>
> Date: Tue, May 25, 2010 at 07:55:52PM +0200
>
>> thanks for your response. Dmesg is in attachment. Error is almost
>> unreproducable, seems random. I use 2.6.33 kernel from Arch
>> distribution.
>
> So what looks suspicious to me is this
>
> May 23 22:44:54 connexion1 kernel: ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
> May 23 22:44:54 connexion1 kernel: ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
> May 23 22:44:54 connexion1 kernel: ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
> May 23 22:44:54 connexion1 kernel: ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
> May 23 22:44:54 connexion1 kernel: ACPI: LAPIC_NMI (acpi_id[0x00] dfl dfl lint[0x1])
> May 23 22:44:54 connexion1 kernel: ACPI: LAPIC_NMI (acpi_id[0x01] dfl dfl lint[0x1])
> May 23 22:44:54 connexion1 kernel: ACPI: LAPIC_NMI (acpi_id[0x02] dfl dfl lint[0x1])
> May 23 22:44:54 connexion1 kernel: ACPI: LAPIC_NMI (acpi_id[0x03] dfl dfl lint[0x1])
> May 23 22:44:54 connexion1 kernel: ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
> May 23 22:44:54 connexion1 kernel: IOAPIC[0]: apic_id 2, version 33, address 0xfec00000, GSI 0-23
>
> and more specifically, the ioapic's id is 2 and it overlaps with the
> lapic id 2 of core 2. This could explain why in the broken case you
> get only 1 core up. The solution to that is to update your BIOS and
> hope that Gigabyte (your board maker) have fixed it already. We've
> seen similar initialization problems with b0rked Gigabyte boards, see
> https://bugzilla.kernel.org/show_bug.cgi?id=15289 and there the apic
> id's were also overlapping.
>
> HTH.
>
> --
> Regards/Gruss,
> Boris.
>
