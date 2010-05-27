Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759081Ab0E0LsA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 07:48:00 -0400
Received: from smtp-out.google.com ([216.239.44.51]:56455 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754687Ab0E0Lr7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 07:47:59 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:x-system-of-record;
	b=AKjuhjIpyekHbdR69QaBOXOgsqhVdyNqHDtvF0Z1eT8NXzM8V36br8gI8zVh5i/dc
	hXy5zpu3B7RCxAGNZCvNA==
MIME-Version: 1.0
In-Reply-To: <1274959080.27810.4438.camel@twins>
References: <1274733081-4623-1-git-send-email-walken@google.com>
	<1274777239.5882.581.camel@twins>
	<AANLkTikbeXjmRW4gqiy1Ss-Suce5gIM4xJ5o9Z81ZTQX@mail.gmail.com>
	<1274779675.5882.684.camel@twins>
	<20100527105948.GA20625@google.com>
	<1274959080.27810.4438.camel@twins>
Date: Thu, 27 May 2010 04:47:56 -0700
Message-ID: <AANLkTinA3n2OE5k7ri1UeS0ysGzJycZWzgzMw_GwT-XR@mail.gmail.com>
Subject: Re: [PATCH 00/11] V4: rwsem changes + down_read_critical() proposal
From: Michel Lespinasse <walken@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       David Howells <dhowells@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Waychison <mikew@google.com>,
       Suleiman Souhlal <suleiman@google.com>, Ying Han <yinghan@google.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 27, 2010 at 4:18 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Thu, 2010-05-27 at 03:59 -0700, Michel Lespinasse wrote:
>> What about patches 1-7 which don't deal with the critical/atomic API;
>> can we agree to get these in before we we figure out what to do with
>> the the last 4 ?
>
> patch 6 looks like it will break fairness, either that or the changelog
> got me totally confused (already had to read it twice).

Hmmm. I must be bad at explaining this :)

It avoids a situation where threads got blocked waiting for all active
readers to release, but (due to a race condition when blocking) the
first queued thread is also a reader. Letting that reader proceed in
parallel with the currently active ones will not delay queued writers;
they would have had to wait for the first queued reader to proceed
anyway since they were queued behind it.

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
