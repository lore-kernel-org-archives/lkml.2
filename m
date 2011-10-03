Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932549Ab1JCUnK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 16:43:10 -0400
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:40895 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932195Ab1JCUnC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 16:43:02 -0400
Date: Mon, 3 Oct 2011 13:42:50 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Keith Packard <keithp@keithp.com>
Cc: Daniel Vetter <daniel@ffwll.ch>, Dave Airlie <airlied@redhat.com>,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [Intel-gfx] [PATCH 04/21] drm/i915: Only use VBT panel mode on
 eDP if no EDID is found
Message-ID: <20111003134250.54221856@jbarnes-desktop>
In-Reply-To: <yun4nzt9akd.fsf@aiko.keithp.com>
References: <20110923085243.6e4b7b4c@jbarnes-x220>
	<1317344993-24945-1-git-send-email-keithp@keithp.com>
	<1317344993-24945-5-git-send-email-keithp@keithp.com>
	<20110930163235.GD2859@phenom.ffwll.local>
	<yun4nzt9akd.fsf@aiko.keithp.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Sep 2011 10:58:26 -0700
Keith Packard <keithp@keithp.com> wrote:

> On Fri, 30 Sep 2011 18:32:35 +0200, Daniel Vetter <daniel@ffwll.ch> wrote:
> 
> > Ok, this is way over my head, just checked whether the patch does what it
> > claims to - nice exercise in reading dp modeset code ;-)
> 
> Yeah, it's purely heuristic -- the VBT contains a mode which was
> originally for the LVDS. It's unclear whether it should ever be applied
> to an eDP panel, but absent other information, it seems like we should
> at least consider it.
> 
> Many LVDS panels don't bother to include an EDID rom, or the vendor
> didn't bother to hook up the DDC wire; presumably it's cheaper for them
> to stick more data in the VBIOS than add hardware.  However, there are
> some LVDS panels with EDID roms which contain *incorrect* mode data for
> the panel (amazing, I know), and so the driver prefers to use the VBT
> data when both are present.
> 
> eDP, on the other hand, doesn't require any additional wiring (at least)
> to connect up the DDC channel, and eDP panels are required to provide
> EDID data. So far, in my (very small) sample set, I've got one machine
> which provides accurate VBT *and* EDID data (an HP 2540p) and one
> machine which provides inaccurate VBT data but accurate EDID data (a
> MacBook air). So, I just decided to prefer the EDID data.
> 
> One option would be to extract the current mode from the hardware when
> the driver starts and use that if present. But, that might mean that
> you'd get different modes depending on whether the machine booted with
> the lid closed or open, which seems like a bad plan.

More than that, I think eDP *requires* an EDID, and it sounds like even
the Air has one (and if any machine didn't, you know it would be an
Apple).

So I'm definitely in favor of this change.

-- 
Jesse Barnes, Intel Open Source Technology Center
