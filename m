Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932298Ab0FYSzG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 14:55:06 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:53913 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756734Ab0FYSzE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 14:55:04 -0400
Message-ID: <4C24FB84.5050408@kernel.dk>
Date: Fri, 25 Jun 2010 20:55:00 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Jeff Moyer <jmoyer@redhat.com>
CC: Vivek Goyal <vgoyal@redhat.com>, linux-kernel@vger.kernel.org,
       linux-ext4@vger.kernel.org
Subject: Re: [PATCH 1/3] block: Implement a blk_yield function to voluntarily
 give up the I/O scheduler.
References: <1277242502-9047-1-git-send-email-jmoyer@redhat.com>	<1277242502-9047-2-git-send-email-jmoyer@redhat.com>	<20100624004622.GA3297@redhat.com> <x49bpaznjgx.fsf@segfault.boston.devel.redhat.com>
In-Reply-To: <x49bpaznjgx.fsf@segfault.boston.devel.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25/06/10 18.51, Jeff Moyer wrote:
>>> +	cfq_log_cfqq(cfqd, cfqq, "yielding queue to %d", tsk->pid);
>>> +	cfqq->yield_to = new_cic;
>>
>> We are stashing away a pointer to cic without taking reference?
> 
> There is no reference counting on the cic.

Not on the cic itself, but on the io context it belongs to. So you
need to grab a reference to that, if you are stowing a reference
to the cic.

-- 
Jens Axboe

