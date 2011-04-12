Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755579Ab1DLRY3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 13:24:29 -0400
Received: from mx1.fusionio.com ([64.244.102.30]:41000 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753554Ab1DLRY2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 13:24:28 -0400
X-ASG-Debug-ID: 1302629067-03d6a5652c990b0001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4DA48AC5.30007@fusionio.com>
Date: Tue, 12 Apr 2011 19:24:21 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: "hch@infradead.org" <hch@infradead.org>
CC: Dave Chinner <david@fromorbit.com>, NeilBrown <neilb@suse.de>,
        Mike Snitzer <snitzer@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Subject: Re: [PATCH 05/10] block: remove per-queue plugging
References: <20110411223623.4278fad1@notabene.brown> <4DA2F8AD.1060605@fusionio.com> <20110412011255.GA29236@infradead.org> <4DA40F0E.1070903@fusionio.com> <20110412122248.GC31057@dastard> <4DA4456F.3070301@fusionio.com> <20110412124134.GD31057@dastard> <4DA44C86.3090305@fusionio.com> <20110412164417.GA13890@infradead.org> <4DA482B1.5000005@fusionio.com> <20110412165455.GB23764@infradead.org>
X-ASG-Orig-Subj: Re: [PATCH 05/10] block: remove per-queue plugging
In-Reply-To: <20110412165455.GB23764@infradead.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1302629067
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.60658
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-04-12 18:54, hch@infradead.org wrote:
> On Tue, Apr 12, 2011 at 06:49:53PM +0200, Jens Axboe wrote:
>> I realize that, in fact it's already safe as long as you pass in 'true'
>> for __blk_run_queue(). Before I had rewritten it to move the running
>> out, so that makes the trick a little difficult. This afternoon I also
>> tested it and saw no noticable difference, but I'll probably just do it
>> anyway as it makes sense.
> 
> We still need the lock for __elv_add_request, so we'll need to keep the
> logic anyway.  But splitting out the just queue to kblockd case from
> __blk_run_queue and giving the latter a sane prototype still sounds
> like a good idea to me.
> 
> Btw, now that we don't call the request_fn directly any more and thus
> can't block, can the unplugging be moved into the preempt notifiers?

It was only partly the reason, there's still the notice on preempt
(instead of schedule) and the runqueue lock problem. And if we allow
preempt, then we need to do disable preempt around all the plug logic.

-- 
Jens Axboe

