Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751263Ab0HOTXh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Aug 2010 15:23:37 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:45998 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933Ab0HOTXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Aug 2010 15:23:36 -0400
Date: Sun, 15 Aug 2010 21:23:35 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: lkml <linux-kernel@vger.kernel.org>, David Airlie <airlied@linux.ie>,
        dri-devel <dri-devel@lists.freedesktop.org>
Subject: headers_check warnings in drm headers
Message-ID: <20100815192335.GA3438@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When I ran "make headers_check" on upstream I got following
set of warnings for the drm headers:

usr/include/drm/drm_mode.h:85: found __[us]{8,16,32,64} type without #include <linux/types.h>
usr/include/drm/i915_drm.h:120: found __[us]{8,16,32,64} type without #include <linux/types.h>
usr/include/drm/mga_drm.h:260: found __[us]{8,16,32,64} type without #include <linux/types.h>
usr/include/drm/radeon_drm.h:758: found __[us]{8,16,32,64} type without #include <linux/types.h>
usr/include/drm/via_drm.h:117: found __[us]{8,16,32,64} type without #include <linux/types.h>

When I looked through the files I noticed a few things:

1) Several files uses a mixture of native types and linux types.
   For example "unsigned int" and "__u32" in the same file.
2) drm.h contains:
#if defined(__linux__)

#include <linux/types.h>
#include <asm/ioctl.h>
typedef unsigned int drm_handle_t;

#else /* One of the BSDs */

#include <sys/ioccom.h>
#include <sys/types.h>
typedef int8_t   __s8;
typedef uint8_t  __u8;
typedef int16_t  __s16;
typedef uint16_t __u16;
typedef int32_t  __s32;
typedef uint32_t __u32;
typedef int64_t  __s64;
typedef uint64_t __u64;
typedef unsigned long drm_handle_t;

#endif

Why this when no-one else require this treatment?

3) Lots of typedefs...

All in all - too much to dig into without knowing
the background for the current state.

At a minimum please get the warnings fixed.

	Sam

