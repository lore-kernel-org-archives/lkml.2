Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756420Ab1CHVhB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 16:37:01 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43276 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755386Ab1CHVg7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 16:36:59 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: Mike Snitzer <snitzer@redhat.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hch\@infradead.org" <hch@infradead.org>
Subject: Re: [PATCH 05/10] block: remove per-queue plugging
References: <1295659049-2688-1-git-send-email-jaxboe@fusionio.com>
	<1295659049-2688-6-git-send-email-jaxboe@fusionio.com>
	<AANLkTin8FoXX6oqUyW+scwhadyX-TfW16_oKjvngU9-m@mail.gmail.com>
	<20110303221353.GA10366@redhat.com> <4D761E0D.8050200@fusionio.com>
	<20110308202100.GA31744@redhat.com> <4D76912C.9040705@fusionio.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Tue, 08 Mar 2011 16:36:32 -0500
In-Reply-To: <4D76912C.9040705@fusionio.com> (Jens Axboe's message of "Tue, 8
	Mar 2011 21:27:24 +0100")
Message-ID: <x4962rt47mn.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe <jaxboe@fusionio.com> writes:

> On 2011-03-08 21:21, Mike Snitzer wrote:
>> On Tue, Mar 08 2011 at  7:16am -0500,
>> Jens Axboe <jaxboe@fusionio.com> wrote:
>> 
>>> On 2011-03-03 23:13, Mike Snitzer wrote:
>>>> I'm now hitting a lockdep issue, while running a 'for-2.6.39/stack-plug'
>>>> kernel, when I try an fsync heavy workload to a request-based mpath
>>>> device (the kernel ultimately goes down in flames, I've yet to look at
>>>> the crashdump I took)
>>>
>>> Mike, can you re-run with the current stack-plug branch? I've fixed the
>>> !CONFIG_BLOCK and rebase issues, and also added a change for this flush
>>> on schedule event. It's run outside of the runqueue lock now, so
>>> hopefully that should solve this one.
>> 
>> Works for me, thanks.
>
> Super, thanks! Out of curiousity, did you use dm/md?

mm/memory-failure.c: In function 'hwpoison_user_mappings':
mm/memory-failure.c:948: error: implicit declaration of function 'lock_page_nosync'

You missed a conversion of lock_page_nosync -> lock_page.

Cheers,
Jeff
