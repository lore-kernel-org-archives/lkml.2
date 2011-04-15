Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752728Ab1DOGNY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 02:13:24 -0400
Received: from mx1.fusionio.com ([64.244.102.30]:33920 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751502Ab1DOGNX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 02:13:23 -0400
X-ASG-Debug-ID: 1302848002-03d6a569fbb7ad0001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4DA7E202.4000307@fusionio.com>
Date: Fri, 15 Apr 2011 08:13:22 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Michael Guntsche <mike@it-loops.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.39 Block layer regression was [Bug] Boot hangs with  2.6.39-rc[123]]
References: <20110415035451@it-loops.com> <BANLkTi=50A4f_d0a0oESd3DMMaK1za5BWg@mail.gmail.com> <20110415042255.GC27928@infradead.org>
X-ASG-Orig-Subj: Re: 2.6.39 Block layer regression was [Bug] Boot hangs with  2.6.39-rc[123]]
In-Reply-To: <20110415042255.GC27928@infradead.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1302848002
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.60900
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-04-15 06:22, Christoph Hellwig wrote:
> On Thu, Apr 14, 2011 at 08:25:33PM -0700, Linus Torvalds wrote:
>> What's the thinking there? It looks very confused to me.
> 
> It is.  I sent a patch a couple of days ago to fix it.

Yeah thanks for that, I agree it looks a bit confusing as-is. I'll queue
it up.

>> Now, clearly RAID seems to be involved in the problem? The main thing
>> with that would be that the execution of the requests would tend to
>> generate new requests, that go back on the plug queue. Yes? And the
>> loop in flush_plug_list() means that they all should get flushed out,
>> I assume. But something clearly isn't working, and it does seem to be
>> about the RAID kind of setup. So either they didn't get put on the
>> plug queue, or the task got a new plug (which _wasn't_ flushed).
>>
>> Because we're clearly waiting for some request that hasn't completed.
>> Where in the plug queues would it be hiding?
> 
> There's a thread where Neil explains what the problem with MD is - it
> needs a callback on unplug time to generate e.g. the write intent bitmap
> or as large as possible writes for RAID5.  Jens and Neil have been
> looking into it.

I think we are done, Neil just needs to rebase around the current
for-linus and then we should expedite things in.

-- 
Jens Axboe

