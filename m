Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753333Ab0K0Suh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Nov 2010 13:50:37 -0500
Received: from mx2.fusionio.com ([64.244.102.31]:43385 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752130Ab0K0Sue (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Nov 2010 13:50:34 -0500
X-ASG-Debug-ID: 1290883832-085313b00001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4CF152F4.6060400@fusionio.com>
Date: Sat, 27 Nov 2010 19:50:28 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Christoph Hellwig <hch@lst.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHSET] backing-dev: replace private thread pool with   workqueue
References: <1283777182-11426-1-git-send-email-tj@kernel.org> <20100907121608.GA26597@lst.de> <4C862DDC.6010702@kernel.org> <4C86303A.90601@fusionio.com> <4C8631BE.9030709@kernel.org> <4CF12BAB.3000704@kernel.org>
X-ASG-Orig-Subj: Re: [PATCHSET] backing-dev: replace private thread pool with   workqueue
In-Reply-To: <4CF12BAB.3000704@kernel.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1290883832
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.47849
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-11-27 17:02, Tejun Heo wrote:
> On 09/07/2010 02:36 PM, Tejun Heo wrote:
>> Hello,
>>
>> On 09/07/2010 02:29 PM, Jens Axboe wrote:
>>> I agree (with both of you). It's definitely too early to convert it
>>> over, but if we can in the longer run, it never hurts to get rid of
>>> code. The writeback threads aren't a typical threadpool, in that the
>>> threads stick around and only go away when idle for too long. If they
>>> stick around, you get the same process hammering IO at your device. So
>>> converting that over to the generic cwq may or may not be at a
>>> performance cost, it'll definitely have to be tested.
>>
>> One thing to try is removing WQ_UNBOUND and see how it affects the
>> performance.  I put WQ_UNBOUND there mainly to keep the behavior about
>> the same as the current code but given what it does I think it would
>> probably fare better with workers bound to CPUs.
> 
> cmwq now seems pretty solid.  There hasn't been any noticeable failure
> yet.  I think we can move on with this conversion now.  Shall I
> refresh the patchset against the current block tree?

I'd still prefer to wait a while. The writeback code is still very much
a moving target, so I don't think mixing in a different work queue
scheme is likely going to do anyone any good at this point in time.

-- 
Jens Axboe

