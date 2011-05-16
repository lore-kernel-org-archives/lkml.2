Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755828Ab1EPUfU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 16:35:20 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:49147 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755680Ab1EPUfS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 16:35:18 -0400
Subject: Re: [PATCH 1/3] comm: Introduce comm_lock seqlock to protect
 task->comm access
From: John Stultz <john.stultz@linaro.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, "Ted Ts'o" <tytso@mit.edu>,
        David Rientjes <rientjes@google.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
In-Reply-To: <BANLkTin_MitzRUkWToj055AuAPdMC9msXQ@mail.gmail.com>
References: <1305241371-25276-1-git-send-email-john.stultz@linaro.org>
	 <1305241371-25276-2-git-send-email-john.stultz@linaro.org>
	 <4DCD1256.4070808@jp.fujitsu.com> <1305311276.2680.34.camel@work-vm>
	 <BANLkTin_MitzRUkWToj055AuAPdMC9msXQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 16 May 2011 13:34:54 -0700
Message-ID: <1305578094.2915.53.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-05-14 at 20:12 +0900, KOSAKI Motohiro wrote:
> >> Can you please explain why we should use seqlock? That said,
> >> we didn't use seqlock for /proc items. because, plenty seqlock
> >> write may makes readers busy wait. Then, if we don't have another
> >> protection, we give the local DoS attack way to attackers.
> >
> > So you're saying that heavy write contention can cause reader
> > starvation?
> 
> Yes.
> 
> >> task->comm is used for very fundamentally. then, I doubt we can
> >> assume write is enough rare. Why can't we use normal spinlock?
> >
> > I think writes are likely to be fairly rare. Tasks can only name
> > themselves or sibling threads, so I'm not sure I see the risk here.
> 
> reader starvation may cause another task's starvation if reader have
> an another lock.

So the risk is a thread rewriting its own comm over and over could
starve some other critical task trying to read the comm.

Ok. It makes it a little more costly, but fair enough.

thanks
-john




