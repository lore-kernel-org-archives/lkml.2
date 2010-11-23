Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751667Ab0KWIuE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 03:50:04 -0500
Received: from mx2.fusionio.com ([64.244.102.31]:45976 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750953Ab0KWIuD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 03:50:03 -0500
X-ASG-Debug-ID: 1290502199-08b7e12f0001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4CEB8034.80400@fusionio.com>
Date: Tue, 23 Nov 2010 09:49:56 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Namhyung Kim <namhyung@gmail.com>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] generic-ipi: add lock context annotations
References: <1290411232-11439-1-git-send-email-namhyung@gmail.com>	 <1290430003.2072.101.camel@laptop> <1290482390.1857.26.camel@leonhard>
X-ASG-Orig-Subj: Re: [PATCH] generic-ipi: add lock context annotations
In-Reply-To: <1290482390.1857.26.camel@leonhard>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1290502199
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.60
X-Barracuda-Spam-Status: No, SCORE=0.60 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=MARKETING_SUBJECT
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.47441
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
	0.60 MARKETING_SUBJECT      Subject contains popular marketing words
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-11-23 04:19, Namhyung Kim wrote:
> 2010-11-22 (월), 13:46 +0100, Peter Zijlstra:
>> On Mon, 2010-11-22 at 16:33 +0900, Namhyung Kim wrote:
>>> The ipi_call_[un]lock[_irq] functions grab/release a spin lock
>>> but were missing proper annotations. Add it.
>>
>> I really have to ask why bother? Why not add some smarts to whatever
>> uses these annotations?
> 
> I just thought that removing bogus warnings from sparse helps us focus
> on real issues when using it. Currently sparse emits too many messages
> and some (many?) of them might be removed trivially (or by adding bit of
> ugliness. :( )

It's not too big a deal, I have no problem adding the annotation.

> BTW, I didn't get what you mean about "some smarts". Could you explain
> them little more?

I guess what Peter means is that the fact that the function grabs the
lock is apparent in the code, if sparse was a bit "smarter", it would
see and note this itself.

-- 
Jens Axboe

