Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756057Ab0HMXBH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 19:01:07 -0400
Received: from mga01.intel.com ([192.55.52.88]:20735 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755842Ab0HMXBF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 19:01:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,365,1278313200"; 
   d="scan'208";a="827916309"
Subject: Re: [patch]x86: avoid unnecessary tlb flush
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Hugh Dickins <hughd@google.com>, "Li, Shaohua" <shaohua.li@intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Andi Kleen <andi@firstfloor.org>
In-Reply-To: <4C65B449.4010905@zytor.com>
References: <1281065308.29094.5.camel@sli10-desk.sh.intel.com>
	 <20100805221913.4da0f8be.akpm@linux-foundation.org>
	 <1281660475.21194.1.camel@sli10-desk.sh.intel.com>
	 <alpine.DEB.1.00.1008131222110.26182@tigran.mtv.corp.google.com>
	 <4C65B449.4010905@zytor.com>
Content-Type: text/plain
Organization: Intel Corp
Date: Fri, 13 Aug 2010 16:00:37 -0700
Message-Id: <1281740437.2704.65.camel@sbsiddha-MOBL3.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-08-13 at 14:08 -0700, H. Peter Anvin wrote:
> On 08/13/2010 12:29 PM, Hugh Dickins wrote:
> > 
> > Just added Andrea to the Cc list: he did that TLB flush in 1a44e149,
> > I'd feel more comfortable noop-ing it on x86 if you've convinced him.
> > 
> > Hugh
> 
> Andrea is probably on his way back from LinuxCon, but looking at the
> original patch it might be something that non-x86 architectures need,
> but which can be optimized specifically on x86, since x86 has explicit
> "no flush needed when going to more permissive" semantics.

Yes. I don't see a problem with the proposed patch. This is the case of
parallel thread execution getting spurious write protection faults for
the same page for which the pte entry is already up to date and the
fault has already flushed the existing spurious TLB entry in the case of
x86.

I prefer a better name for the new flush_tlb_nonprotect_page() to
reflect the above. something like tlb_fix_spurious_fault() or something?

Also for other architectures, in this case, do we really need a global
tlb flush or just the local tlb flush?

Acked-by: Suresh Siddha <suresh.b.siddha@intel.com>

