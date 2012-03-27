Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753658Ab2C0HyK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 03:54:10 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:43133 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752581Ab2C0HyG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 03:54:06 -0400
Date: Tue, 27 Mar 2012 09:54:48 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Daniel Kurtz <djkurtz@chromium.org>
Cc: Keith Packard <keithp@keithp.com>, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Benson Leung <bleung@chromium.org>, Yufeng Shen <miletus@chromium.org>
Subject: Re: [PATCH 02/11 v3] drm/i915/intel_i2c: assign HDMI port D to pin
 pair 6
Message-ID: <20120327075448.GC4276@phenom.ffwll.local>
Mail-Followup-To: Daniel Kurtz <djkurtz@chromium.org>,
	Keith Packard <keithp@keithp.com>, David Airlie <airlied@linux.ie>,
	dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
	Chris Wilson <chris@chris-wilson.co.uk>,
	Benson Leung <bleung@chromium.org>,
	Yufeng Shen <miletus@chromium.org>
References: <1332772010-19619-1-git-send-email-djkurtz@chromium.org>
 <1332772010-19619-3-git-send-email-djkurtz@chromium.org>
 <20120326144711.GO4014@phenom.ffwll.local>
 <20120326150835.GQ4014@phenom.ffwll.local>
 <CAGS+omAkRiVMJCEK5eyEvWrVEZxCqyjkd3ocNZq=69mC29o-PA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGS+omAkRiVMJCEK5eyEvWrVEZxCqyjkd3ocNZq=69mC29o-PA@mail.gmail.com>
X-Operating-System: Linux phenom 3.2.0-1-amd64
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 27, 2012 at 01:49:51AM +0800, Daniel Kurtz wrote:
> I'm not sure what a "Bspec" is, but here is the documents I used:
> 
> [DevSNB+]: http://intellinuxgraphics.org/documentation/SNB/IHD_OS_Vol3_Part3.pdf
> Section 2.2.2 lists the 6 gmbus ports (gpio pin pairs):
>   [ 5: HDMI/DPD, 4: HDMIB, 3: HDMI/DPC, 2: LVDS, 1: SSC, 0: VGA ]
> 2.2.2.1 lists the GPIO registers to control these 6 ports.
> 2.2.3.1 lists the mapping between 5 of these gmbus ports and the 3
> Pin_Pair_Select bits (of the GMBUS0 register).  This table is missing
> HDMIB (port 101).
> 
> [DevIBX]: http://intellinuxgraphics.org/IHD_OS_Vol3_Part3r2.pdf
> Section 2.2.2 lists the same 6 gmbus ports plus two 'reserved' gpio ports.
> 2.2.2.1 lists 8 GPIO registers... however, it says the size of the
> block is 6x32, which implies that those 2 reserved GPIO registers
> (GPIO_6 & GPIO_7) don't actually exist (or are irrelevant).
> 2.2.3.1 lists the mapping between the 6 named gmbus ports and the 3
> Pin_Pair_Select bits (of the GMBUS0 register).  This table has HDMIB.

Exactly this. Bspec is the internal name for what these public docs are
based on. When fixing up an inconsistency wrt the docs it's always good to
cite it like this, so that later on people can cross check. And we need
section numbers because they are the most stable - Internal Bspec is just
a collection of individual sections as html pages. And hw people also tend
to use the same sections for the same stuff in newer/older chips.

Cheers, Daniel
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
