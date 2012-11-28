Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932767Ab2K1WLk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 17:11:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56426 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932533Ab2K1WLh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 17:11:37 -0500
Date: Wed, 28 Nov 2012 17:10:47 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file.rdu.redhat.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Jens Axboe <axboe@kernel.dk>, Jeff Chua <jeff.chua.linux@gmail.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Jan Kara <jack@suse.cz>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH] Introduce a method to catch mmap_region (was: Recent
 kernel "mount" slow)
In-Reply-To: <CA+55aFwzEs3F6-n-Q=DrJgCScYwQ29PVZdCrGAO2y+FPC3Eq=Q@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1211281705020.5283@file.rdu.redhat.com>
References: <CAAJw_ZtbhE5Jtd4PsWx8a23QdFTW7aMrKBmRf-bo5Wrean9Xhg@mail.gmail.com>
 <Pine.LNX.4.64.1211241555470.4300@file.rdu.redhat.com>
 <CAAJw_ZvUqRmCCQ5-2PdFPRyfdzZMuphGU=hgAjUOHGk=n9Mheg@mail.gmail.com>
 <CAAJw_ZuJXnAz1ukBwQa3xNbQaL1KUBSrbQMK2hn-7D6Ar1p3fQ@mail.gmail.com>
 <50B46E05.70906@kernel.dk> <CAAJw_ZsYuLCwCTc6U=ELO_PvyjnVKQdkPke2enfzm6zOeWAqjA@mail.gmail.com>
 <50B4B313.3030707@kernel.dk> <Pine.LNX.4.64.1211272252260.18338@file.rdu.redhat.com>
 <50B5CC5A.8060607@kernel.dk> <Pine.LNX.4.64.1211281222410.11599@file.rdu.redhat.com>
 <CA+55aFx4zYnEsUyGJurBjB0XZ0AgmyKqW-+KWVDvma3w6csnHQ@mail.gmail.com>
 <Pine.LNX.4.64.1211281422360.26389@file.rdu.redhat.com>
 <CA+55aFyXdtVJ=SG9bU4qfggCR6DPvz4vOFYxKJZx_WdyFv+3Fw@mail.gmail.com>
 <CA+55aFyXS0nkDB95c3pcdg1ctrNnUGO8aDuRNhKSEg3JrOqWhA@mail.gmail.com>
 <CA+55aFw+9FRKZRe4-eSE3m9rGNfiUMM4-QETHizwYCRso_=bsg@mail.gmail.com>
 <CA+55aFwzEs3F6-n-Q=DrJgCScYwQ29PVZdCrGAO2y+FPC3Eq=Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 28 Nov 2012, Linus Torvalds wrote:

> On Wed, Nov 28, 2012 at 12:32 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > Here is a *COMPLETELY* untested patch. Caveat emptor. It will probably
> > do unspeakable things to your family and pets.
> 
> Btw, *if* this approach works, I suspect we could just switch the
> bd_block_size_semaphore semaphore to be a regular rw-sem.
> 
> Why? Because now it's no longer ever gotten in the cached IO paths, we
> only get it when we're doing much more expensive things (ie actual IO,
> and buffer head allocations etc etc). As long as we just work with the
> page cache, we never get to the whole lock at all.
> 
> Which means that the whole percpu-optimized thing is likely no longer
> all that relevant.

Using normal semaphore degrades direct-IO performance on raw devices, I 
measured that (45.1s with normal rw-semaphore vs. 42.8s with 
percpu-rw-semaphore). It could be measured on ramdisk or high-performance 
SSDs.

Mikulas
