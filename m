Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752766Ab2APAIj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jan 2012 19:08:39 -0500
Received: from terminus.zytor.com ([198.137.202.10]:42004 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751045Ab2APAIi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jan 2012 19:08:38 -0500
Message-ID: <4F136A50.80203@zytor.com>
Date: Sun, 15 Jan 2012 16:07:44 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Brian Gerst <brgerst@gmail.com>
CC: Fenghua Yu <fenghua.yu@intel.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
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
Subject: Re: [PATCH v5 10/12] x86/mtrr/main.c: Ask the first online CPU to
 save mtrr
References: <1326301493-28760-1-git-send-email-fenghua.yu@intel.com> <1326301493-28760-11-git-send-email-fenghua.yu@intel.com> <CAMzpN2hfCCarbn+CDGrQuUaXYT29HpRd+9n0EKWvZdgLdqdAhA@mail.gmail.com>
In-Reply-To: <CAMzpN2hfCCarbn+CDGrQuUaXYT29HpRd+9n0EKWvZdgLdqdAhA@mail.gmail.com>
X-Enigmail-Version: 1.3.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/12/2012 04:33 AM, Brian Gerst wrote:
> On Wed, Jan 11, 2012 at 12:04 PM, Fenghua Yu <fenghua.yu@intel.com> wrote:
>> From: Fenghua Yu <fenghua.yu@intel.com>
>>
>> Ask the first online CPU to save mtrr instead of asking BSP. BSP could be
>> offline when mtrr_save_state() is called.
> 
> If you can use any non-boot cpu to save the MTRRs why not just use the
> current cpu?  They should all be in sync anyways.
> 

A much bigger question: why do we ever bother saving the MTRR state per
se?  We examine the MTRR state -- we have to -- during boot, and it
should never diverge from the state set by the OS from that point on --
we'll need to set it back to that.  So we should just keep track of what
the correct MTRR state is at all times.

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

