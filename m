Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756270Ab0FYT5Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 15:57:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38752 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751833Ab0FYT5X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 15:57:23 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Vivek Goyal <vgoyal@redhat.com>, linux-kernel@vger.kernel.org,
       linux-ext4@vger.kernel.org
Subject: Re: [PATCH 1/3] block: Implement a blk_yield function to voluntarily give up the I/O scheduler.
References: <1277242502-9047-1-git-send-email-jmoyer@redhat.com>
	<1277242502-9047-2-git-send-email-jmoyer@redhat.com>
	<20100624004622.GA3297@redhat.com>
	<x49bpaznjgx.fsf@segfault.boston.devel.redhat.com>
	<4C24FB84.5050408@kernel.dk>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Fri, 25 Jun 2010 15:57:19 -0400
In-Reply-To: <4C24FB84.5050408@kernel.dk> (Jens Axboe's message of "Fri, 25
	Jun 2010 20:55:00 +0200")
Message-ID: <x496316opgg.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe <axboe@kernel.dk> writes:

> On 25/06/10 18.51, Jeff Moyer wrote:
>>>> +	cfq_log_cfqq(cfqd, cfqq, "yielding queue to %d", tsk->pid);
>>>> +	cfqq->yield_to = new_cic;
>>>
>>> We are stashing away a pointer to cic without taking reference?
>> 
>> There is no reference counting on the cic.
>
> Not on the cic itself, but on the io context it belongs to. So you
> need to grab a reference to that, if you are stowing a reference
> to the cic.

OK, easy enough.  Thanks!

Jeff
