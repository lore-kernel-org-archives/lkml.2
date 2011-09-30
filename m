Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932134Ab1I3RZP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 13:25:15 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:51976 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755149Ab1I3RZN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 13:25:13 -0400
Date: Fri, 30 Sep 2011 19:25:47 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Keith Packard <keithp@keithp.com>
Cc: Dave Airlie <airlied@redhat.com>, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: [Intel-gfx] [PATCH 09/21] drm/i915: Delay DP i2c initialization
 until panel power timings are computed
Message-ID: <20110930172547.GI2859@phenom.ffwll.local>
Mail-Followup-To: Keith Packard <keithp@keithp.com>,
	Dave Airlie <airlied@redhat.com>, intel-gfx@lists.freedesktop.org,
	linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
References: <20110923085243.6e4b7b4c@jbarnes-x220>
 <1317344993-24945-1-git-send-email-keithp@keithp.com>
 <1317344993-24945-10-git-send-email-keithp@keithp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317344993-24945-10-git-send-email-keithp@keithp.com>
X-Operating-System: Linux phenom 3.1.0-rc4+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 29, 2011 at 06:09:41PM -0700, Keith Packard wrote:
> On eDP, DDC requires panel power, but turning that on uses the panel
> power sequencing timing values fetch from the DPCD data.
> 
> Signed-off-by: Keith Packard <keithp@keithp.com>
Can't really check more than what the patch does what it claims to do, so
a weak:
Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>

And a small question from the clueless: With your patch
intel_dp_i2c_auch_ch checks whether panel or vdd is on, but I don't see
where we turn that on and the drm dp i2c core seems to do a few
transactions on setup time. Should we splatter a vdd_on/off around the
i2c_init or is the panel guaranteed to have power at init time?
-Daniel
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
