Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753047Ab1IAKLO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 06:11:14 -0400
Received: from www.linutronix.de ([62.245.132.108]:36255 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750787Ab1IAKLL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 06:11:11 -0400
Date: Thu, 1 Sep 2011 12:11:03 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Shan Hai <haishan.bai@gmail.com>
cc: akpm@linux-foundation.org, eric.dumazet@gmail.com, vapier@gentoo.org,
        asharma@fb.com, linux-kernel@vger.kernel.org,
        linux-rt-users@vger.kernel.org
Subject: Re: [PATCH V2 1/1] lib/atomic64 using raw_spin_lock_irq[save|resotre]
 for atomicity
In-Reply-To: <alpine.LFD.2.02.1109011158500.2723@ionos>
Message-ID: <alpine.LFD.2.02.1109011209000.2723@ionos>
References: <1314847923-26428-1-git-send-email-haishan.bai@gmail.com> <1314847923-26428-2-git-send-email-haishan.bai@gmail.com> <alpine.LFD.2.02.1109011158500.2723@ionos>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Sep 2011, Thomas Gleixner wrote:

> On Thu, 1 Sep 2011, Shan Hai wrote:
> 
> > The spin_lock_irq[save|restore] could break the atomicity of the
> > atomic64_* operations in the PREEMPT-RT configuration, because
> > the spin_lock_irq[save|restore] themselves are preemptable in the
> > PREEMPT-RT, using raw variant of the spin lock could provide the
> > atomicity that atomic64_* need.
> 
> Good catch. Queued for the next release.

Though the changelog is misleading. The reason is not that they are
preemtible. 

The reason for your OOPs is that the sleeping locks are not IRQ
safe. And your system simply deadlocked due to that.

Thanks,

	tglx
