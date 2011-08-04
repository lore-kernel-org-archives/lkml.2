Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753127Ab1HDJBY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 05:01:24 -0400
Received: from mx1.fusionio.com ([66.114.96.30]:56581 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751796Ab1HDJBT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 05:01:19 -0400
X-ASG-Debug-ID: 1312448478-03d6a510a9248860001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4E3A5FDD.2010004@fusionio.com>
Date: Thu, 4 Aug 2011 11:01:17 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
CC: Shaohua Li <shli@kernel.org>, Vivek Goyal <vgoyal@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: fio posixaio performance problem
References: <4E38C314.8070305@cn.fujitsu.com> <CANejiEViuKky1A7Xh0MQKBVNMj_fgzwayWyON7hFGfP3wa62SQ@mail.gmail.com> <4E3902C7.9050907@cn.fujitsu.com> <CANejiEVqFt4j1-qTVnxEAe75z0y010s=ST2XtCDDTqDEQT=EcQ@mail.gmail.com> <4E391986.90108@cn.fujitsu.com> <20110803154533.GB32385@redhat.com> <20110803175101.GC32385@redhat.com> <CANejiEXAtzExExqmTXA=hmpGh8DVVo9ncbRMdkB+avq+G3LuqQ@mail.gmail.com> <4E39FD41.4090103@cn.fujitsu.com> <CANejiEVh4hvi5S18H7XHihxZt+JcRU7W5MGpQwQc_ZtiFCa2jw@mail.gmail.com> <4E3A4DF7.3020605@cn.fujitsu.com> <CANejiEXkv75kVxTS2w-v2GHZZRdmOR8HXUY16-eas9M45ZKqKg@mail.gmail.com> <4E3A59DD.6010907@cn.fujitsu.com>
X-ASG-Orig-Subj: Re: fio posixaio performance problem
In-Reply-To: <4E3A59DD.6010907@cn.fujitsu.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1312448478
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.70866
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-08-04 10:35, Gui Jianfeng wrote:
>> looks the system does a write in every 8ms. This is quite wrong. does
>> the posixaio
>> engine have something wrong? can you use a new fio or try libaio please.
> 
> Yes, I also highly suspect that fio's posixaio engine works bad.
> On the other hand, I'm not sure why preempting in cfqs doesn't happen.
> It seems requests from different threads is close enough...

Can't be ruled out that there's a bug in the posixaio engine. It's
perhaps 100 lines of interesting code in there, so should be easy enough
to audit. Unless it's an interaction with the fio core of course.

Since you're using a queue depth of 1, every getevents call would end up
in aio_suspend() waiting for the previously submitted one. That should
interleave just fine with the other threads, though.

-- 
Jens Axboe

