Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757752Ab2C1OqD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 10:46:03 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:48129 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752007Ab2C1OqC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 10:46:02 -0400
Date: Wed, 28 Mar 2012 16:46:44 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Daniel Kurtz <djkurtz@chromium.org>, Daniel Vetter <daniel@ffwll.ch>,
        Keith Packard <keithp@keithp.com>, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Benson Leung <bleung@chromium.org>, Yufeng Shen <miletus@chromium.org>
Subject: Re: [PATCH 14/14 v5] drm/i915/intel_i2c: remove POSTING_READ() from
 gmbus transfers
Message-ID: <20120328144644.GB15551@phenom.ffwll.local>
Mail-Followup-To: Chris Wilson <chris@chris-wilson.co.uk>,
	Daniel Kurtz <djkurtz@chromium.org>,
	Keith Packard <keithp@keithp.com>, David Airlie <airlied@linux.ie>,
	dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
	Benson Leung <bleung@chromium.org>,
	Yufeng Shen <miletus@chromium.org>
References: <1332939117-6513-1-git-send-email-djkurtz@chromium.org>
 <1332939117-6513-15-git-send-email-djkurtz@chromium.org>
 <1332939924_127442@CP5-2952>
 <CAGS+omAJaEaGUNY6V=sGNOWHxhb3YRv2mPcuUwQV99ksvsNP4Q@mail.gmail.com>
 <1332945027_128384@CP5-2952>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1332945027_128384@CP5-2952>
X-Operating-System: Linux phenom 3.2.0-1-amd64
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 28, 2012 at 03:30:13PM +0100, Chris Wilson wrote:
> On Wed, 28 Mar 2012 21:21:42 +0800, Daniel Kurtz <djkurtz@chromium.org> wrote:
> > On Wed, Mar 28, 2012 at 9:05 PM, Chris Wilson <chris@chris-wilson.co.uk> wrote:
> > > We do need the write flush here (and set_data) as the next action is a
> > > udelay loop which is not per-se a mb.
> > 
> > Now I am confused.  I915_WRITE_NOTRACE() calls writel(), which has an
> > explicit mb();  Why do you need another mb?
> 
> Nominally writel isn't a memory barrier. I see that x86 does include mb
> in its writel define. However, if memory serves, that is only a write
> barrier to memory (equivalent of mfence), and not a PCI write flush/barrier
> for which we need to an explicit PCI read.

Yeah, I think for gmbus here we should only drop the POSTING_READ if we'll
read a register right afterwards anyway. Let's better be slightly paranoid
about this.
-Daniel
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
