Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752496Ab1GXDnS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jul 2011 23:43:18 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:60971 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752209Ab1GXDnK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jul 2011 23:43:10 -0400
MIME-Version: 1.0
In-Reply-To: <20110724033313.GB25722@srcf.ucam.org>
References: <1311007062-2050-1-git-send-email-mjg@redhat.com>
 <1311007062-2050-4-git-send-email-mjg@redhat.com> <4E2B8E36.6030308@mit.edu> <20110724033313.GB25722@srcf.ucam.org>
From: Andrew Lutomirski <luto@mit.edu>
Date: Sat, 23 Jul 2011 23:42:50 -0400
X-Google-Sender-Auth: gqukUQMKjUTdTVjKHjNJ3zKHFR4
Message-ID: <CAObL_7Gis4YaSB+suFXxLmSchmJaEc6Jqv6aY6VvWynuEkRb5A@mail.gmail.com>
Subject: Re: [PATCH v4 3/7] acpi-cpufreq: Add support for disabling dynamic overclocking
To: Matthew Garrett <mjg@redhat.com>
Cc: cpufreq@vger.kernel.org, davej@redhat.com, linux-kernel@vger.kernel.org,
        borislav.petkov@amd.com, mark.langsdorf@amd.com,
        andreas.herrmann3@amd.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 23, 2011 at 11:33 PM, Matthew Garrett <mjg@redhat.com> wrote:
> On Sat, Jul 23, 2011 at 11:15:02PM -0400, Andy Lutomirski wrote:
>
>> I was curious and looked it up.  Intel SDM volume 3, 14.3.2.1 says:
>>
>> Opportunistic processor performance operation can be disabled by
>> setting bit 38 of
>> IA32_MISC_ENABLE. This mechanism is intended for BIOS only. If
>> IA32_MISC_ENABLE[38] is set, CPUID.06H:EAX[1] will return 0.
>
> Hm. Interesting. The observed behaviour is that it works fine if we
> toggle this ourselves, and I don't remember the version of the docs I
> was looking at adding the BIOS proviso. Having said that...
>
>> System software can temporarily disengage opportunistic processor
>> performance
>> operation by setting bit 32 of the IA32_PERF_CTL MSR (0199H), using a read-
>> modify-write sequence on the MSR.
>
> This complicates things a little, since right now we just write the
> firmware's P state value directly into PERF_CTL. We'd need to add code
> to acpi_cpufreq_target to make sure that it masked that bit off. It's a
> little more awkward, but if we're being told not to do it by just
> hitting the bit in MISC_ENABLE it's probably worth it. I'll try to
> handle that this week.

This way may give the benefit of making it work per core instead of
per package.  The manual is rather unclear on this point.

I actually have a use case for this.  I have a system that keeps a
bunch of cores under moderate load.  I have one thread in particular
that needs to be fast, and I'd like to disable boosting on the other
cores to keep more thermal and power headroom available for the one
thread that cares.

Of course, I can probably accomplish this with scaling_max_freq as well.

--Andy
