Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756777Ab1EaOnN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 10:43:13 -0400
Received: from mx2.fusionio.com ([66.114.96.31]:56808 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750932Ab1EaOnM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 10:43:12 -0400
X-ASG-Debug-ID: 1306852990-01de280c1e0dd90001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4DE4FE7C.7000903@fusionio.com>
Date: Tue, 31 May 2011 16:43:08 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: "Martin K. Petersen" <martin.petersen@oracle.com>
CC: Mike Snitzer <snitzer@redhat.com>, "msb@chromium.org" <msb@chromium.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [PATCH 2/3] block: Move non-rotational flag to queue limits
References: <4DDEA689.2090004@fusionio.com>	<1306464169-4291-1-git-send-email-martin.petersen@oracle.com>	<1306464169-4291-3-git-send-email-martin.petersen@oracle.com>	<20110527130248.GA17219@redhat.com>	<yq1k4d7zk56.fsf@sermon.lab.mkp.net> <4DE4E9A6.8060006@fusionio.com> <yq1d3izx7v2.fsf@sermon.lab.mkp.net>
X-ASG-Orig-Subj: Re: [PATCH 2/3] block: Move non-rotational flag to queue limits
In-Reply-To: <yq1d3izx7v2.fsf@sermon.lab.mkp.net>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1306852990
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.65206
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-05-31 16:28, Martin K. Petersen wrote:
>>>>>> "Jens" == Jens Axboe <jaxboe@fusionio.com> writes:
> 
> Jens> On 2011-05-31 04:19, Martin K. Petersen wrote:
>>> - queue_flag_set_unlocked(QUEUE_FLAG_NONROT, disk->queue);
>>> + blk_queue_non_rotational(queue);
> 
> Jens> I don't like this part of the change. Before it was immediately
> Jens> apparently that we were setting this flag, know you have no idea
> Jens> what it does. Please make that blk_queue_set_non_rotational().
> 
> I was just trying to mimic the rest of the topology calls.
> 
> How about:
> 
>   blk_queue_rotational(q, BLK_QUEUE_ROTATIONAL|BLK_QUEUE_NON_ROTATIONAL)
> 
> Doing it that way would make the code clearer a few places too, I
> think...

I prefer having the function names be descriptive instead, but
consistency is good as well. The problem with the above approach is that
it usually requires defines to match, otherwise you don't know what the
arguments do. So lets rather fix up the other names for the next kernel.

-- 
Jens Axboe

