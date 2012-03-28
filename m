Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752960Ab2C1Oae (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 10:30:34 -0400
Received: from smtp.fireflyinternet.com ([109.228.6.236]:18261 "EHLO
	fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752007Ab2C1Oad (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 10:30:33 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.66.37;
From: Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: [PATCH 14/14 v5] drm/i915/intel_i2c: remove POSTING_READ() from gmbus transfers
To: Daniel Kurtz <djkurtz@chromium.org>
Cc: Daniel Vetter <daniel@ffwll.ch>, Keith Packard <keithp@keithp.com>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, Benson Leung <bleung@chromium.org>,
        Yufeng Shen <miletus@chromium.org>
In-Reply-To: <CAGS+omAJaEaGUNY6V=sGNOWHxhb3YRv2mPcuUwQV99ksvsNP4Q@mail.gmail.com>
References: <1332939117-6513-1-git-send-email-djkurtz@chromium.org> <1332939117-6513-15-git-send-email-djkurtz@chromium.org> <1332939924_127442@CP5-2952> <CAGS+omAJaEaGUNY6V=sGNOWHxhb3YRv2mPcuUwQV99ksvsNP4Q@mail.gmail.com>
Date: Wed, 28 Mar 2012 15:30:13 +0100
X-Originating-IP: 78.156.66.37
Message-ID: <1332945027_128384@CP5-2952>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Mar 2012 21:21:42 +0800, Daniel Kurtz <djkurtz@chromium.org> wrote:
> On Wed, Mar 28, 2012 at 9:05 PM, Chris Wilson <chris@chris-wilson.co.uk> wrote:
> > We do need the write flush here (and set_data) as the next action is a
> > udelay loop which is not per-se a mb.
> 
> Now I am confused.  I915_WRITE_NOTRACE() calls writel(), which has an
> explicit mb();  Why do you need another mb?

Nominally writel isn't a memory barrier. I see that x86 does include mb
in its writel define. However, if memory serves, that is only a write
barrier to memory (equivalent of mfence), and not a PCI write flush/barrier
for which we need to an explicit PCI read.
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
