Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758141Ab1JFCn0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 22:43:26 -0400
Received: from mga01.intel.com ([192.55.52.88]:16942 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752100Ab1JFCnZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 22:43:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,495,1312182000"; 
   d="scan'208";a="75211466"
From: Andi Kleen <andi@firstfloor.org>
To: "Yu\, Fenghua" <fenghua.yu@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        H Peter Anvin <hpa@zytor.com>, "Luck\, Tony" <tony.luck@intel.com>,
        "Mallick\, Asit K" <asit.k.mallick@intel.com>,
        "Siddha\, Suresh B" <suresh.b.siddha@intel.com>,
        Len Brown <lenb@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCH 1/8] x86, apic.c: Disable irq0 if CPU enables ARAT for local apic timer
References: <1317832759-10223-1-git-send-email-fenghua.yu@intel.com>
	<1317832759-10223-2-git-send-email-fenghua.yu@intel.com>
	<alpine.LFD.2.02.1110052045430.18778@ionos>
	<493994B35A117E4F832F97C4719C4C040136F7CBF3@orsmsx505.amr.corp.intel.com>
	<alpine.LFD.2.02.1110052129270.18778@ionos>
	<493994B35A117E4F832F97C4719C4C040136F7CC8E@orsmsx505.amr.corp.intel.com>
Date: Wed, 05 Oct 2011 19:43:24 -0700
In-Reply-To: <493994B35A117E4F832F97C4719C4C040136F7CC8E@orsmsx505.amr.corp.intel.com>
	(Fenghua Yu's message of "Wed, 5 Oct 2011 13:11:46 -0700")
Message-ID: <m2ehyq4z77.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Yu, Fenghua" <fenghua.yu@intel.com> writes:
>
> SC1200 WDT DRIVER
> M:      Zwane Mwaikambo <zwane@arm.linux.org.uk>
> S:      Maintained
> F:      drivers/watchdog/sc1200wdt.c
>
> I was hoping Zwane knows which PCI quirks depends on CPU0.

At least one AMD SIS chipset relied on IRQ0 always being on CPU0 
Not sure we got a quirk for it because the existing code handled it
(I guess it's reasonable to just blacklist for all of SIS,
i don't think they ever did anything multi-socket)
Alan may remember more.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
