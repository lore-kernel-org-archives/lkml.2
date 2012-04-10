Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757611Ab2DJKk5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 06:40:57 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:39611 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753616Ab2DJKk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 06:40:56 -0400
Date: Tue, 10 Apr 2012 12:41:47 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Daniel Kurtz <djkurtz@chromium.org>, Keith Packard <keithp@keithp.com>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>,
        Benson Leung <bleung@chromium.org>, Yufeng Shen <miletus@chromium.org>
Subject: Re: [PATCH 4/8 v7] drm/i915/intel_i2c: use WAIT cycle, not STOP
Message-ID: <20120410104147.GI4115@phenom.ffwll.local>
Mail-Followup-To: Daniel Kurtz <djkurtz@chromium.org>,
	Keith Packard <keithp@keithp.com>, David Airlie <airlied@linux.ie>,
	dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
	Chris Wilson <chris@chris-wilson.co.uk>,
	Benson Leung <bleung@chromium.org>,
	Yufeng Shen <miletus@chromium.org>
References: <1333108003-6341-1-git-send-email-djkurtz@chromium.org>
 <1333108003-6341-5-git-send-email-djkurtz@chromium.org>
 <20120410103746.GH4115@phenom.ffwll.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120410103746.GH4115@phenom.ffwll.local>
X-Operating-System: Linux phenom 3.2.0-1-amd64
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 10, 2012 at 12:37:46PM +0200, Daniel Vetter wrote:
> On Fri, Mar 30, 2012 at 07:46:39PM +0800, Daniel Kurtz wrote:
> > The i915 is only able to generate a STOP cycle (i.e. finalize an i2c
> > transaction) during a DATA or WAIT phase.  In other words, the
> > controller rejects a STOP requested as part of the first transaction in a
> > sequence.
> > 
> > Thus, for the first transaction we must always use a WAIT cycle, detect
> > when the device has finished (and is in a WAIT phase), and then either
> > start the next transaction, or, if there are no more transactions,
> > generate a STOP cycle.
> > 
> > Note: Theoretically, the last transaction of a multi-transaction sequence
> > could initiate a STOP cycle.  However, this slight optimization is left
> > for another patch.  We return -ETIMEDOUT if the hardware doesn't
> > deactivate after the STOP cycle.
> > 
> > Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
> 
> I've re-read gmbus register spec and STOP seems to be allowed even in the
> first cycle. Does this patch solve an issue for you? If not, I prefer we
> just drop it.

Actually I'd like to keep the -ETIMEDOUT return value, so maybe we should
keeep that hunk. I've picked up the previous 3 patches of this series, the
once after this one here conflict (without this patch here).
-Daniel
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
