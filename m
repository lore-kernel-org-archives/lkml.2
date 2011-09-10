Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752673Ab1IJXci (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Sep 2011 19:32:38 -0400
Received: from mail-gw0-f42.google.com ([74.125.83.42]:41995 "EHLO
	mail-gw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765Ab1IJXch (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Sep 2011 19:32:37 -0400
Date: Sun, 11 Sep 2011 08:32:29 +0900
From: Tejun Heo <tj@kernel.org>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
        dvlasenk@redhat.com, Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 1/2] ptrace: don't modify flags on PTRACE_SETOPTIONS
 failure
Message-ID: <20110910233229.GB29319@htj.dyndns.org>
References: <201109090822.30063.vda.linux@googlemail.com>
 <201109090824.37366.vda.linux@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201109090824.37366.vda.linux@googlemail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 09, 2011 at 08:24:37AM +0200, Denys Vlasenko wrote:
> ptrace: don't modify flags on PTRACE_SETOPTIONS failure
> 
> On ptrace(PTRACE_SETOPTIONS, pid, 0, <opts>), we used to set
> those option bits which are known, and then fail with -EINVAL
> if there are some unknown bits in <opts>.
> 
> This in inconsistent with typical error handling, which
> does not change any state if input is invalid.
> 
> This patch changes PTRACE_SETOPTIONS behavior so that
> in this case, we return -EINVAL and don't change any bits
> in task->ptrace.
> 
> It's very unlikely that there is userspace code in the wild which
> will be affected by this change: it should have the form
> 
>     ptrace(PTRACE_SETOPTIONS, pid, 0, PTRACE_O_BOGUSOPT)
> 
> where PTRACE_O_BOGUSOPT is a constant unknown to the kernel.
> But kernel headers, naturally, don't contain any
> PTRACE_O_BOGUSOPTs, thus the only way userspace can use one
> if it defines one itself. I can't see why anyone would do such
> a thing deliberately.
> 
> Signed-off-by: Denys Vlasenko <dvlasenk@redhat.com>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
