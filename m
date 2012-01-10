Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752174Ab2AJFHH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 00:07:07 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:62671 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751768Ab2AJFHD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 00:07:03 -0500
X-AuditID: 9c930179-b7ba8ae00000598d-04-4f0bc770438a
Message-ID: <4F0BC770.1090702@lge.com>
Date: Tue, 10 Jan 2012 14:06:56 +0900
From: Namhyung Kim <namhyung.kim@lge.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Jens Axboe <axboe@kernel.dk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, namhyung@gmail.com
Subject: Re: [PATCH 1/2] block: introduce BIO_IN_FLIGHT flag
References: <1324996113-1837-1-git-send-email-namhyung@gmail.com> <1324996113-1837-2-git-send-email-namhyung@gmail.com> <20120109015628.GB16360@mtj.dyndns.org> <4F0A57A7.4070508@lge.com> <20120109164148.GB21732@google.com>
In-Reply-To: <20120109164148.GB21732@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2012-01-10 1:41 AM, Tejun Heo wrote:
> Hello,
>
> On Mon, Jan 09, 2012 at 11:57:43AM +0900, Namhyung Kim wrote:
>> I understand your concerns. However, the blktrace cannot get
>> bio->bi_flags info in its current form AFAIK. Doing it will require
>> extending struct blk_io_trace and it'll cause a compatibility issue,
>> I guess.
>
> Umm?  Why can't blk_add_trace_bio_complete() look at the flags (or
> whatever other states) to decide to fire off BLK_TA_COMPLETE or not?
> What's the difference?  No userland visible change is necessary at
> all.  Just make blktrace.c do the right thing.  Am I missing
> something?
>
> Thanks.
>

Oh I misunderstood what you said. I was thinking about filtering in pure 
userspace, but you meant in-kernel probe side.

Right, we can change the probe to filter BIO_BOUNCED case out. But IMHO 
BIO_CLONED is different, since it usually routed to another device as a 
separate IO request. I'll cook a patch for the former soon.

Thanks for the comment.
Namhyung Kim
