Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753566Ab1HHTia (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 15:38:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3020 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753047Ab1HHTiP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 15:38:15 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        hch@infradead.org, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 11/11] DIO: optimize cache misses in the submission path
References: <1312259893-4548-1-git-send-email-andi@firstfloor.org>
	<1312259893-4548-12-git-send-email-andi@firstfloor.org>
	<x49zkjjg2w5.fsf@segfault.boston.devel.redhat.com>
	<20110808193231.GM5782@one.firstfloor.org>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Mon, 08 Aug 2011 15:38:03 -0400
In-Reply-To: <20110808193231.GM5782@one.firstfloor.org> (Andi Kleen's message
	of "Mon, 8 Aug 2011 21:32:31 +0200")
Message-ID: <x49vcu7g0dg.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen <andi@firstfloor.org> writes:

>> I bet we could default to using the smaller block size all the time, and
>> still be able to detect when we don't have to do the sub-block zeroing.
>> Maybe that would be a good follow-on patch.
>
> It doesn't really matter because it's out of the fast path now.
>
>> > +	/* 
>> > +	 * Avoid references to bdev if not absolutely needed to give
>> > +	 * the early prefetch in the caller enough time.
>> > +	 */
>> >  
>> > -	if (offset & blocksize_mask) {
>> > +	if (unlikely(offset & blocksize_mask)) {
>> 
>> You can't make this assumption.  Userspace controls what size/alignment
>> of blocks to send in.
>
> What assumption do you mean?

Sorry, I meant that we don't know whether the offset & blocksize_mask
check is unlikely.

Cheers,
Jeff
