Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756820Ab0KJQFL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 11:05:11 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37148 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756488Ab0KJQFK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 11:05:10 -0500
MIME-Version: 1.0
In-Reply-To: <20101110013255.GR2715@dastard>
References: <20101105014334.GF13830@dastard> <E1PELiI-0001Pj-8g@approx.mit.edu>
 <AANLkTimON_GL6vRF9=_U6oRFQ30EYssx3wv5xdNsU9JM@mail.gmail.com>
 <4CD696B4.6070002@kernel.dk> <AANLkTikNPEcwWjEQuC-_=9yH5DCCiwUAY265ggeygcSQ@mail.gmail.com>
 <20101110013255.GR2715@dastard>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 10 Nov 2010 07:59:10 -0800
Message-ID: <AANLkTinpLuzd5c+WqXoa_0Z=nv=mDgd-k4QZbBZHsQnD@mail.gmail.com>
Subject: Re: 2.6.36 io bring the system to its knees
To: Dave Chinner <david@fromorbit.com>
Cc: Jens Axboe <axboe@kernel.dk>, dave b <db.pub.mail@gmail.com>,
        Sanjoy Mahajan <sanjoy@olin.edu>, Jesper Juhl <jj@chaosbits.net>,
        Chris Mason <chris.mason@oracle.com>, Ingo Molnar <mingo@elte.hu>,
        Pekka Enberg <penberg@kernel.org>,
        Aidar Kultayev <the.aidar@gmail.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
        Arjan van de Ven <arjan@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, "Ted Ts'o" <tytso@mit.edu>,
        Corrado Zoccolo <czoccolo@gmail.com>,
        Shaohua Li <shaohua.li@intel.com>, Steven Barrett <damentz@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 9, 2010 at 5:32 PM, Dave Chinner <david@fromorbit.com> wrote:
>
> Don't forget to mention data=writeback is not the default because if
> your system crashes or you lose power running in this mode it will
> *CORRUPT YOUR FILESYSTEM* and you *WILL LOSE DATA*.

You will lose data even with data=ordered. All the data that didn't
get logged before the crash is lost anyway.

So your argument is kind of dishonest. The thing is, if you have a
crash or power outage or whatever, the only data you can really rely
on is always going to be the data that you fsync'ed before the crash.
Everything else is just gravy.

Are there downsides to "data=writeback"? Absolutely. But anybody who
tries to push those downsides without taking the performance and
latency issues into account is just not thinking straight.

Too many people think that "correct" is somehow black-and-white. It's
not. "The correct answer too late" is not worth anything. Sane people
understand that "good enough" is important.

And quite frankly, "data=writeback" is not wonderful, but it's "good
enough". And it helps enormously with at least one class of serious
performance problems. Dismissing it because it doesn't have quite the
guarantees of "data=ordered" is like saying that you should never use
"pi=3.14" for any calculations because it's not as exact as
"pi=3.14159265". The thing is, for many things, three significant
digits (or even _one_ significant digit) is plenty.

ext3 [f]sync sucks. We know. All filesystems suck. They just tend to
do it in different dimensions.

                         Linus
