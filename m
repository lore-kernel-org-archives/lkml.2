Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754918Ab1BRWIh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 17:08:37 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:63848 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753307Ab1BRWIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 17:08:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:date:message-id:subject:from:to:cc
         :content-type;
        b=uYY1Xjq6wWHh5bUzEOXs47YT4Bj4ZvGKYtzBMxaXhIql4JhUamZaAtwYWhB/Qn14U1
         bJKlFCdLqcv0eNZd2T00Ox/JYoHyZhnHLyu85VKL4tN3wKHlFxCdWpgR1fI72nnhhm4f
         UBE+YnXC4ZJutNHk5+Utv/1+DChty75FrBYTg=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
Date: Fri, 18 Feb 2011 23:08:34 +0100
Message-ID: <AANLkTimK3zk4mZXJyR9L7gS-MN-vZDgRx8nMpOpGRhJR@mail.gmail.com>
Subject: Re: [PATCH 00/11] [resend] drm core and radeon patches for -next
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Daniel Vetter <daniel@ffwll.ch>
Cc: DRI <dri-devel@lists.freedesktop.org>, LKML <linux-kernel@vger.kernel.org>,
        linux-next@vger.kernel.org, Dave Airlie <airlied@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ QUOTE ]
Hi Dave,

Here are the patches I've talked about on irc for .39.

Patches 1-5 is the "make drm_mm_node embeddable" series. Just the drm core
part, without the patches for i915 (they need to be redone). Chris
Wilson very much likes what these will to do drm/i915. Thomas Hellstrom
cautioned not to go crazy and embed drm_mm_node everywhere (especially in
ttm_bo_object), because the drm_mm allocator is not adequate everwhere and
embedding might just create future obstacles for the Right Thing. Like
switching to idr, as vmgfx already has already done for a few things.

Patches 6-8 embed the gem bo object into the radeon bo object. Changes
since first submission:
- Resolve conflict with pageflip code (resulted in a null-pointer deref).
- Align bo size to PAGE_SIZE (the r600/evergreen kms blit code didn't do
  this, upsetting the more paranoid gem code).

Patches 9-11 finish my radeon asic header cleanup that I've started a while
back. Reviewed by Alex Deucher, I've dropped the 3 small patches he
objected.

Tested on my usual array of machines (which now also includes an HD5750 and
a HD 4350 and a g73 from nvidia ;).

Please review and consider merging for next.

Thanks, Daniel

Daniel Vetter (11):
  drm/nouveau: don't munge in drm_mm internals
  drm: mm: track free areas implicitly
  drm: mm: extract node insert helper functions
  drm: mm: add api for embedding struct drm_mm_node
  drm: mm: add helper to unwind scan state
  drm/radeon: embed struct drm_gem_object
  drm/radeon: introduce gem_to_radeon_bo helper
  drm/radeon: kill radeon_bo->gobj pointer
  radeon: consolidate asic-specific function decls for r600 & later
  radeon: kill decls for inline functions
  radeon: move blit functions to radeon_asic.h
...
[ /QUOTE ]

Tested successfully against linux-next (next-20110218) on a radeon
RV250 gfxcard.
It would be nice to see Daniel's (missing) patchset(s) finally in one
of Dave's drm-2.6 GIT branches.
I had the previous (splitted in multiple little) patchsets running
here againt linux-next for such a long time.
So go go go!

- Sedat -
