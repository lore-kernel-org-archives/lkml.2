Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754496Ab1EaKhR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 06:37:17 -0400
Received: from mx1.fusionio.com ([66.114.96.30]:42494 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753069Ab1EaKhP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 06:37:15 -0400
X-ASG-Debug-ID: 1306838234-03d6a512ab20c40001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4DE4C4D7.9060107@fusionio.com>
Date: Tue, 31 May 2011 12:37:11 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Namhyung Kim <namhyung@gmail.com>
CC: Christoph Hellwig <hch@infradead.org>, Mike Snitzer <snitzer@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 1/2] blktrace: treat flush as barrier
References: <1306501883-23498-1-git-send-email-namhyung@gmail.com>	 <20110527131237.GA27647@infradead.org>	 <BANLkTi=8jQPdBNJYfM=geuXFsAXJJgfq=Q@mail.gmail.com>	 <1306509182.1351.1.camel@leonhard> <4DE006C5.4010906@fusionio.com>	 <20110527202747.GA4803@infradead.org> <1306548581.1679.12.camel@leonhard>
X-ASG-Orig-Subj: Re: [PATCH 1/2] blktrace: treat flush as barrier
In-Reply-To: <1306548581.1679.12.camel@leonhard>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1306838234
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.65189
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-05-28 04:09, Namhyung Kim wrote:
> 2011-05-27 (금), 16:27 -0400, Christoph Hellwig:
>> On Fri, May 27, 2011 at 10:17:09PM +0200, Jens Axboe wrote:
>>> Agree on Christophs comments, we should not pretend they are the same
>>> (since they are not). Since flush is a request on its own, F works
>>> nicely. For FUA it's associated with a write, so F should work there too
>>> indicating Write Fua (and easily humanly parsed as that, or Write
>>> Flush). WU would look confusing.
>>
>> REQ_FLUSH can also be set on a write bio, it only gets split at the
>> request level.  And even there we're at least pondering allowing it
>> to stay as part of the write for some paravirtualized storage protocols.
>>
> 
> Hi,
> 
> AFAIK FLUSH always precedes WRITE and then followed by FUA, so how about
> using the same F for both of them and distinguishing by position?
> 
>  - WRITE:            W
>  - WRITE_FLUSH:      FW
>  - WRITE_FUA:        WF
>  - WRITE_FLUSH_FUA:  FWF

That looks fine. 'U' would be an illogical choice.

-- 
Jens Axboe

