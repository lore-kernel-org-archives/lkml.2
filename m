Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757574Ab2BMW0M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 17:26:12 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:51156 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751639Ab2BMW0K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 17:26:10 -0500
Date: Mon, 13 Feb 2012 23:26:23 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Daniel Vetter <daniel@ffwll.ch>, Benson Leung <bleung@chromium.org>,
        keithp@keithp.com, airlied@linux.ie, djkurtz@chromium.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: [PATCH] drm/i915: Fix single msg gmbus_xfers writes
Message-ID: <20120213222623.GN5301@phenom.ffwll.local>
Mail-Followup-To: Chris Wilson <chris@chris-wilson.co.uk>,
	Benson Leung <bleung@chromium.org>, keithp@keithp.com,
	airlied@linux.ie, djkurtz@chromium.org,
	linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
References: <1328817797-4026-1-git-send-email-bleung@chromium.org>
 <20120213203838.GM5301@phenom.ffwll.local>
 <e0d58a$38gbj5@orsmga002.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e0d58a$38gbj5@orsmga002.jf.intel.com>
X-Operating-System: Linux phenom 3.2.0-1-amd64
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 13, 2012 at 09:49:35PM +0000, Chris Wilson wrote:
> On Mon, 13 Feb 2012 21:38:38 +0100, Daniel Vetter <daniel@ffwll.ch> wrote:
> > This here looks like just a white-space change. But your commit message
> > sounds like it's not jsut write's that are affected by this issue and need
> > to be fixed. Can you please clear up this for easily confused me?
> 
> It makes the write path similar to the read path. I admit to overlooking
> the single write message as everything I saw was always a write followed
> by a read. The patch looks correct, but I need to stare at it a bit more
> before I r-b.
> 
> However, the outstanding issue is that we need to separate the gmbus
> i2c adapter from the gpio i2c adapter in order for the pairing to work
> with the expectations of the i2c core.

There's another patch floating on dri-devel to add a gmbus_mutex. The
issue it tries to avoid is that multiple users corrupting each anothers
state when using the single gmbus controller. See "[PATCH] [PATCH]
drm/i915: Fix race condition in accessing GMBUS". Or have you thought of
another interaction that we need to sort out?
-Daniel
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
