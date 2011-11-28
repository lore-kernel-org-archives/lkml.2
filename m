Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756113Ab1K1E3z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 23:29:55 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:42904 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752705Ab1K1E3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 23:29:54 -0500
MIME-Version: 1.0
In-Reply-To: <aefc95$2cas5k@orsmga001.jf.intel.com>
References: <1321382968.8791.4.camel@localhost.localdomain>
	<20111121162306.GB3807@phenom.ffwll.local>
	<868vn9ieey.fsf@sumi.keithp.com>
	<CADZ9YHgwcjz=mkMxWxV1pT7fH=6hgWTSP1s2wmG7h3N837QUoQ@mail.gmail.com>
	<e0d58a$2cdsbh@orsmga002.jf.intel.com>
	<CADZ9YHinT6Y98Ks6Zs3UnG2xQSJYqDN5W1RgrNtyaPz-n8Zajg@mail.gmail.com>
	<aefc95$2cas5k@orsmga001.jf.intel.com>
Date: Mon, 28 Nov 2011 10:29:53 +0600
Message-ID: <CADZ9YHiuWT0qRO0PtL-5hLQYf5rkWs+vw4HCeR5smsnYzyQfhQ@mail.gmail.com>
Subject: Re: [PATCH] drm, i915: Fix memory leak in i915_gem_busy_ioctl().
From: Rakib Mullick <rakib.mullick@gmail.com>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Keith Packard <keithp@keithp.com>, akpm@linux-foundation.org,
        dri-devel <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 26, 2011 at 10:53 PM, Chris Wilson <chris@chris-wilson.co.uk> wrote:
> On Sat, 26 Nov 2011 22:29:12 +0600, Rakib Mullick <rakib.mullick@gmail.com> wrote:
>> Yes, no real problem with current code. I was just thinking from code
>> cleanup's pov. Is BUG_ON really needed in i915_add_request() ?
>
> No, just documentation as a reminder that the request should be
> preallocated, ideally so that we can fail gracefully without touching
> hardware and leaving it in an inconsistent state wrt to our bookkeeping.
> (This is more apparent in the overlay code which could hang the
> chip/driver if we hit a malloc error too late.)
>
> The BUG_ON has certainly outlived its usefulness.

Actually, I'm not seeing how BUG_ON could trigger (though, I've
wrongly mentioned in previous thread, if request == NULL, BUG_ON could
trigger), it's usefulness will never come into action. Other callers
of i915_add_request also makes sure that, it gets called only if
(request).

Although, kfree(NULL) is permitted, we shouldn't use it unnecessarily.
Anyway, since the issue is not a big deal and no real bug, it could be
droped.

Thanks,
Rakib
