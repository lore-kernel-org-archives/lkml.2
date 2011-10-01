Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755064Ab1JAJfj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Oct 2011 05:35:39 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:39114 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752300Ab1JAJfc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Oct 2011 05:35:32 -0400
Date: Sat, 1 Oct 2011 11:35:58 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Keith Packard <keithp@keithp.com>
Cc: Daniel Vetter <daniel@ffwll.ch>, Dave Airlie <airlied@redhat.com>,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [Intel-gfx] [PATCH 06/21] drm/i915: Unlock PCH_PP_CONTROL always
Message-ID: <20111001093558.GA2807@phenom.ffwll.local>
Mail-Followup-To: Keith Packard <keithp@keithp.com>,
	Dave Airlie <airlied@redhat.com>, intel-gfx@lists.freedesktop.org,
	linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
References: <20110923085243.6e4b7b4c@jbarnes-x220>
 <1317344993-24945-1-git-send-email-keithp@keithp.com>
 <1317344993-24945-7-git-send-email-keithp@keithp.com>
 <20110930170946.GF2859@phenom.ffwll.local>
 <yunty7t62sf.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yunty7t62sf.fsf@aiko.keithp.com>
X-Operating-System: Linux phenom 3.1.0-rc4+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 30, 2011 at 04:14:40PM -0700, Keith Packard wrote:
> On Fri, 30 Sep 2011 19:09:46 +0200, Daniel Vetter <daniel@ffwll.ch> wrote:
> 
> > grep shows that we also write to PCH_PP_CONTROL in intel_lvds.c in the
> > dpms functions - any reasons these two writes are left out?
> 
> Upon a bit of review:
> 
>   The bspec makes it clear that this write protect key only needs to
>   be written for eDP on DPA -- it's a work-around for a bug where panel
>   power sequencing wouldn't work right.
> 
>   The LVDS code does disable write protect in the _init function, which
>   seems global enough, but misses the resume case. We shouldn't ever
>   need to set this field though; it write protects registers only
>   when the panel is running. We could presumably remove the
>   write protect disable entirely in the LVDS code.
> 
> So, I think the patch as written is correct.

Convinced.
Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
