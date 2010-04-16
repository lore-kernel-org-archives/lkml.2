Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932809Ab0DPXld (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Apr 2010 19:41:33 -0400
Received: from gate.crashing.org ([63.228.1.57]:52842 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932799Ab0DPXla (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Apr 2010 19:41:30 -0400
Subject: Re: Possible bug with mutex adaptative spinning
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
In-Reply-To: <1271453251.1674.485.camel@laptop>
References: <1271212509.13059.135.camel@pasglop>
	 <1271213767.13059.137.camel@pasglop>  <1271453251.1674.485.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 17 Apr 2010 08:01:32 +1000
Message-ID: <1271455292.13059.198.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-04-16 at 23:27 +0200, Peter Zijlstra wrote:
> > If the owner is actually running, it may do so for a very long time. It
> > looks to me that everybody trying to take the mutex will thus spin and
> > never get out of the spin loop until the owner stops running.
> 
> The inner-most spin loop breaks out on need_resched():
> 
>                 if (task_thread_info(rq->curr) != owner || need_resched())
>                         return 0; 

You are right, this was only a problem in conjunction with the other bug
returning 1 all the time, causing us to ignore need_resched(). With
that fixed, it looks fine now.

Thanks !

Cheers,
Ben.


