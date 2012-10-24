Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935437Ab2JXSI1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 14:08:27 -0400
Received: from www.linutronix.de ([62.245.132.108]:52531 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935380Ab2JXSIZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 14:08:25 -0400
Date: Wed, 24 Oct 2012 20:08:18 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Siddhesh Poyarekar <siddhesh.poyarekar@gmail.com>
cc: Darren Hart <dvhart@linux.intel.com>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] [RESEND 2] Take over futex of dead task only if
 FUTEX_WAITERS is not set
In-Reply-To: <CAAHN_R0jTey+4TOXfKh96aApOPUXQq6wwobejmhFeRuTV2VJKA@mail.gmail.com>
Message-ID: <alpine.LFD.2.02.1210242006450.2756@ionos>
References: <CAAHN_R1O3asyJGXqjs5qt0b_qGR6S6RuM+E_85VaEoWAyAMheQ@mail.gmail.com> <1350876034-22023-1-git-send-email-siddhesh.poyarekar@gmail.com> <5086A3D1.7080709@linux.intel.com> <alpine.LFD.2.02.1210232138540.2756@ionos>
 <CAAHN_R0jTey+4TOXfKh96aApOPUXQq6wwobejmhFeRuTV2VJKA@mail.gmail.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Oct 2012, Siddhesh Poyarekar wrote:

> > Now there is a different solution to that problem. Do not look at the
> > user space value at all and enforce a lookup of possibly available
> > pi_state. If pi_state can be found, then the new incoming locker T3
> > blocks on that pi_state and legitimately races with T2 to acquire the
> > rt_mutex and the pi_state and therefor the proper ownership of the
> > user space futex.
> 
> That works. Thanks for the detailed explanation too.

Thanks for the reproducer and finding the trouble spot in the first
place!

I'll queue that if Darren has no objections and mark it for stable as
well.

Thanks,

	tglx
