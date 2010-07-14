Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754889Ab0GNLnf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 07:43:35 -0400
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:50515 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753236Ab0GNLnd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 07:43:33 -0400
Date: Wed, 14 Jul 2010 14:43:31 +0300 (EEST)
From: Meelis Roos <mroos@linux.ee>
To: Yinghai Lu <yinghai@kernel.org>
cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: 2.6.35-rc* regression: ERROR: Unable to locate IOAPIC for GSI
 *
In-Reply-To: <AANLkTikYc5N5ihRBJI_n3yGfcRxjplxbYGtGzJZ1ufzc@mail.gmail.com>
Message-ID: <alpine.SOC.1.00.1007141441460.18009@math.ut.ee>
References: <alpine.SOC.1.00.1007081644200.15817@math.ut.ee> <AANLkTinwbPAsCAwrbYVj7_K-YsgKAPyjXlUlQNDZ7eqa@mail.gmail.com> <AANLkTikYc5N5ihRBJI_n3yGfcRxjplxbYGtGzJZ1ufzc@mail.gmail.com>
User-Agent: Alpine 1.00 (SOC 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> related commit:
> 
> commit 9a0a91bb56d2915cdb8585717de38376ad20fef9
> Author: Eric W. Biederman <ebiederm@xmission.com>
> Date:   Tue Mar 30 01:07:03 2010 -0700
> 
>     x86, acpi/irq: Teach acpi_get_override_irq to take a gsi not an isa_irq
> 
>     In perverse acpi implementations the isa irqs are not identity mapped
>     to the first 16 gsi.  Furthermore at least the extended interrupt
>     resource capability may return gsi's and not isa irqs.  So since
>     what we get from acpi is a gsi teach acpi_get_overrride_irq to
>     operate on a gsi instead of an isa_irq.
> 
>     Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
>     LKML-Reference: <1269936436-7039-2-git-send-email-ebiederm@xmission.com>
>     Signed-off-by: H. Peter Anvin <hpa@zytor.com>

[2c2df8418ac7908eec4558407b83f16739006c54] x86, acpi/irq: Introduce apci_isa_irq_to_gsi

This ise the commit that introduces the ERROR: lines in dmesg. Related 
to the same irq mapping changes.

The right way to silence these error lines in dmesg is the change 
proposed by hpa, about only trying to ouse ioapic whet we are in ioapic 
mode?

-- 
Meelis Roos (mroos@linux.ee)
