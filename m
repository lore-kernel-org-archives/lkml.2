Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031324Ab2B2TMp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 14:12:45 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:47206 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030878Ab2B2TMn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 14:12:43 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of daniel@ffwll.ch designates 10.180.95.105 as permitted sender) smtp.mail=daniel@ffwll.ch; dkim=pass header.i=daniel@ffwll.ch
Date: Wed, 29 Feb 2012 20:12:58 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Daniel Kurtz <djkurtz@chromium.org>
Cc: Benson Leung <bleung@chromium.org>, keithp@keithp.com, airlied@linux.ie,
        chris@chris-wilson.co.uk, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [PATCH] drm/i915: Fix single msg gmbus_xfers writes
Message-ID: <20120229191258.GA28941@phenom.ffwll.local>
Mail-Followup-To: Daniel Kurtz <djkurtz@chromium.org>,
	Benson Leung <bleung@chromium.org>, keithp@keithp.com,
	airlied@linux.ie, chris@chris-wilson.co.uk,
	linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
References: <1328817797-4026-1-git-send-email-bleung@chromium.org>
 <20120215104837.GB4095@phenom.ffwll.local>
 <CAGS+omD8e9dBen_kQkoY+vc4yP6HCAeoNRYhzK+OPw+99HDoFg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGS+omD8e9dBen_kQkoY+vc4yP6HCAeoNRYhzK+OPw+99HDoFg@mail.gmail.com>
X-Operating-System: Linux phenom 3.2.0-1-amd64
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 20, 2012 at 07:22:00PM +0800, Daniel Kurtz wrote:
> On Feb 15, 2012 6:48 PM, "Daniel Vetter" <daniel@ffwll.ch> wrote:
> >
> > On Thu, Feb 09, 2012 at 12:03:17PM -0800, Benson Leung wrote:
> > > gmbus_xfer with a single message (particularly a single message write) would
> > > set Bus Cycle Select to 100b, the Gen Stop cycle, instead of 101b,
> > > No Index, Stop cycle. This would not start single message i2c transactions.
> > >
> > > Also, gmbus_xfer done: will disable the interface without checking if
> > > it is idle. In the case of writes, there will be no wait on status or delay
> > > to ensure the write starts and completes before the interface is turned off.
> > >
> > > Fixed the former issue by using the same cycle selection as used in the
> > > I2C_M_RD for the write case.
> > > GMBUS_CYCLE_WAIT | (i + 1 == num ? GMBUS_CYCLE_STOP : 0)
> > > Fixed the latter by waiting on GMBUS_ACTIVE to deassert before disable.
> > >
> > > Signed-off-by: Benson Leung <bleung@chromium.org>
> 
> Reviewed-by: Daniel Kurtz <djkurtz@chromium.org>

Queued for -next (with a grumpy noted added to the commit message), thanks
for the patch.
-Daniel
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
