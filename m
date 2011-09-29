Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755420Ab1I2OWO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 10:22:14 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:55977 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753321Ab1I2OWN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 10:22:13 -0400
Date: Thu, 29 Sep 2011 15:18:10 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Christoph Lameter <cl@gentwo.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, Huajun Li <huajun.li.lee@gmail.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>
Subject: Re: Question about memory leak detector giving false positive
 report for net/core/flow.c
Message-ID: <20110929141809.GD32023@e102109-lin.cambridge.arm.com>
References: <CA+v9cxadZzWr35Q9RFzVgk_NZsbZ8PkVLJNxjBAMpargW9Lm4Q@mail.gmail.com>
 <1317054774.6363.9.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
 <20110926165024.GA21617@e102109-lin.cambridge.arm.com>
 <1317066395.2796.11.camel@edumazet-laptop>
 <20110928172342.GH23559@e102109-lin.cambridge.arm.com>
 <alpine.DEB.2.00.1109290907450.9382@router.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1109290907450.9382@router.home>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 29, 2011 at 03:08:47PM +0100, Christoph Lameter wrote:
> On Wed, 28 Sep 2011, Catalin Marinas wrote:
> 
> > I tried this but it's tricky. The problem is that the percpu pointer
> > returned by alloc_percpu() does not directly point to the per-cpu chunks
> > and kmemleak would report most percpu allocations as leaks. So far the
> > workaround is to simply mark the alloc_percpu() objects as never leaking
> > and at least we avoid false positives in other areas. See the patch
> > below (note that you have to increase the CONFIG_KMEMLEAK_EARLY_LOG_SIZE
> > as there are many alloc_percpu() calls before kmemleak is fully
> > initialised):
> 
> Seems that kernel.org is out and so tejon wont be seeing these.

That's ok, I don't aim this at the upcoming merging window. I don't have
an alternative email address for him.

-- 
Catalin
