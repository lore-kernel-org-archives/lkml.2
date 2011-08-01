Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753458Ab1HACWU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jul 2011 22:22:20 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37204 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753024Ab1HACWM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jul 2011 22:22:12 -0400
MIME-Version: 1.0
In-Reply-To: <20110801020951.GA12870@dastard>
References: <20110728164105.GA18258@infradead.org> <20110729142121.GA21149@localhost>
 <20110730134422.GA1884@infradead.org> <20110731151014.GA23106@localhost>
 <20110731234749.GQ5404@dastard> <CA+55aFzkb58Gtzgpd3oQgXekpg4APN6jDLNCh=CAMQ0zwyE4kg@mail.gmail.com>
 <20110801012813.GR5404@dastard> <CA+55aFwtfUeUn=MuqSEyPiPeC5=k2xK2ULd9-5ShQAJ=4T0CvQ@mail.gmail.com>
 <20110801020951.GA12870@dastard>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 31 Jul 2011 16:21:15 -1000
Message-ID: <CA+55aFy7wjBsgUhx2vxiKbN_fxJX2_bvJowQszyxyp7Emn_dQA@mail.gmail.com>
Subject: Re: xfstests 073 regression
To: Dave Chinner <david@fromorbit.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>,
        Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 31, 2011 at 4:09 PM, Dave Chinner <david@fromorbit.com> wrote:
>
> Hence if we can't grab the superblock here, it is simply another
> case of a "new work pending" interrupt, right? And so aborting the
> work is the correct thing to do? Especially as it avoids all the
> ordering problems of redirtying inodes and allows the writeback work
> to restart (form whatever context it is stared from next time) where
> it stopped.

Ok, that does sound like a reasonable approach to me. Which probably
means that there is some oversimplification and gotcha hidden in that
argument, but I don't see it immediately.

I do agree that it would be nice if we could avoid re-ordering
problems. The whole dirty time issue and whether inodes are actually
correctly ordered on the dirty lists has always been one huge rats
nest.  Ask Andrew about it, he was espousing his love for that code at
the recent Intel Tech Days ;)

         Linus
