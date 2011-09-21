Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752388Ab1IUDuR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 23:50:17 -0400
Received: from oproxy9.bluehost.com ([69.89.24.6]:42239 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751561Ab1IUDuP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 23:50:15 -0400
Date: Wed, 21 Sep 2011 09:20:01 +0530
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Keith Packard <keithp@keithp.com>
Cc: Dave Airlie <airlied@redhat.com>, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: [Intel-gfx] [PATCH 6/9] drm/i915: Make sure eDP power is on
 before using aux channel
Message-ID: <20110921092001.0b65bd3f@jbarnes-x220>
In-Reply-To: <1316470923-27832-7-git-send-email-keithp@keithp.com>
References: <1316470923-27832-1-git-send-email-keithp@keithp.com>
	<1316470923-27832-7-git-send-email-keithp@keithp.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.24.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 192.55.60.111 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Sep 2011 15:22:00 -0700
Keith Packard <keithp@keithp.com> wrote:

> The eDP panel may not be able to respond to aux channel communications
> unless it has power supplied. During mode setting, power may be
> cut-off during panel power sequencing. Make sure that any aux channel
> communications will work by forcing vdd power active as needed.
> 
> This also delays after turning power on and off to ensure that the
> panel is keeping up.
> 
> Signed-off-by: Keith Packard <keithp@keithp.com>

This one mixes up lots of cleanups plus the EDID read with the power
changes.  I'm worried about the VDD smashing as well; we have lots of
bugs in the PPS hardware around VDD vs full PPS.  We need to make sure
appropriate delays are in place when transitioning from one to another.

In what paths are we trying to do accesses without power applied?
Looks like mainly edid?

I see the next patch handles the timing stuff, I assume it's ok.

Jesse
