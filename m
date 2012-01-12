Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751958Ab2ALMbn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 07:31:43 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:65497 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077Ab2ALMbl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 07:31:41 -0500
MIME-Version: 1.0
In-Reply-To: <1326301493-28760-9-git-send-email-fenghua.yu@intel.com>
References: <1326301493-28760-1-git-send-email-fenghua.yu@intel.com>
	<1326301493-28760-9-git-send-email-fenghua.yu@intel.com>
Date: Thu, 12 Jan 2012 07:31:40 -0500
Message-ID: <CAMzpN2gFB0LuWqVA2KA13C3+g8Zb2irmFnpjwHOtOvhuE67KWQ@mail.gmail.com>
Subject: Re: [PATCH v5 08/12] x86/smpboot.c: Wake up CPU0 via NMI instead of INITs
From: Brian Gerst <brgerst@gmail.com>
To: Fenghua Yu <fenghua.yu@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        H Peter Anvin <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Asit K Mallick <asit.k.mallick@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Arjan van de Ven <arjan.van.de.ven@intel.com>,
        Suresh B Siddha <suresh.b.siddha@intel.com>,
        Len Brown <len.brown@intel.com>, Randy Dunlap <rdunlap@xenotime.net>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Chen Gong <gong.chen@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-pm <linux-pm@vger.kernel.org>, x86 <x86@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 11, 2012 at 12:04 PM, Fenghua Yu <fenghua.yu@intel.com> wrote:
> From: Fenghua Yu <fenghua.yu@intel.com>
>
> Instead of waiting for STARTUP after INITs, BSP will execute
> the BIOS boot-strap code which is not a desired behavior for
> waking up BSP. To avoid the boot-strap code, wake up CPU0 by
> NMI instead.
>
> This works to wake up soft offlined CPU0 only. If CPU0 is hard offlined (i.e.
> physically hot removed and then hot added), NMI won't wake it up. We'll change
> this code in the future to wake up hard offlined CPU0 if real platform and
> request are available.
>
> AP is still waken up as before by INIT, INIT, STARTUP sequence.

Would clearing IA32_APIC_BASE_MSR.BSP avoid calling the BIOS code when
the cpu is brought back online?  Setting that flag in another cpu that
is still online might also allow suspend/resume to work.

--
Brian Gerst
