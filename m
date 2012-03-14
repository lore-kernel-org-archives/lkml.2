Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760552Ab2CNXTn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 19:19:43 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:46098 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755737Ab2CNXTk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 19:19:40 -0400
MIME-Version: 1.0
In-Reply-To: <4F60FD0A.5090103@numascale.com>
References: <1331680589.18900.76.camel@sbsiddha-desk.sc.intel.com>
	<1331709454-27966-1-git-send-email-daniel@numascale-asia.com>
	<CAE9FiQX_o8GXqi1A+LTE4pseb81d1Aj5zR49NBvJiyAx24yYfw@mail.gmail.com>
	<4F60FD0A.5090103@numascale.com>
Date: Wed, 14 Mar 2012 16:19:40 -0700
X-Google-Sender-Auth: 0O_6GUwNKUB9ft_KgzgNZh-fYig
Message-ID: <CAE9FiQXC7T7JQRfiry8nHaRYN3ggy9vfzc2jDUzar80hv6pEvw@mail.gmail.com>
Subject: Re: [PATCH] Move APIC ID validity check into platform APIC code
From: Yinghai Lu <yinghai@kernel.org>
To: Steffen Persvold <sp@numascale.com>
Cc: Daniel J Blueman <daniel@numascale-asia.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        x86@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 14, 2012 at 1:18 PM, Steffen Persvold <sp@numascale.com> wrote:
> which, as you can see, checks against "x2apic_mode".
>
> My question is; Is checking for "x2apic_mode" going to do the trick in the
> arch/x86/kernel/acpi/boot.c::acpi_parse_x2apic() ?

no, it is too early.

at that time, only x2apic pre-enabled system have that x2apic_mode set.

>
> If the answer is yes, the patch is going to be very simple. But we can't
> verify that the code in arch/x86/kernel/acpi/boot.c::acpi_parse_x2apic()
> actually triggers for the case you wanted it to trigger for because then it
> will check against "x2apic_mode" and not "cpu_has_x2apic".

when kernel, found pre-enabled x2apic, can not use x2apic for some
reason (like x2apic)
it will clear x2apic in cpu feature bit.

for other case like x2apic capable cpus and not preenabled,
but not have dmar table, that feature is not cleared if the not apic id > 255.

So we have default apic_id_valid only check cpu_has_x2apic instead of
x2apic_mode instead.
and use it in boot.c

Yinghai
