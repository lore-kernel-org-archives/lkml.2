Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752795Ab0F1Suq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 14:50:46 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:47074 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751864Ab0F1Sup (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 14:50:45 -0400
Message-ID: <4C28EF04.7040309@kernel.dk>
Date: Mon, 28 Jun 2010 20:50:44 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Jeff Moyer <jmoyer@redhat.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] cfq: always return false from should_idle if slice_idle
 is set to zero
References: <1277149789-4493-1-git-send-email-jmoyer@redhat.com>	<1277149789-4493-2-git-send-email-jmoyer@redhat.com>	<4C1FC4CA.7030007@kernel.dk> <x49hbkndmoc.fsf@segfault.boston.devel.redhat.com>
In-Reply-To: <x49hbkndmoc.fsf@segfault.boston.devel.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28/06/10 20.41, Jeff Moyer wrote:
> Jens Axboe <axboe@kernel.dk> writes:
> 
>> On 21/06/10 21.49, Jeff Moyer wrote:
>>> Hi,
>>>
>>> In testing a competing fsync-ing process and a sequential reader on
>>> mid-grade storage, I found that cfq was incapable of achieving the I/O
>>> rates of deadline, no matter how it was tuned.  Investigation, and insight
>>> from Vivek (mostly the latter), led to identifying that we were still
>>> idling for the last queue in the service tree.
>>>
>>> Modifying cfq_should_idle to not idle when slice_idle is set to zero got
>>> us much closer to the performance of deadline for this workload.  I have
>>> one follow-on patch that gets us on-par with deadline, but I think this
>>> patch stands alone.
>>>
>>> Comments, as always, are appreciated.
>>
>> This looks good.
> 
> So.... applied to which branch?

Not applied yet, unless I explicitly say it's applied, then it's not
necessarily in any public git tree yet. But this will go into .35.

-- 
Jens Axboe

