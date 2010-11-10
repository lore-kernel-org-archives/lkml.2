Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757130Ab0KJRBk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 12:01:40 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45880 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757046Ab0KJRBj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 12:01:39 -0500
MIME-Version: 1.0
In-Reply-To: <AANLkTinYZ2wPeeunFv4Ljm+D9SDLbgzTVmw_P9KQdK16@mail.gmail.com>
References: <20101105014334.GF13830@dastard> <E1PELiI-0001Pj-8g@approx.mit.edu>
 <AANLkTimON_GL6vRF9=_U6oRFQ30EYssx3wv5xdNsU9JM@mail.gmail.com>
 <4CD696B4.6070002@kernel.dk> <AANLkTikNPEcwWjEQuC-_=9yH5DCCiwUAY265ggeygcSQ@mail.gmail.com>
 <20101110013255.GR2715@dastard> <AANLkTinpLuzd5c+WqXoa_0Z=nv=mDgd-k4QZbBZHsQnD@mail.gmail.com>
 <AANLkTinYZ2wPeeunFv4Ljm+D9SDLbgzTVmw_P9KQdK16@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 10 Nov 2010 08:55:07 -0800
Message-ID: <AANLkTik1zyrP5DBGC+MmSKF2Eeep3fSu=-8TdOY8BTJj@mail.gmail.com>
Subject: Re: 2.6.36 io bring the system to its knees
To: Alexey Dobriyan <adobriyan@gmail.com>
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

On Wed, Nov 10, 2010 at 8:46 AM, Alexey Dobriyan <adobriyan@gmail.com> wrote:
>>
>> You will lose data even with data=ordered. All the data that didn't
>> get logged before the crash is lost anyway.
>
> Linus, are you using with data=writeback?

I used to, indeed. But since I upgrade computers fairly regularly, and
all the distros have moved towards ext4, I'm no longer using ext3 at
all.

But yes, to me ext3 was totally unusable with rotational media and
"data=ordered". Not just bad. Total crap. Whenever the mail client
wanted to write something out, the whole machine basically stopped.

Of course, part of that was that long ago I used reiserfs back when
SuSE had it as the default. So I didn't think that the hickups were
"normal" like a lot of people probably do. I knew better. So it was
"bad latency, and I know it's the filesystem that is total crap".

> Those of us, who did (without UPS), will never do it again.

Before or after the change to make renaming on top of old files do the
IO flushing?

That made a big difference for some rather common cases.

                            Linus
