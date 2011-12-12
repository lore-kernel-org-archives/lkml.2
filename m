Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753162Ab1LLHYB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 02:24:01 -0500
Received: from mga01.intel.com ([192.55.52.88]:5923 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752110Ab1LLHYA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 02:24:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="95096270"
Subject: Re: x2apic boot failure on recent sandy bridge system
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, "Berck E. Nash" <flyboy@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <CAE9FiQXk7y_oafNZG-QF5h3kDUQ3J6SP3A=ezHBT2W4Njo=uxQ@mail.gmail.com>
References: <4EE2BC33.80902@gmail.com>
	 <CAE9FiQXH6d0eAjbQ0Dz3Q8NR6ktP_x6UKtzDtuq8253Qv4KS7w@mail.gmail.com>
	 <20111211075713.GA20790@elte.hu>
	 <CAE9FiQXk7y_oafNZG-QF5h3kDUQ3J6SP3A=ezHBT2W4Njo=uxQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Intel
Date: Sun, 11 Dec 2011 23:23:22 -0800
Message-ID: <1323674602.4170.5.camel@sbsiddha-mobl2>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-12-11 at 13:43 -0800, Yinghai Lu wrote:
> -v4: according to Ingo, for x2apic pre-enabled system, if intr-remap can not
>         be enabled, try to disable x2apic instead of panic and request to
>         specify nox2apic for next boot. 

If bios has not exported any DMAR tables but enabled x2apic pre-boot, it
is tricky for the OS to disable x2apic and continue with xapic for
number of reasons. For example, if chipset has already enabled
interrupt-remapping (which is typically recommended to be enabled before
x2apic) but didn't provide DMAR tables, then there is no way OS can
disable interrupt-remapping in this case.

So even though the cpu might be back in xapic mode, but external
interrupts won't work.

thanks,
suresh

