Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932590Ab2C1Ljd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 07:39:33 -0400
Received: from smtp.fireflyinternet.com ([109.228.6.236]:57647 "EHLO
	fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932527Ab2C1Ljc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 07:39:32 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.66.37;
From: Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: [PATCH 08/13 v4] drm/i915/intel_i2c: handle zero-length writes
To: Daniel Kurtz <djkurtz@chromium.org>
Cc: Daniel Vetter <daniel@ffwll.ch>, Keith Packard <keithp@keithp.com>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, Benson Leung <bleung@chromium.org>,
        Yufeng Shen <miletus@chromium.org>
In-Reply-To: <CAGS+omCX+_T9sDbtmdhivn4wb6b8LMGYwKxXak4G_HxeQ1Kfsw@mail.gmail.com>
References: <1332873382-29373-1-git-send-email-djkurtz@chromium.org> <1332873382-29373-9-git-send-email-djkurtz@chromium.org> <1332875657_117263@CP5-2952> <CAGS+omCX+_T9sDbtmdhivn4wb6b8LMGYwKxXak4G_HxeQ1Kfsw@mail.gmail.com>
Date: Wed, 28 Mar 2012 12:39:12 +0100
X-Originating-IP: 78.156.66.37
Message-ID: <1332934765_126523@CP5-2952>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Mar 2012 19:32:27 +0800, Daniel Kurtz <djkurtz@chromium.org> wrote:
> Unfortunately there is a bug in both my original patch (it wasn't
> incrementing loop), and in your suggested cleanup (it always
> decrements len, even when it is already 0... or if the loop test
> fails).  How about the following; despite its pythonic nature, it
> always completes with len holding the number of bytes remaining.
> 
> 	val = loop = 0;
> 	while (len && loop < 4) {
> 		val |= *buf++ << (8 * loop++);
> 		len -= 1;
> 	}

I'm getting over my aversion ;-)

As we are here, have you considered doing an optimised u32 variant whilst
len >= 4, which should be reasonably common during EDID transfer. Though
I am not sure if that loop is merely in the noise compared to the rest of
the mmio.
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
