Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753495Ab2APIDE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 03:03:04 -0500
Received: from mga01.intel.com ([192.55.52.88]:45824 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752977Ab2APIDD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 03:03:03 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="107483910"
Date: Mon, 16 Jan 2012 16:02:53 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Keith Packard <keithp@keithp.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Takashi Iwai <tiwai@suse.de>,
        Michal Marek <mmarek@suse.com>,
        "intel-gfx@lists.freedesktop..." <intel-gfx@lists.freedesktop.org>,
        Robert Lemaire <rlemaire@suse.com>
Subject: Re: [PATCH] drm/i915: set AUD_CONFIG N_value_index for DisplayPort
Message-ID: <20120116080252.GA18538@localhost>
References: <20120109131717.GA4713@localhost>
 <86y5tgx02g.fsf@sumi.keithp.com>
 <20120110054519.GA27257@localhost>
 <86ty404yhd.fsf@sumi.keithp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86ty404yhd.fsf@sumi.keithp.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 12, 2012 at 09:33:34AM -0800, Keith Packard wrote:
> On Tue, 10 Jan 2012 13:45:19 +0800, Wu Fengguang <fengguang.wu@intel.com> wrote:
> 
> > @@ -5943,6 +5947,7 @@ static void ironlake_write_eld(struct dr
> >  	if (intel_pipe_has_type(crtc, INTEL_OUTPUT_DISPLAYPORT)) {
> >  		DRM_DEBUG_DRIVER("ELD: DisplayPort detected\n");
> >  		eld[5] |= (1 << 2);	/* Conn_Type, 0x1 = DisplayPort */
> > +		I915_WRITE(aud_config, AUD_CONFIG_N_VALUE_INDEX); /* 0x1 = DP */
> >  	}
> 
> Do we need to clear this bit in the HDMI case? Or do we just trust the
> BIOS to either leave this bit zero or set it correctly?

I tried booting

1) with HDMI monitor plugged
2) plug HDMI monitor after BIOS boot

In both cases, I get the same AUD_CONFIG values for the host/sink matrix

                RX-V1800        SONY TV
ivybridge       0x00000000      0x00000000
ironlake        0x00000000      0x00000000

HDMI audio is working fine in all cases. So I guess it's fine to leave
HDMI as (unconfigured) 0.

Thanks,
Fengguang
