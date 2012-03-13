Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760581Ab2CMW6S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 18:58:18 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:39083 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760513Ab2CMW6P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 18:58:15 -0400
MIME-Version: 1.0
In-Reply-To: <4F5F1385.60406@numascale-asia.com>
References: <4F5F1385.60406@numascale-asia.com>
Date: Tue, 13 Mar 2012 15:58:15 -0700
X-Google-Sender-Auth: 2McriozqIByIWrZLldBvM--Zsag
Message-ID: <CAE9FiQWtHD41qoYSm+tzLROUyR_33bwyBgE882cop3vbEmSPhw@mail.gmail.com>
Subject: Re: x2APIC and many-APIC systems...
From: Yinghai Lu <yinghai@kernel.org>
To: Daniel J Blueman <daniel@numascale-asia.com>
Cc: Ingo Molnar <mingo@elte.hu>, Suresh Siddha <suresh.b.siddha@intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        x86@kernel.org, Steffen Persvold <sp@numascale.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 13, 2012 at 2:29 AM, Daniel J Blueman
<daniel@numascale-asia.com> wrote:
> Ingo, Suresh,
>
> Commit a35fd28256e7736cc84af8931a16224f0bfaaf6c prevents x2APIC structures
> being used from the ACPI MADT if the cores don't advertise the x2APIC
> feature. Commit c284b42abadbb22083bfde24d308899c08d44ffa prevents onlining
> cores with APIC ID >255 in non-x2APIC mode. Since NumaChip/NumaConnect uses
> x2APIC structures to describe non-x2APIC systems (AMD Opteron) with lots of
> APICs, we thus now can't boot all the cores.
>
> We are able to set the x2APIC bit in the processor feature flags, so get
> caught by the second patch. Is there an appropriate approach to use in these
> circumstances? Otherwise, would a patch that separates the APIC ID handover
> and future x2APIC MSR access be appropriate?
>

add is_apicid_valid() in struct apic?

Yinghai
