Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753435Ab0KGPvS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Nov 2010 10:51:18 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60158 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753309Ab0KGPvR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Nov 2010 10:51:17 -0500
MIME-Version: 1.0
In-Reply-To: <4CD696B4.6070002@kernel.dk>
References: <20101105014334.GF13830@dastard> <E1PELiI-0001Pj-8g@approx.mit.edu>
 <AANLkTimON_GL6vRF9=_U6oRFQ30EYssx3wv5xdNsU9JM@mail.gmail.com> <4CD696B4.6070002@kernel.dk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 7 Nov 2010 07:50:13 -0800
Message-ID: <AANLkTikNPEcwWjEQuC-_=9yH5DCCiwUAY265ggeygcSQ@mail.gmail.com>
Subject: Re: 2.6.36 io bring the system to its knees
To: Jens Axboe <axboe@kernel.dk>
Cc: dave b <db.pub.mail@gmail.com>, Sanjoy Mahajan <sanjoy@olin.edu>,
        Dave Chinner <david@fromorbit.com>, Jesper Juhl <jj@chaosbits.net>,
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

On Sun, Nov 7, 2010 at 4:08 AM, Jens Axboe <axboe@kernel.dk> wrote:
>
> As already mentioned, ext3 is just not a good choice for this sort of
> thing. Did you have atimes enabled?

At least for ext3, more important than atimes is the "data=writeback"
setting. Especially since our atime default is sane these days (ie if
you don't specify anything, we end up using 'relatime').

If you compile your own kernel, answer "N" to the question

  Default to 'data=ordered' in ext3?

at config time (CONFIG_EXT3_DEFAULTS_TO_ORDERED), or you can make sure
"data=writeback" is in the fstab (but I don't think everything honors
it for the root filesystem).

                                   Linus
