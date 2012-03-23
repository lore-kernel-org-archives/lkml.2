Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031629Ab2CWAUb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 20:20:31 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43205 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031616Ab2CWAUa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 20:20:30 -0400
Message-ID: <4F6BC1C4.6050502@zytor.com>
Date: Thu, 22 Mar 2012 17:20:20 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Suresh Siddha <suresh.b.siddha@intel.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Len Brown <lenb@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch] x86, tlb: switch cr3 in leave_mm() only when needed
References: <1332459220.16101.144.camel@sbsiddha-desk.sc.intel.com>  <CA+55aFyf9RqAROx7t=CYUSGCDBXvv9z2c+LP1vRJjLU45_pD+Q@mail.gmail.com> <1332460885.16101.147.camel@sbsiddha-desk.sc.intel.com>
In-Reply-To: <1332460885.16101.147.camel@sbsiddha-desk.sc.intel.com>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/22/2012 05:01 PM, Suresh Siddha wrote:
> 
> Agreed. Updated patch appended. Thanks.
> ---
> From: Suresh Siddha <suresh.b.siddha@intel.com>
> Subject: x86, tlb: switch cr3 in leave_mm() only when needed
> 
> Currently leave_mm() unconditionally switches the cr3 to swapper_pg_dir.
> But there is no need to change the cr3, if we already left that mm.
> 
> intel_idle() for example calls leave_mm() on every deep c-state entry where
> the CPU flushes the TLB for us. Similarly flush_tlb_all() was also calling
> leave_mm() whenever the TLB is in LAZY state. Both these paths will be
> improved with this change.
> 
> Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
> 

Looks great to me.  Linus, do you want this one later in the window if
it tests out OK between now and then, or is it too late?

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

