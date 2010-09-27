Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760372Ab0I0Wry (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 18:47:54 -0400
Received: from mx1.fusionio.com ([64.244.102.30]:36561 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756891Ab0I0Wrx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 18:47:53 -0400
X-ASG-Debug-ID: 1285627672-0e128b680001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4CA11F15.9020303@fusionio.com>
Date: Tue, 28 Sep 2010 07:47:49 +0900
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
        "jmoyer@redhat.com" <jmoyer@redhat.com>,
        Lennart Poettering <lennart@poettering.net>
Subject: Re: Request starvation with CFQ
References: <20100927190024.GF3610@quack.suse.cz> <20100927200232.GA2377@redhat.com> <4CA114F8.8000102@fusionio.com> <20100927223701.GF2377@redhat.com>
X-ASG-Orig-Subj: Re: Request starvation with CFQ
In-Reply-To: <20100927223701.GF2377@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1285627672
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Bayes: INNOCENT GLOBAL 0.0489 1.0000 -1.7069
X-Barracuda-Spam-Score: -1.71
X-Barracuda-Spam-Status: No, SCORE=-1.71 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.42080
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-09-28 07:37, Vivek Goyal wrote:
>> patches I ripped that out. The vm copes a lot better with larger depths
>> these days, so what I want to add is just a per-ioc queue limit instead.
> 
> Will you get rid of nr_requests altogether or will keep both nr_requests
> as well as per-ioc queue limits?

I was thinking that we'd keep it as a per-ioc limit.

> per-ioc queue limits will help that one io context can not monopolize the
> queue but IMHO, it does not protect against some program forking multiple
> threads and submitting bunch of IO (processes not sharing ioc).
> 
> But I guess that's a separate issue altogether. Per-ioc limit is at least
> one step forward.

So right now, if you do a driver that isn't request based, you get the
infinite queue depth already. Historically the vm didn't cope very well
with tons of dirty IO pending on the driver side, but it does a lot
better now. That said, I think we still need some sort of upper cap, but
it can be larger than what we have now and it needs to be checked
lazily. The current setup with have now with strict accounting on both
submission and completion is not a great thing for high IOPS devices.

-- 
Jens Axboe

