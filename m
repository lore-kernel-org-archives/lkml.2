Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753863Ab1DRJrr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 05:47:47 -0400
Received: from mx1.fusionio.com ([64.244.102.30]:59885 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752101Ab1DRJrk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 05:47:40 -0400
X-ASG-Debug-ID: 1303120059-03d6a569fbc8d00001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4DAC08BB.6060202@fusionio.com>
Date: Mon, 18 Apr 2011 11:47:39 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Hannes Reinecke <hare@suse.de>
CC: device-mapper development <dm-devel@redhat.com>,
        "hch@infradead.org" <hch@infradead.org>,
        "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
        Mike Snitzer <snitzer@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alasdair G Kergon <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH 05/10] block: remove per-queue plugging
References: <20110411205928.13915719@notabene.brown>	<4DA2E03A.2080607@fusionio.com>	<20110411212635.7959de70@notabene.brown>	<4DA2E7F0.9010904@fusionio.com>	<20110411220505.1028816e@notabene.brown>	<4DA2F00E.6010907@fusionio.com>	<20110418081922.1651474a@notabene.brown>	<4DABDC60.2090009@fusionio.com>	<20110418172551.55629fc6@notabene.brown>	<4DABF1EA.3070301@fusionio.com> <20110418091959.GA32013@infradead.org> <4DAC070C.6010403@suse.de>
X-ASG-Orig-Subj: Re: [dm-devel] [PATCH 05/10] block: remove per-queue plugging
In-Reply-To: <4DAC070C.6010403@suse.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1303120059
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.61202
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-04-18 11:40, Hannes Reinecke wrote:
> On 04/18/2011 11:19 AM, hch@infradead.org wrote:
>> Btw, I really start to wonder if the request level is the right place
>> to do this on-stack plugging.  Wouldn't it be better to just plug
>> bios in the on-stack queue?  That way we could also stop doing the
>> special case merging when adding to the plug list, and leave all the
>> merging / I/O schedule logic in the __make_request path.  Probably
>> not .39 material, but worth a prototype?
>>
>> Also what this dicussion brought up is that the block layer data
>> structures are highly confusing.  Using a small subset of the
>> request_queue also for make_request based driver just doesn't make
>> sense.  It seems like we should try to migrate the required state
>> to struct gendisk, and submit I/O through a block_device_ops.submit
>> method, leaving the request_queue as an internal abstraction for
>> the request based drivers.
>>
> Good point.
> It would also help us we the device-mapper redesign agk and myself 
> discussed at LSF. Having a block_device_ops.submit function would
> allow us remap the actual request queue generically; and we would 
> even be able to address more than one request queue, which sounds 
> awfully similar to what Jens is trying to do ...

The multiqueue bits would still have one request_queue, but multiple
queueing structures (I called those blk_queue_ctx, iirc).

-- 
Jens Axboe

