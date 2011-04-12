Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756710Ab1DLGUs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 02:20:48 -0400
Received: from mx2.fusionio.com ([64.244.102.31]:56759 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756568Ab1DLGUq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 02:20:46 -0400
X-ASG-Debug-ID: 1302589243-01de284cf81322b0001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4DA3EF3B.9080804@fusionio.com>
Date: Tue, 12 Apr 2011 08:20:43 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: "hch@infradead.org" <hch@infradead.org>
CC: NeilBrown <neilb@suse.de>, Mike Snitzer <snitzer@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Subject: Re: [PATCH 05/10] block: remove per-queue plugging
References: <20110308202100.GA31744@redhat.com> <4D76912C.9040705@fusionio.com> <20110308220526.GA393@redhat.com> <20110310005810.GA17911@redhat.com> <20110405130541.6c2b5f86@notabene.brown> <20110411145022.710c30e9@notabene.brown> <4DA2C7BE.6060804@fusionio.com> <20110411205928.13915719@notabene.brown> <20110411215521.78c87573@notabene.brown> <4DA2F02D.2000903@fusionio.com> <20110411225812.GA32310@infradead.org>
X-ASG-Orig-Subj: Re: [PATCH 05/10] block: remove per-queue plugging
In-Reply-To: <20110411225812.GA32310@infradead.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1302589243
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.60613
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-04-12 00:58, hch@infradead.org wrote:
> Looking at the patch
> (http://git.kernel.dk/?p=linux-2.6-block.git;a=commitdiff;h=761e433f3de6fb8e369af9e5c08beb86286d023f)
> 
> I'm not sure it's an optimal design.  The flush callback really
> is a per-queue thing.  Why isn't it a function pointer in the request
> queue when doing the blk_run_queue call once we're done with a given
> queue before moving on to the next one?

I was thinking about this yesterday as well, the design didn't quite
feel just right. Additionally the user now must track this state too,
and whether he's plugged on that task or not.

I'll rewrite this.

-- 
Jens Axboe

