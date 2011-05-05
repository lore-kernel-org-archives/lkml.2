Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755423Ab1EEQVk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 12:21:40 -0400
Received: from relay1.sgi.com ([192.48.179.29]:58636 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754883Ab1EEQVi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 12:21:38 -0400
Date: Thu, 5 May 2011 11:21:36 -0500
From: Jack Steiner <steiner@sgi.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
        "Brown, Len" <len.brown@intel.com>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Seiichi Ikarashi <s.ikarashi@jp.fujitsu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Subject: Re: [PATCH -v2 RESENDING] x86, acpi: Handle xapic/x2apic entries
	in MADT at same time
Message-ID: <20110505162136.GA21673@sgi.com>
References: <4DA41476.8040700@jp.fujitsu.com> <1304379923.19493.284.camel@sbsiddha-MOBL3.sc.intel.com> <4DC0514F.9070901@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DC0514F.9070901@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FYI

We also hit the same problem. Our BIOS folks tried to make the BIOS
ACPI compliant but we hit the same problem & broke cpu numbering.

For now, we've reverted the BIOS change but are concerned that another OS
may require the change.


>From the boot log:
     891.184006 (    0.001022)| [    0.000000] Setting APIC routing to UV large system.
     891.197920 (    0.013914)| [    0.000000] ACPI: X2APIC (apic_id[0x100] uid[0x20] enabled)
     891.218507 (    0.020587)| [    0.000000] ACPI: X2APIC (apic_id[0x102] uid[0x21] enabled)
    ...
     904.009046 (    0.006237)| [    0.000000] ACPI: X2APIC (apic_id[0x3ff0] uid[0x7fe] enabled)
     904.020501 (    0.011455)| [    0.000000] ACPI: X2APIC (apic_id[0x3ff2] uid[0x7ff] enabled)
     904.024500 (    0.003999)| [    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
     904.024684 (    0.000184)| [    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x02] enabled)

    ...

    1089.050351 (    0.008981)| [   30.960025] Booting Node   4, Processors  #1  #2 #3 #4 #5 #6 #7 #8 Ok.
    1089.847951 (    0.669131)| [   31.473073] Booting Node   5, Processors  #9 #10 #11 #12 #13 #14 #15 #16 Ok.
    ....
    1283.195893 (    0.772824)| [  224.864248] Booting Node 255, Processors  #2009 #2010 #2011 #2012 #2013 #2014 #2015 #2016 Ok.
    1283.970697 (    0.774804)| [  225.637077] Booting Node   0, Processors  #2017 #2018 #2019 #2020 #2021 #2022 #2023 Ok.
    1284.652065 (    0.681368)| [  226.316121] Booting Node   1, Processors  #2024 #2025 #2026 #2027 #2028 #2029 #2030 #2031 Ok.
    1285.422635 (    0.770570)| [  227.088808] Booting Node   2, Processors  #2032 #2033 #2034 #2035 #2036 #2037 #2038 #2039 Ok.
    1286.205456 (    0.782821)| [  227.864175] Booting Node   3, Processors  #2040 #2041 #2042 #2043 #2044 #2045 #2046 #2047 Ok.

--- jack
