Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161412Ab2COUXZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 16:23:25 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:56525 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161027Ab2COUXY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 16:23:24 -0400
MIME-Version: 1.0
In-Reply-To: <1331834583-16070-1-git-send-email-sp@numascale.com>
References: <CAE9FiQXC7T7JQRfiry8nHaRYN3ggy9vfzc2jDUzar80hv6pEvw@mail.gmail.com>
	<1331834583-16070-1-git-send-email-sp@numascale.com>
Date: Thu, 15 Mar 2012 13:23:24 -0700
X-Google-Sender-Auth: eQklUbdyNCmoEv09COVdvPYbkuM
Message-ID: <CAE9FiQUh-kEcLLAZYiy90UJY8-WmXTKhYrjS7HQ40U+Ah2dwNg@mail.gmail.com>
Subject: Re: [PATCH] Use x2apic_supported() in the default_apic_id_valid() function.
From: Yinghai Lu <yinghai@kernel.org>
To: Steffen Persvold <sp@numascale.com>
Cc: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Daniel J Blueman <daniel@numascale-asia.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 15, 2012 at 11:03 AM, Steffen Persvold <sp@numascale.com> wrote:
> Use x2apic_supported() in the default_apic_id_valid() function. If x2apic mode is disabled (via nox2apic for example), x2apic_supported() will return false.
>
> This allows us to substitute the check in arch/x86/kernel/acpi/boot.c::acpi_parse_x2apic and avoid feigning the x2apic cpu feature in the NumaChip apic code.
>
> Signed-off-by: Steffen Persvold <sp@numascale.com>
> Reviewed-by: Daniel J Blueman <daniel@numascale-asia.com>

I double checked on system with x2apic preenabled,
nox2apic in boot command line still works well and it
skips starting APs with apic id > 255.

Acked-by: Yinghai Lu <yinghai@kernel.org>
