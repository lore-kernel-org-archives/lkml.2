Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756401Ab1CHU1c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 15:27:32 -0500
Received: from mx2.fusionio.com ([64.244.102.31]:60329 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752257Ab1CHU1b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 15:27:31 -0500
X-ASG-Debug-ID: 1299616049-01de284cf829880001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4D76912C.9040705@fusionio.com>
Date: Tue, 8 Mar 2011 21:27:24 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Mike Snitzer <snitzer@redhat.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hch@infradead.org" <hch@infradead.org>
Subject: Re: [PATCH 05/10] block: remove per-queue plugging
References: <1295659049-2688-1-git-send-email-jaxboe@fusionio.com> <1295659049-2688-6-git-send-email-jaxboe@fusionio.com> <AANLkTin8FoXX6oqUyW+scwhadyX-TfW16_oKjvngU9-m@mail.gmail.com> <20110303221353.GA10366@redhat.com> <4D761E0D.8050200@fusionio.com> <20110308202100.GA31744@redhat.com>
X-ASG-Orig-Subj: Re: [PATCH 05/10] block: remove per-queue plugging
In-Reply-To: <20110308202100.GA31744@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1299616049
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.57437
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-03-08 21:21, Mike Snitzer wrote:
> On Tue, Mar 08 2011 at  7:16am -0500,
> Jens Axboe <jaxboe@fusionio.com> wrote:
> 
>> On 2011-03-03 23:13, Mike Snitzer wrote:
>>> I'm now hitting a lockdep issue, while running a 'for-2.6.39/stack-plug'
>>> kernel, when I try an fsync heavy workload to a request-based mpath
>>> device (the kernel ultimately goes down in flames, I've yet to look at
>>> the crashdump I took)
>>
>> Mike, can you re-run with the current stack-plug branch? I've fixed the
>> !CONFIG_BLOCK and rebase issues, and also added a change for this flush
>> on schedule event. It's run outside of the runqueue lock now, so
>> hopefully that should solve this one.
> 
> Works for me, thanks.

Super, thanks! Out of curiousity, did you use dm/md?

-- 
Jens Axboe

