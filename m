Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932847Ab2CZPch (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 11:32:37 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:55394 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932663Ab2CZPcf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 11:32:35 -0400
Date: Mon, 26 Mar 2012 17:33:18 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Daniel Kurtz <djkurtz@chromium.org>
Cc: Keith Packard <keithp@keithp.com>, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Daniel Vetter <daniel@ffwll.ch>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Benson Leung <bleung@chromium.org>, Yufeng Shen <miletus@chromium.org>
Subject: Re: [PATCH 00/11 v3] fix gmbus writes and related issues
Message-ID: <20120326153318.GX4014@phenom.ffwll.local>
Mail-Followup-To: Daniel Kurtz <djkurtz@chromium.org>,
	Keith Packard <keithp@keithp.com>, David Airlie <airlied@linux.ie>,
	dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
	Chris Wilson <chris@chris-wilson.co.uk>,
	Benson Leung <bleung@chromium.org>,
	Yufeng Shen <miletus@chromium.org>
References: <1332772010-19619-1-git-send-email-djkurtz@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1332772010-19619-1-git-send-email-djkurtz@chromium.org>
X-Operating-System: Linux phenom 3.2.0-1-amd64
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 26, 2012 at 10:26:39PM +0800, Daniel Kurtz wrote:
> This patchset addresses a couple of issues with the i915 gmbus implementation:
>  * fixes misassigned pin port pair for HDMI-D
>  * fixes write transactions when they are the only transaction requested
>    (including large >4-byte writes) by terminating every transaction with a
>    WAIT cycle.
>  * returns -ENXIO and -ETIMEDOUT as appropriate so upper layers can handled
>    i2c transaction failures
>  * optimizes the typical read transaction case by using the INDEX cycle
> v3:
>  * rebased onto Daniel Vetter's drm-intel-next-queued branch
>    at git://people.freedesktop.org/~danvet/drm-intel
>  * replace intel_i2c_quirk_xfer with pre/post_xfer i2c routines
>  * pre-allocate gmbus array
>  * drop interrupt approach since I could not make it stable, probably due to
>    difficulty in clearing and resetting the GMBUS interrupt which is buffered
>    behind the SDE's PCH interrupt.
>  * Fix zero-length writes
>  * Wait for IDLE before clearing NAK

Ok, I've found a few more things to complain about ;-) I haven't looked to
closely add the later patches that fix up the actual gmbus code, but on a
quick read I don't see any issues there - I'll cross check the code
somewhen later with Bspec.

Yours, Daniel
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
