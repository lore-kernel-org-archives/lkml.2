Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758696Ab2C2JPM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 05:15:12 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:36256 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750932Ab2C2JPE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 05:15:04 -0400
Date: Thu, 29 Mar 2012 11:15:47 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Daniel Kurtz <djkurtz@chromium.org>
Cc: Chris Wilson <chris@chris-wilson.co.uk>, Daniel Vetter <daniel@ffwll.ch>,
        Keith Packard <keithp@keithp.com>, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Benson Leung <bleung@chromium.org>, Yufeng Shen <miletus@chromium.org>
Subject: Re: [PATCH 2/7 v6] drm/i915/intel_i2c: use double-buffered writes
Message-ID: <20120329091547.GE4106@phenom.ffwll.local>
Mail-Followup-To: Daniel Kurtz <djkurtz@chromium.org>,
	Chris Wilson <chris@chris-wilson.co.uk>,
	Keith Packard <keithp@keithp.com>, David Airlie <airlied@linux.ie>,
	dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
	Benson Leung <bleung@chromium.org>,
	Yufeng Shen <miletus@chromium.org>
References: <1332959199-32161-1-git-send-email-djkurtz@chromium.org>
 <1332959199-32161-3-git-send-email-djkurtz@chromium.org>
 <1332960093_131068@CP5-2952>
 <CAGS+omBkrjdrweGxS5r7KFyqx=JFVxy7_tqZsWTaGgfXu-VgtQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGS+omBkrjdrweGxS5r7KFyqx=JFVxy7_tqZsWTaGgfXu-VgtQ@mail.gmail.com>
X-Operating-System: Linux phenom 3.2.0-1-amd64
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 29, 2012 at 04:46:39PM +0800, Daniel Kurtz wrote:
> On Thu, Mar 29, 2012 at 2:41 AM, Chris Wilson <chris@chris-wilson.co.uk> wrote:
> > On Thu, 29 Mar 2012 02:26:34 +0800, Daniel Kurtz <djkurtz@chromium.org> wrote:
> >> The GMBUS controller GMBUS3 register is double-buffered.  Take advantage
> >> of this  by writing two 4-byte words before the first wait for HW_RDY.
> >> This helps keep the GMBUS controller from becoming idle during long writes.
> >>
> >> Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
> >
> > "For byte counts that are greater than four bytes, this register will be
> > written with subsequent data only after the HW_RDY status bit is set"
> >
> > Hmm, I had interpretted that as should only be. But if you take into
> > account that the register is indeed double-buffered, it does make sense
> > that the hardware itself is only updated after the HW_RDY signal.
> > Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
> 
> In fact, during my experiments using the GMBUS interrupts, the HW_RDY
> interrupt would only trigger for transactions > 4 bytes after 2 writes
> to GMBUS3.

I think that's rather important information. Can you add this to your
commit message?
-Daniel
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
