Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755419Ab2BVTdy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 14:33:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33797 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751995Ab2BVTdx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 14:33:53 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, vgoyal@redhat.com, ctalbott@google.com, rni@google.com,
        linux-kernel@vger.kernel.org, Kent Overstreet <koverstreet@google.com>
Subject: Re: [PATCH 34/36] block: implement bio_associate_current()
References: <1329875223-5102-1-git-send-email-tj@kernel.org>
	<1329875223-5102-35-git-send-email-tj@kernel.org>
	<x49linvyobl.fsf@segfault.boston.devel.redhat.com>
	<20120222190750.GA17480@google.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Wed, 22 Feb 2012 14:33:43 -0500
In-Reply-To: <20120222190750.GA17480@google.com> (Tejun Heo's message of "Wed,
	22 Feb 2012 11:07:50 -0800")
Message-ID: <x494nuizmqw.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo <tj@kernel.org> writes:

> Hey, Jeff.

Hi, Tejun!

> On Wed, Feb 22, 2012 at 08:45:02AM -0500, Jeff Moyer wrote:
>> Tejun Heo <tj@kernel.org> writes:
>> 
>> > -v2: #ifdef CONFIG_BLK_CGROUP added around bio->bi_ioc dereference in
>> >      rq_ioc() to fix build breakage.
>> 
>> This is useful for cfq without blk cgroups as well, right?  Why have you
>> limited the scope like this?
>
> Because blk-throttle is the only current user.  We can move the
> BLK_CGROUP to cover just bi_css later on as we add more users.

I guess you're going to make me read the whole patch set.  ;-)  What I'm
getting at is CFQ uses the io_context to make its scheduling decisions.
If we can propagate the issuer's I/O context from bio creation all the
way down to the I/O scheduler, then we can do a better job of accounting
I/O (and hence scheduling, preemption, etc).  As Vivek mentioned
previously, we have seen performance issues with the dm-crypt target and
CFQ, precisely because all of the I/O is submitted in the context of a
worker thread, and the the process that initiated the I/O is unknown at
that point.

Hopefully I've either cleared up my question, or proven to you that I do
need to go read the rest of the patch set to understand why my question
doesn't make sense.  Let me know which is the case.  ;-)

Cheers,
Jeff
