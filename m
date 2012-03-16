Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751565Ab2CPETh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 00:19:37 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:54044 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790Ab2CPETg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 00:19:36 -0400
MIME-Version: 1.0
In-Reply-To: <CAE9FiQXXy3UDFpm5uCmpnn7Q53FhQN6h-BSAizgk_Sqkg+d4bA@mail.gmail.com>
References: <CAE9FiQXC7T7JQRfiry8nHaRYN3ggy9vfzc2jDUzar80hv6pEvw@mail.gmail.com>
	<1331834583-16070-1-git-send-email-sp@numascale.com>
	<CAE9FiQUh-kEcLLAZYiy90UJY8-WmXTKhYrjS7HQ40U+Ah2dwNg@mail.gmail.com>
	<1331846504.16101.12.camel@sbsiddha-desk.sc.intel.com>
	<CAE9FiQXXy3UDFpm5uCmpnn7Q53FhQN6h-BSAizgk_Sqkg+d4bA@mail.gmail.com>
Date: Thu, 15 Mar 2012 21:19:35 -0700
X-Google-Sender-Auth: gvx44yCzmMDzlsxDiuLFkVFpYAk
Message-ID: <CAE9FiQUtf9Pix3rmhgk_+oOf19dOvvgQYt+gbHQyag0xkH_bxA@mail.gmail.com>
Subject: Re: [PATCH] Use x2apic_supported() in the default_apic_id_valid() function.
From: Yinghai Lu <yinghai@kernel.org>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Steffen Persvold <sp@numascale.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Daniel J Blueman <daniel@numascale-asia.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 15, 2012 at 7:08 PM, Yinghai Lu <yinghai@kernel.org> wrote:
>> So this change breaks the commit
>> c284b42abadbb22083bfde24d308899c08d44ffa.
>>
>> I think the right thing is to have two different apid_id_valid checks
>> one for xapic driver (apic_flat_64.c) and another for x2apic driver
>> (x2apic_phys/cluster.c) and that way, x2apic MADT entries will be parsed
>> only if bios has handed over the OS in x2apic mode or if we have
>> selected the numachip model.
>
> that looks like more clear.

after more thinking, I think We should still use cpu_has_x2apic checking.

one maybe invalid case:

System have some cpus apic id < 255, and some cpu apic id > 255.
BSP apic id < 255.
those cpus apic id < 255 will be put into xapic mode, cpus > 255 will
be put into x2apic mode.
and DMAR table intr-remapping will be working.

So if we check x2apic_mode early, will skip cpu with apic id > 255,
even switch to x2apic later.

Thanks

Yinghai Lu
