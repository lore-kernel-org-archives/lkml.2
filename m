Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758231Ab0JFGFo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 02:05:44 -0400
Received: from smtp.nokia.com ([192.100.105.134]:39689 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755474Ab0JFGFn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 02:05:43 -0400
Subject: Re: [PATCH 0/1] wait: using uninitialized member of wait queue
From: Evgeny Kuznetsov <EXT-Eugeny.Kuznetsov@nokia.com>
To: ext Linus Torvalds <torvalds@linux-foundation.org>
Cc: akpm@linux-foundation.org, m.nazarewicz@samsung.com, mingo@elte.hu,
        gregkh@suse.de, a.p.zijlstra@chello.nl, xiaosuo@gmail.com,
        linux-kernel@vger.kernel.org
In-Reply-To: <AANLkTimEp8rorHxtOQji-xtXZoDkcYrGGWCBQg3ypKf4@mail.gmail.com>
References: <cover.1286193121.git.EXT-Eugeny.Kuznetsov@nokia.com>
	 <AANLkTimEp8rorHxtOQji-xtXZoDkcYrGGWCBQg3ypKf4@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 06 Oct 2010 10:01:31 +0400
Message-ID: <1286344891.24366.59.camel@ekuznets-lx-nokia>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 06 Oct 2010 06:05:10.0793 (UTC) FILETIME=[6F1E2F90:01CB651C]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-10-05 at 08:43 -0700, ext Linus Torvalds wrote:
> On Tue, Oct 5, 2010 at 1:47 AM, Evgeny Kuznetsov
> <EXT-Eugeny.Kuznetsov@nokia.com> wrote:
> >
> > Here is patch which fixes bug in /include/linux/wait.h file.
> > Member "flags" of "wait_queue_t" struct  is used in several places in
> > kernel code without beeing initialized. "flags" is used in bitwise
> > operations. If it contain dummy data then incorrect flags may be
> > used later in code.
> 
> The patch looks fine, but do you have any case of this actually
> causing problems? Afaik, we do end up initializing the part of the
> flags field we care about (WQ_FLAG_EXCLUSIVE) in prepare_to_wait()
> (and add_wait_queue()), so it looks - from an admittedly very cursory
> read - as if this is a good cleanup but shouldn't actually be the
> cause of any actual bugs.
> 
> So I'll apply it, but I just wondered if you had actually seen any
> semantic changes from it?
> 
>                Linus
I did not see any problems caused by uninitialized flag. But this is
potential unsafe place (in case of future changes).
Also there is initialization of all members but not 'flags' in
init_wait() function. It is logical to initialize all data members.

Thanks,
Regards,
Evgeny

