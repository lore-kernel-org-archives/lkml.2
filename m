Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758226Ab2HQPNE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 11:13:04 -0400
Received: from mga07.intel.com ([143.182.124.22]:53915 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754164Ab2HQPM5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 11:12:57 -0400
MIME-Version: 1.0
In-Reply-To: <86lihdbm1h.fsf@miki.keithp.com>
References: <1344918891-6283-1-git-send-email-keithp@keithp.com>
	<1344918891-6283-3-git-send-email-keithp@keithp.com>
	<CAPX-8+8euppecLhZu3XR95uM5e9m_kYmbJ6vmgBU=d03cs=RWA@mail.gmail.com>
	<86lihdbm1h.fsf@miki.keithp.com>
Date: Fri, 17 Aug 2012 16:12:54 +0100
Message-ID: <CAPX-8+-GOu33-pNUoHMz_OA5_h7U_-FZEvuGQZfE-b+Qe=JRjQ@mail.gmail.com>
Subject: Re: [Intel-gfx] [PATCH 2/7] drm/i915: FDI B/C share 4 lanes on Ivybridge
From: "Lespiau, Damien" <damien.lespiau@intel.com>
To: Keith Packard <keithp@keithp.com>
Cc: intel-gfx@lists.freedesktop.org, Daniel Vetter <daniel.vetter@ffwll.ch>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 17, 2012 at 4:00 PM, Keith Packard <keithp@keithp.com> wrote:
>> I guess this does not cover the case of pipe B using 3 lanes meaning
>> pipe C can use 1?
>
> It didn't look like that was a supported mode from the docs.

Ah yes, found it now "FDI B maximum port width is 4 lanes when FDI C
is disabled, 2 lanes when FDI C is enabled."

>> This duplicates the code just that is just a few lines away, instead
>> how about moving the logic to set target_clock up in front of this
>> whole if()?
>
> It's not the same, it's the inverse -- computing bpp from lanes+clock
> clock instead of computing lanes from bpp+clock. But, yeah, it would be
> nice to have these merged somehow. I couldn't figure out a good way though.

I meant the

> +               if (is_dp)
> +                       target_clock = mode->clock;
> +               else
> +                       target_clock = adjusted_mode->clock;

Just after that else block you have

        /* [e]DP over FDI requires target mode clock instead of link clock. */
        if (edp_encoder)
                target_clock = intel_edp_target_clock(edp_encoder, mode);
        else if (is_dp)
                target_clock = mode->clock;
        else
                target_clock = adjusted_mode->clock;

Those look strangely similar to me. The later could be moved up.

-- 
Damien
