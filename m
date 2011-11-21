Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754793Ab1KUVK5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 16:10:57 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:42248 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752787Ab1KUVK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 16:10:56 -0500
Date: Mon, 21 Nov 2011 13:10:50 -0800
From: Tejun Heo <tj@kernel.org>
To: Dave Young <dyoung@redhat.com>
Cc: tim@edgecast.com, WANG Cong <xiyou.wangcong@gmail.com>,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] percpu: fix chunk range calculation
Message-ID: <20111121211050.GK25776@google.com>
References: <1321467647.2137.4.camel@boudreau>
 <4EC47FCA.5090908@redhat.com>
 <CAOS58YMOuJrvGxE1VxsU=ZPTLgY60HDJoLFjTowx9ZApUQ3tTw@mail.gmail.com>
 <4EC491B3.705@redhat.com>
 <CAMMEr5k_ynqg5-7Looar2DxXTGZcMqi5Lo+jtETn9awO_bsaGg@mail.gmail.com>
 <4EC4B60C.3030706@redhat.com>
 <1321548033.12208.12.camel@boudreau>
 <4EC61AB6.4090808@redhat.com>
 <4EC61B2A.7010000@redhat.com>
 <20111118185535.GA27152@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111118185535.GA27152@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 18, 2011 at 10:55:35AM -0800, Tejun Heo wrote:
> Percpu allocator recorded the cpus which map to the first and last
> units in pcpu_first/last_unit_cpu respectively and used them to
> determine the address range of a chunk - e.g. it assumed that the
> first unit has the lowest address in a chunk while the last unit has
> the highest address.
> 
> This simply isn't true.  Groups in a chunk can have arbitrary positive
> or negative offsets from the previous one and there is no guarantee
> that the first unit occupies the lowest offset while the last one the
> highest.
> 
> Fix it by actually comparing unit offsets to determine cpus occupying
> the lowest and highest offsets.  Also, rename pcu_first/last_unit_cpu
> to pcpu_low/high_unit_cpu to avoid confusion.
> 
> The chunk address range is used to flush cache on vmalloc area
> map/unmap and decide whether a given address is in the first chunk by
> per_cpu_ptr_to_phys() and the bug was discovered by invalid
> per_cpu_ptr_to_phys() translation for crash_note.
> 
> Kudos to Dave Young for tracking down the problem.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Reported-by: WANG Cong <xiyou.wangcong@gmail.com>
> Reported-by: Dave Young <dyoung@redhat.com>
> LKML-Reference: <4EC21F67.10905@redhat.com>
> Cc: stable @kernel.org

BTW, waiting for Tested-by.  If someone gives me that, I'll push it
through percpu/for-fixes.

Thanks.

-- 
tejun
