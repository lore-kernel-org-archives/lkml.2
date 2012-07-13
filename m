Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756997Ab2GMJnI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 05:43:08 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:39980 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756920Ab2GMJnF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 05:43:05 -0400
Date: Fri, 13 Jul 2012 10:42:32 +0100
From: Will Deacon <will.deacon@arm.com>
To: shan kang <kangshan0910@gmail.com>
Cc: Li Haifeng <omycle@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: ARM: why smp_mb() is not needed in the "__mutex_fastpath_lock"
 and "__mutex_fastpath_unlock" functions
Message-ID: <20120713094232.GD18079@mudshark.cambridge.arm.com>
References: <CAK2TD5ygowdy9t1TpfxAPbpvNQfMnMB-3Zp8TKMsTYtBZdGW=Q@mail.gmail.com>
 <CAFNq8R6dNb0BrDVZScJ8s=P3B-OMgtr8tUdy8XqQcCAeUWuH+A@mail.gmail.com>
 <CAK2TD5z2DticZAQ-Pxzo7YT9tx=YWZkwcn-YZJ3aQa4AFoE_Cw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK2TD5z2DticZAQ-Pxzo7YT9tx=YWZkwcn-YZJ3aQa4AFoE_Cw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 13, 2012 at 10:10:52AM +0100, shan kang wrote:
> For example, in the following scenario, Process2  may get the wrong value;
> Process1:
> mutex_lock(&lock);
> write data; (store operation)
> mutex_unlock(&lock);
> 
> Process2:
> mutex_lock(&lock);
> read data; (load operation)
> mutex_unlock(&lock);

Yes, it looks like we can screw things up in the uncontended case (where
nobody blocks on the mutex). We could add an smp_mb after the lock operation
and another one before the unlock, but I'm tempted just to use
asm-generic/mutex-dec.h instead. The latter approach will subtly change the
current behaviour, so I'll post a patch when I'm happy with it.

Curious: did you find this by inspection or did you observe it going wrong?

Cheers,

Will
