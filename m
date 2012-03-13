Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964999Ab2CMJ3r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 05:29:47 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:62953 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756585Ab2CMJ3p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 05:29:45 -0400
Message-ID: <4F5F1385.60406@numascale-asia.com>
Date: Tue, 13 Mar 2012 17:29:41 +0800
From: Daniel J Blueman <daniel@numascale-asia.com>
Organization: Numascale Asia
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Suresh Siddha <suresh.b.siddha@intel.com>
CC: "H. Peter Anvin" <hpa@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        x86@kernel.org, Steffen Persvold <sp@numascale.com>,
        Yinghai Lu <yinghai@kernel.org>
Subject: x2APIC and many-APIC systems...
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo, Suresh,

Commit a35fd28256e7736cc84af8931a16224f0bfaaf6c prevents x2APIC 
structures being used from the ACPI MADT if the cores don't advertise 
the x2APIC feature. Commit c284b42abadbb22083bfde24d308899c08d44ffa 
prevents onlining cores with APIC ID >255 in non-x2APIC mode. Since 
NumaChip/NumaConnect uses x2APIC structures to describe non-x2APIC 
systems (AMD Opteron) with lots of APICs, we thus now can't boot all the 
cores.

We are able to set the x2APIC bit in the processor feature flags, so get 
caught by the second patch. Is there an appropriate approach to use in 
these circumstances? Otherwise, would a patch that separates the APIC ID 
handover and future x2APIC MSR access be appropriate?

Many thanks,
   Daniel
-- 
Daniel J Blueman
Principal Software Engineer, Numascale Asia
