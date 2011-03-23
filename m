Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932802Ab1CWTrT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 15:47:19 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:63366 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932592Ab1CWTrR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 15:47:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=hP+kEFKy2jYmJPVZ9Kacmg8wUEtD27giA+0bkqtgLFDNyo0U61bxlE3WUCwiayxiqd
         nmF5XWiynoS7+YTRhVd/dbTMqRZmFJqoR08S7+phBoSjeVxdLukI1+SMNyEMV+IKMSjY
         Lml+zTrrnmcxhv7lsItTNWj9oA2RUmVwZfBBU=
MIME-Version: 1.0
In-Reply-To: <AANLkTik4iG+Ssb+JU3YRB4C11CEZeVozqoiz4rvezFLL@mail.gmail.com>
References: <20110323153727.GB12003@htj.dyndns.org> <AANLkTik4iG+Ssb+JU3YRB4C11CEZeVozqoiz4rvezFLL@mail.gmail.com>
From: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
Date: Wed, 23 Mar 2011 22:46:56 +0300
Message-ID: <AANLkTiktmhP6-JGTKHf+wZhdJRd3Eb-PYzMRR=CyRsUP@mail.gmail.com>
Subject: Re: [RFC PATCH] mutex: Apply adaptive spinning on mutex_trylock()
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Mason <chris.mason@oracle.com>, linux-kernel@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 23, 2011 at 6:48 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Wed, Mar 23, 2011 at 8:37 AM, Tejun Heo <tj@kernel.org> wrote:
>>
>> Currently, mutex_trylock() doesn't use adaptive spinning.  It tries
>> just once.  I got curious whether using adaptive spinning on
>> mutex_trylock() would be beneficial and it seems so, at least for
>> btrfs anyway.
>
> Hmm. Seems reasonable to me.

TAS/spin with exponential back-off has been preferred locking approach
in Postgres (and I believe other DBMSes) for years, at least since '04
when I had last touched Postgres code. Even with 'false negative' cost
in user-space being much higher than in the kernel, it's still just a
question of scale (no wonder measurable improvement here is reported
from dbench on SSD capable of few dozen thousand IOPS).

Regards,
Andrey

> The patch looks clean, although part of that is just the mutex_spin()
> cleanup that is independent of actually using it in trylock.
>
> So no objections from me.
>
>                    Linus
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
