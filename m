Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755797Ab1HWTBt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 15:01:49 -0400
Received: from smtp103.prem.mail.ac4.yahoo.com ([76.13.13.42]:32993 "HELO
	smtp103.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755102Ab1HWTBn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 15:01:43 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: XLMDdbcVM1ltcpkuTup3pyjUyhbdRFSs2n1xIpDGCVmLRWN
 QwEpyuUwVg8vBqqDUjd4nd8B8krz5WlikVIuVoO8O2jLFbNc6PE_YRnjBbGD
 oe3AHCLHtx_X_X6o2xIHDlT46mKfA_0CF0JbkdJBrA4soiPG.uTQu92hdcyt
 .KY7T0gDAoGY89aY95npgSjB7uCEg0yz9CDQw.bBLdZtyA5v.nvYwicuswGN
 hpqmq06RlK_3nRryMJ13YgPTtRZg60w3D19aXNWMl5kaKyiKz864Ggdotu3K
 EhoDg6eJpZdHXsCe2vDsjVv0Cr33zCYE8mN473z9ZP62duNuljit1Sr.vdNR
 dg0VDjD1kxEhnzosd9eDtvkOJmvz93f0uwJ5lXIeEfJ9i1A--
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Tue, 23 Aug 2011 14:01:38 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Jeremy Fitzhardinge <jeremy@goop.org>
cc: "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@kernel.dk>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH 13/15] x86: add cmpxchg_flag() variant
In-Reply-To: <738d736ecffa3bd32df76ae41188aa39c2ace941.1314054734.git.jeremy.fitzhardinge@citrix.com>
Message-ID: <alpine.DEB.2.00.1108231355380.26421@router.home>
References: <cover.1314045780.git.jeremy.fitzhardinge@citrix.com> <738d736ecffa3bd32df76ae41188aa39c2ace941.1314054734.git.jeremy.fitzhardinge@citrix.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Aug 2011, Jeremy Fitzhardinge wrote:

> Most callers of cmpxchg() direcly compare RETURN with OLD to see if it was
> successful.  This results in unnecessary conditional comparisons
> and conditionals since the cmpxchg instruction directly sets the flags
> to indicate success/failure.

> Add cmpxchg_flag() variants which return a boolean flag directly indicating
> success.  Unfortunately an asm() statement can't directly export status
> status flags, but sete isn't too bad.

And so what happens through this patch is that a cmp with a value that is
likely in a register is replaced by a sete. Is there really a benefit?

What I wish we would have is the actual use of the processor flag.

if (cmpxchg_flags(....)) {
}

where the cmpxchg is followed immediately by a jump. I tried in the past
to pass a goto label to cmpxchg but that did not work.



