Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752155Ab1I0RCQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 13:02:16 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:33157 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751450Ab1I0RCO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 13:02:14 -0400
Date: Tue, 27 Sep 2011 17:58:07 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Huajun Li <huajun.li.lee@gmail.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
        Christoph Lameter <cl@linux-foundation.org>
Subject: Re: Question about memory leak detector giving false positive
 report for net/core/flow.c
Message-ID: <20110927165807.GM14237@e102109-lin.cambridge.arm.com>
References: <CA+v9cxadZzWr35Q9RFzVgk_NZsbZ8PkVLJNxjBAMpargW9Lm4Q@mail.gmail.com>
 <1317054774.6363.9.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
 <20110926165024.GA21617@e102109-lin.cambridge.arm.com>
 <1317066395.2796.11.camel@edumazet-laptop>
 <CA+v9cxYzWJScCa2mMoEovq3WULSZYQaq6EjoRV7SQUjr0L_RiQ@mail.gmail.com>
 <1317102918.2796.22.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317102918.2796.22.camel@edumazet-laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 27, 2011 at 06:55:18AM +0100, Eric Dumazet wrote:
> Yes, it was not a patch, but the general idea for Catalin ;)
> 
> You hit the fact that same zone (embedded percpu space) is now in a
> mixed state.
> 
> In current kernels, the embedded percpu zone is already known by
> kmemleak, but with a large granularity. kmemleak is not aware of
> individual allocations/freeing in this large zone.
> 
> Once kmemleak and percpu allocator are cooperating, we might find more
> kmemleaks. Right now, kmemleak can find pointers in percpu chunks that
> are not anymore reachable (they were freed), and therefore doesnt warn
> of possible memory leaks.

Thanks for suggestions. I need to understand the percpu code a bit
better as it looks that kmemleak is told about some memory blocks twice.

-- 
Catalin
