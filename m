Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754903Ab2BFMMT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 07:12:19 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:61046 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754667Ab2BFMMR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 07:12:17 -0500
MIME-Version: 1.0
In-Reply-To: <20120127103010.GB3901@phenom.ffwll.local>
References: <1327508186-26704-1-git-send-email-keithp@keithp.com>
	<1327508186-26704-2-git-send-email-keithp@keithp.com>
	<20120127103010.GB3901@phenom.ffwll.local>
Date: Mon, 6 Feb 2012 12:12:16 +0000
Message-ID: <CAPM=9tyg6Ju8qi+Qy0XP-23wApGA3+12jDfd7KQRoZ_bqSH=4g@mail.gmail.com>
Subject: Re: [Intel-gfx] [PATCH 1/2] drm/i915: Force explicit bpp selection
 for intel_dp_link_required
From: Dave Airlie <airlied@gmail.com>
To: Keith Packard <keithp@keithp.com>, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Lubos Kolouch <lubos.kolouch@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 27, 2012 at 10:30 AM, Daniel Vetter <daniel@ffwll.ch> wrote:
> On Wed, Jan 25, 2012 at 08:16:25AM -0800, Keith Packard wrote:
>> It is never correct to use intel_crtc->bpp in intel_dp_link_required,
>> so instead pass an explicit bpp in to this function. This patch
>> only supports 18bpp and 24bpp modes, which means that 10bpc modes will
>> be computed incorrectly. Fixing that will require more extensive
>> changes, and so must be addressed separately from this bugfix.
>>
>> intel_dp_link_required is called from intel_dp_mode_valid and
>> intel_dp_mode_fixup.
>>
>> * intel_dp_mode_valid is called to list supported modes; in this case,
>>   the current crtc values cannot be relevant as the modes in question
>>   may never be selected. Thus, using intel_crtc->bpp is never right.
>>
>> * intel_dp_mode_fixup is called during mode setting, but it is run
>>   well before ironlake_crtc_mode_set is called to set intel_crtc->bpp,
>>   so using intel_crtc-bpp in this path can only ever get a stale
>>   value.
>>
>> Cc: Lubos Kolouch <lubos.kolouch@gmail.com>
>> Cc: Adam Jackson <ajax@redhat.com>
>> Signed-off-by: Keith Packard <keithp@keithp.com>
>
> Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=42263
> Tested-by: camalot@picnicpark.org (Dell Latitude 6510)
>
> Not the original reporter and might not exactly be this bug, but likely.
> -Daniel

Tested-by: Dave Airlie <airlied@redhat.com>

Without this patch the eDP panel on my HP 2540p won't resume.

Please get this into -fixes and too me asap.

Dave.
