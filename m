Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752891Ab2D3Hzj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 03:55:39 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:53788 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751686Ab2D3Hzi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 03:55:38 -0400
Date: Mon, 30 Apr 2012 00:54:18 -0700
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: Minchan Kim <minchan@kernel.org>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Leonid Moiseichuk <leonid.moiseichuk@nokia.com>
Subject: Re: vmevent: question?
Message-ID: <20120430075417.GA8438@lizard>
References: <4F9E39F1.5030600@kernel.org>
 <CAOJsxLE3A3b5HSrRm0NVCBmzv7AAs-RWEiZC1BL=se309+=WTA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOJsxLE3A3b5HSrRm0NVCBmzv7AAs-RWEiZC1BL=se309+=WTA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Pekka,

On Mon, Apr 30, 2012 at 10:35:02AM +0300, Pekka Enberg wrote:
> > vmevent_smaple gathers all registered values to report to user if vmevent match.
> > But the time gap between vmevent match check and vmevent_sample_attr could make error
> > so user could confuse.
> >
> > Q 1. Why do we report _all_ registered vmstat value?
> >     In my opinion, it's okay just to report _a_ value vmevent_match happens.
> 
> It makes the userspace side simpler for "lowmem notification" use
> case. I'm open to changing the ABI if it doesn't make the userspace
> side too complex.

Yep. Actually, I'd like to add something like 'file_pages - shmem'
attribute, and reporting both (i.e. this new attr and free_pages)
values at the same time (even if just one crossed the threshold).

Reporting all the values would help userspace logic (so it won't
need to read /proc again).

> > Q 4. Do you have any plan for this patchset to merge into mainline?
> 
> Yes, I'm interested in pushing it forward if we can show that the ABI
> makes sense, is stable and generic enough, and fixes real world
> problems.

It seems to be a pretty nice driver. Speaking of ABI, the only thing
I personally dislike is VMEVENT_CONFIG_MAX_ATTRS (i.e. fixed-size
array in vmevent_config)... but I guess it's pretty easy to make
it variable-sized array... was there any particular reason to make
the _MAX thing?

Thanks!

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
