Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754352Ab2EHRWq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 13:22:46 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:42392 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754131Ab2EHRWo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 13:22:44 -0400
Date: Tue, 8 May 2012 19:23:52 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Linus Torvalds <torvalds@linux-foundation.org>, rob.clark@linaro.org
Cc: =?iso-8859-1?Q?St=E9phane?= Marchesin <marcheu@chromium.org>,
        olofj@chromium.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [PATCH] mm: Work around Intel SNB GTT bug with some physical
 pages.
Message-ID: <20120508172352.GQ4802@phenom.ffwll.local>
Mail-Followup-To: Linus Torvalds <torvalds@linux-foundation.org>,
	rob.clark@linaro.org,
	=?iso-8859-1?Q?St=E9phane?= Marchesin <marcheu@chromium.org>,
	olofj@chromium.org, linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org
References: <1336432421-17972-1-git-send-email-marcheu@chromium.org>
 <CA+55aFyd08=eemQsUFvtjerEVQdznhe647w4PmSrPkkEvjNuzg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+55aFyd08=eemQsUFvtjerEVQdznhe647w4PmSrPkkEvjNuzg@mail.gmail.com>
X-Operating-System: Linux phenom 3.4.0-rc3+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 08, 2012 at 08:25:38AM -0700, Linus Torvalds wrote:
> On Mon, May 7, 2012 at 4:13 PM, Stéphane Marchesin <marcheu@chromium.org> wrote:
> >
> > In the end, I came up with the ugly workaround of just leaking the
> > offending pages in shmem.c.
> 
> Don't leak it.
> 
> Instead, add it to some RCU list, and free it using RCU. Or some
> one-second timer or something.
> 
> That kind of approach should guarantee that it
> 
>  (a) gets returned to the system
> 
> but
> 
>  (b) the returning to the system gets delayed sufficiently that if the
> i915 driver is doing lots of allocations it will be getting other
> pages.
> 
> Hmm?

The problem is also that this only affects Sandybdrige gpus, so we'd need
to funnel this down to shmfs somehow ... Rob Clarke from Linaro will be
working on a gemfs to make backing storage allocation more flexible - they
need that to support some arm gpus. That way round we wouldn't need to put
some ugly drm/i915 stuff into core shmfs. Rob?
-Daniel
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
