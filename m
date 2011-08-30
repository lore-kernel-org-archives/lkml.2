Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752677Ab1H3WYh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 18:24:37 -0400
Received: from smtp-out.google.com ([216.239.44.51]:24932 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752168Ab1H3WYf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 18:24:35 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:date:
	message-id:subject:from:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=lVA1XCxQRdD0nPAQgrYuLnAqc5wOO9zJ9Gr6F8Z8tDnNMKsZOSDFCLeDxJMrhgjFE
	01Gs1G5DsON+bHSvDDW+A==
MIME-Version: 1.0
In-Reply-To: <4E5D5817.6040704@kernel.dk>
References: <CAAK6Zt2icmsBxjdqFvDXfnxZHXuKN3hDSTdDmh7Vhj1iJ_5LXQ@mail.gmail.com>
	<CAAK6Zt0Sh1GdEOb-tNf2FGXJs=e1Jbcqew13R_GdTqrv6vW97w@mail.gmail.com>
	<x49k49uk2ox.fsf@segfault.boston.devel.redhat.com>
	<4E5D5817.6040704@kernel.dk>
Date: Tue, 30 Aug 2011 15:19:23 -0700
Message-ID: <CAAK6Zt2C1646qwDiZ7sWheSWrnx2yrDtCE=+VTx7QNyh2bEz_g@mail.gmail.com>
Subject: Re: Approaches to making io_submit not block
From: Daniel Ehrenberg <dehrenberg@google.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Jeff Moyer <jmoyer@redhat.com>, linux-kernel@vger.kernel.org,
        linux-aio@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 30, 2011 at 2:37 PM, Jens Axboe <axboe@kernel.dk> wrote:
> On 2011-08-30 15:30, Jeff Moyer wrote:
>> Daniel Ehrenberg <dehrenberg@google.com> writes:
>>
>>> Hi Jens, Jeff,
>>>
>>> I just sent a letter to LKML wondering about changes to io_submit that
>>> I'm thinking of working on. Based on your past contributions to this
>>> area, I'd really like to know what you think of this plan--how well it
>>> matches with the existing design, the potential for inclusion in
>>> upstream Linux, if you see problems.
>>
>> Hi, Dan,
>>
>> Thanks for taking the time to make AIO better!  There is a mailing list
>> for aio discussions: linux-aio@kvack.org, so please CC that in the
>> future (I don't read lkml anymore).
>>
>> Right now I'm a bit inundated, so I can't give this a proper review.
>> I should be able to free up some time in the next two weeks, though.
>>
>> In the mean time, you can google for suparna's retry-based aio patches.
>> Specifically, take a look at how she used prepare_to_wait/finish_wait.
>> If you haven't done any empirical tests to see where io_submit blocks,
>> there is a sample systemtap script for that:
>>   http://sourceware.org/systemtap/examples/io/io_submit.stp
>> Other attempts at non-blocking aio were off the deep end: fibrils and
>> syslets.  Fibrils didn't go anywhere because Ingo didn't like them (for
>> good reason, they essentially introduced another scheduling layer).
>> Syslets didn't go anywhere b/c they were insane (returned to the
>> user-space process with a different PID, among other things!).
>>
>> If you do go forward in the meantime, you can likely use EIOCBRETRY
>> instead of EAGAIN.
>>
>> I hope that helps!
>
> FWIW, I updated the buffered AIO retry patches some time after Suparna
> droped them. By the date stamp in my branch, they are now 23 months
> old... Anyway, at least it's more recent, you can find them here:
>
> http://git.kernel.dk/?p=linux-block.git;a=shortlog;h=refs/heads/aio-buffered
>
> --
> Jens Axboe
>
>
Thanks! Do you know why the patches weren't merged? I can't find much
discussion about them.

Dan
