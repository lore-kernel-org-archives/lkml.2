Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757034Ab0KJQqZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 11:46:25 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:58091 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756858Ab0KJQqY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 11:46:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=VRWi85xLS3pBgx5NtUc+LBqXoqxca+xwLbmESXy0DfcG2G1NQRuGvGXxNB4WmPXHPV
         V89HgnIJy+qdIdXxS1GQ5p+p4wNVySs44RjN14BkwNCX08wae1uEgjTNWwEOgDW13xQP
         rAW1cru6UAMjLeTyYxWcIJXIshS1Yq0kWRTis=
MIME-Version: 1.0
In-Reply-To: <AANLkTinpLuzd5c+WqXoa_0Z=nv=mDgd-k4QZbBZHsQnD@mail.gmail.com>
References: <20101105014334.GF13830@dastard>
	<E1PELiI-0001Pj-8g@approx.mit.edu>
	<AANLkTimON_GL6vRF9=_U6oRFQ30EYssx3wv5xdNsU9JM@mail.gmail.com>
	<4CD696B4.6070002@kernel.dk>
	<AANLkTikNPEcwWjEQuC-_=9yH5DCCiwUAY265ggeygcSQ@mail.gmail.com>
	<20101110013255.GR2715@dastard>
	<AANLkTinpLuzd5c+WqXoa_0Z=nv=mDgd-k4QZbBZHsQnD@mail.gmail.com>
Date: Wed, 10 Nov 2010 18:46:21 +0200
Message-ID: <AANLkTinYZ2wPeeunFv4Ljm+D9SDLbgzTVmw_P9KQdK16@mail.gmail.com>
Subject: Re: 2.6.36 io bring the system to its knees
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Chinner <david@fromorbit.com>, Jens Axboe <axboe@kernel.dk>,
        dave b <db.pub.mail@gmail.com>, Sanjoy Mahajan <sanjoy@olin.edu>,
        Jesper Juhl <jj@chaosbits.net>, Chris Mason <chris.mason@oracle.com>,
        Ingo Molnar <mingo@elte.hu>, Pekka Enberg <penberg@kernel.org>,
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

On Wed, Nov 10, 2010 at 5:59 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Tue, Nov 9, 2010 at 5:32 PM, Dave Chinner <david@fromorbit.com> wrote:
>>
>> Don't forget to mention data=writeback is not the default because if
>> your system crashes or you lose power running in this mode it will
>> *CORRUPT YOUR FILESYSTEM* and you *WILL LOSE DATA*.
>
> You will lose data even with data=ordered. All the data that didn't
> get logged before the crash is lost anyway.

Linus, are you using with data=writeback?

Those of us, who did (without UPS), will never do it again.

Propability of non-trivial FS corruption becomes so much bigger.
I believe from my experience, average number of crashes before
one loses FS becomes single digit number.

With data=ordered, it's quite hard.
