Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754223Ab1FBTUb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 15:20:31 -0400
Received: from mx2.fusionio.com ([66.114.96.31]:44677 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753857Ab1FBTUa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 15:20:30 -0400
X-ASG-Debug-ID: 1307042428-01de280c1e1b420001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4DE7E279.9040300@fusionio.com>
Date: Thu, 2 Jun 2011 21:20:25 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Jeff Moyer <jmoyer@redhat.com>
CC: "vgoyal@redhat.com" <vgoyal@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [patch/resend] iosched: prevent aliased requests from starving
  other I/O
References: <x49pqmwe5g0.fsf@segfault.boston.devel.redhat.com>
X-ASG-Orig-Subj: Re: [patch/resend] iosched: prevent aliased requests from starving
  other I/O
In-Reply-To: <x49pqmwe5g0.fsf@segfault.boston.devel.redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1307042428
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.65415
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-06-02 15:19, Jeff Moyer wrote:
> Hi, Jens,
> 
> If you recall, I posted an RFC patch for this back in July of last year:
> http://lkml.org/lkml/2010/7/13/279
> 
> The basic problem is that a process can issue a never-ending stream of
> async direct I/Os to the same sector on a device, thus starving out
> other I/O in the system (due to the way the alias handling works in both
> cfq and deadline).  The solution I proposed back then was to start
> dispatching from the fifo after a certain number of aliases had been
> dispatched.  Vivek asked why we had to treat aliases differently at all,
> and I never had a good answer.  So, I put together a simple patch which
> allows aliases to be added to the rb tree (it adds them to the right,
> though that doesn't matter as the order isn't guaranteed anyway).  I
> think this is the preferred solution, as it doesn't break up time slices
> in CFQ or batches in deadline.  I've tested it, and it does solve the
> starvation issue.  Let me know what you think.

Thanks Jeff, applied to for-3.1/core

-- 
Jens Axboe

