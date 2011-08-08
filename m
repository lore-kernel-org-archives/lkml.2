Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754315Ab1HHSuJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 14:50:09 -0400
Received: from oproxy5-pub.bluehost.com ([67.222.38.55]:42686 "HELO
	oproxy5-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750843Ab1HHSuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 14:50:07 -0400
Date: Mon, 8 Aug 2011 11:49:54 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Keith Packard <keithp@keithp.com>
Cc: Dave Airlie <airlied@redhat.com>, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: [Intel-gfx] [PATCH 2/4] drm/i915: Leave LVDS registers unlocked
Message-ID: <20110808114954.23b62dd3@jbarnes-desktop>
In-Reply-To: <yunr54vu4lr.fsf@aiko.keithp.com>
References: <1312653248-3487-1-git-send-email-keithp@keithp.com>
	<1312653248-3487-3-git-send-email-keithp@keithp.com>
	<20110808093010.487c4559@jbarnes-desktop>
	<yunr54vu4lr.fsf@aiko.keithp.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 08 Aug 2011 11:42:56 -0700
Keith Packard <keithp@keithp.com> wrote:

> On Mon, 8 Aug 2011 09:30:10 -0700, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> 
> > Yep, looks fine.  The only think we might want to sprinkle about are
> > checks for panel off so we can avoid visible corruption if we whack
> > timing or fb stuff while the panel is on.
> 
> So, I'd like to know if we could unlock the panel registers on pre-PCH
> hardware as well at init time; that way I could remove the unlock code
> From intel_lvds_prepare too. Should it be possible to set the
> PANEL_UNLOCK_REGS bits for pre-PCH hardware without having the target off?

Yep, it's safe and possible to do on pre-PCH as well.  For panel
fitting we do need to do an actual power cycle when going from
non-native back to native iirc, but we can still leave them unlocked so
we don't have to worry about the lock/unlock sequence everywhere.

-- 
Jesse Barnes, Intel Open Source Technology Center
