Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933509Ab1FBLJ0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 07:09:26 -0400
Received: from mx1.fusionio.com ([66.114.96.30]:52921 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751376Ab1FBLJZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 07:09:25 -0400
X-ASG-Debug-ID: 1307012964-03d6a512a83f4a0001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4DE76F61.7060409@fusionio.com>
Date: Thu, 2 Jun 2011 13:09:21 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Jeff Moyer <jmoyer@redhat.com>
CC: "vgoyal@redhat.com" <vgoyal@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [patch] iosched: prevent aliased requests from starving other
 I/O
References: <x49tyc9y12s.fsf@segfault.boston.devel.redhat.com> <4DE76F02.1090306@fusionio.com>
X-ASG-Orig-Subj: Re: [patch] iosched: prevent aliased requests from starving other
 I/O
In-Reply-To: <4DE76F02.1090306@fusionio.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1307012964
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.12
X-Barracuda-Spam-Status: No, SCORE=0.12 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=CN_BODY_332
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.65382
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
	0.12 CN_BODY_332            BODY: CN_BODY_332
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-06-02 13:07, Jens Axboe wrote:
> On 2011-06-01 18:21, Jeff Moyer wrote:
>> Hi, Jens,
>>
>> If you recall, I posted an RFC patch for this back in July of last year:
>> http://lkml.org/lkml/2010/7/13/279
>>
>> The basic problem is that a process can issue a never-ending stream of
>> async direct I/Os to the same sector on a device, thus starving out
>> other I/O in the system (due to the way the alias handling works in both
>> cfq and deadline).  The solution I proposed back then was to start
>> dispatching from the fifo after a certain number of aliases had been
>> dispatched.  Vivek asked why we had to treat aliases differently at all,
>> and I never had a good answer.  So, I put together a simple patch which
>> allows aliases to be added to the rb tree (it adds them to the right,
>> though that doesn't matter as the order isn't guaranteed anyway).  I
>> think this is the preferred solution, as it doesn't break up time slices
>> in CFQ or batches in deadline.  I've tested it, and it does solve the
>> starvation issue.  Let me know what you think.
> 
> That'll work, there's no inherent reason why we can't have aliases
> directly in the rbtree as long as the sort insert factors that into
> account.
> 
> I will queue this one up for 3.1.

Jeff, care to resend a "proper" patch (signed-off and so forth)?

-- 
Jens Axboe

