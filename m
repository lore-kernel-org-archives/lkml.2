Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756150Ab1E0URQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 16:17:16 -0400
Received: from mx1.fusionio.com ([66.114.96.30]:40993 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753674Ab1E0URP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 16:17:15 -0400
X-ASG-Debug-ID: 1306527434-03d6a512a914ea0001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4DE006C5.4010906@fusionio.com>
Date: Fri, 27 May 2011 22:17:09 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Namhyung Kim <namhyung@gmail.com>
CC: Mike Snitzer <snitzer@redhat.com>, Christoph Hellwig <hch@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 1/2] blktrace: treat flush as barrier
References: <1306501883-23498-1-git-send-email-namhyung@gmail.com>	 <20110527131237.GA27647@infradead.org>	 <BANLkTi=8jQPdBNJYfM=geuXFsAXJJgfq=Q@mail.gmail.com> <1306509182.1351.1.camel@leonhard>
X-ASG-Orig-Subj: Re: [PATCH 1/2] blktrace: treat flush as barrier
In-Reply-To: <1306509182.1351.1.camel@leonhard>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1306527434
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.64844
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-05-27 17:13, Namhyung Kim wrote:
> 2011-05-27 (금), 09:57 -0400, Mike Snitzer:
>> On Fri, May 27, 2011 at 9:12 AM, Christoph Hellwig <hch@infradead.org> wrote:
>>> On Fri, May 27, 2011 at 10:11:22PM +0900, Namhyung Kim wrote:
>>>> Since BARRIER requests have been converted to FLUSH/FUA, it would be
>>>> better for blktrace to recognize FLUSH requests as BARRIER for the
>>>> backward-compatibility IMHO.
>>>
>>> I'd rather see new flags for them.  F and U maybe?
>>
>> Somehow I'm not surprised by your F and U suggestion -- appropriate on
>> multiple levels :)
> 
> OK. I'll work on that direction.
> Thanks.

Agree on Christophs comments, we should not pretend they are the same
(since they are not). Since flush is a request on its own, F works
nicely. For FUA it's associated with a write, so F should work there too
indicating Write Fua (and easily humanly parsed as that, or Write
Flush). WU would look confusing.

-- 
Jens Axboe

