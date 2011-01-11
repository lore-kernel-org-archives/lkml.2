Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932644Ab1AKTpO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 14:45:14 -0500
Received: from cpoproxy1-pub.bluehost.com ([69.89.21.11]:42085 "HELO
	cpoproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932577Ab1AKTpK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 14:45:10 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=bvV0nQNAWuL+vv4jAn6HLXB30T43D0VbrK21G39/hIiq3gv4ghMldZVfNxsGPv3GPqOhbTdvRgg4BVey8oWGUnyC9cpNOTRn72INY0WdpiAWOlcV0tFcVyTBbmVOvn1O;
Date: Tue, 11 Jan 2011 11:45:05 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Airlie <airlied@gmail.com>, Dave Airlie <airlied@linux.ie>,
        Chris Wilson <chris@chris-wilson.co.uk>, Eric Anholt <eric@anholt.net>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, linux-kernel@vger.kernel.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>
Subject: Re: [git pull] drm for rc1
Message-ID: <20110111114505.0bd854c7@jbarnes-desktop>
In-Reply-To: <AANLkTikMMG1S6qp0-jKnQUcR5DgC+WWVfgOo2PExFA2w@mail.gmail.com>
References: <alpine.DEB.2.00.1101102250090.15019@skynet.skynet.ie>
	<AANLkTinW8Yp1K1w+G+BgLa-fPaFANkGsRjqH_W8N+9VL@mail.gmail.com>
	<AANLkTim5oVZqMBtan5_TMOxaWbqkF=aDcBYFNYy55kt_@mail.gmail.com>
	<0aea052d-70ff-41ea-8776-c6d974c10337@email.android.com>
	<AANLkTim0rn7Vem6YJM5tVKM0PX4YdnNmaeqmpS=Vp7rc@mail.gmail.com>
	<AANLkTi=eRHbgerpdPYdoOo45LruNTk0rNsWvOO-kYxyQ@mail.gmail.com>
	<20110111111203.279eae50@jbarnes-desktop>
	<AANLkTikMMG1S6qp0-jKnQUcR5DgC+WWVfgOo2PExFA2w@mail.gmail.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.174.193.198 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Jan 2011 11:25:39 -0800
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Tue, Jan 11, 2011 at 11:12 AM, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> >
> > Have you tried reproducing it using xset dpms force off or similar?
> 
> That doesn't seem to do anything bad.
> 
> In fact, I think the second time it happened the screen never went
> black - just the random photo thing was on. But no, forcing the screen
> saver on doesn't do it either (ie pressing the "lock screen" icon and
> waiting for a few pictures to cycle).
> 
> Maybe the screen just has to be inactive for a longer time: do you do
> some dynamic "let's power things down if nothing is changing"?

There are some timeouts, the FBC engine will recompress about once
every 15s; the self-refresh timers are much smaller though so it should
be active anytime the CPU enters a deep sleep state.  The clock
frequency changes in millisecond time too, you can check the status of
that in /sys/kernel/debug/dri/0/i915_drpc_status and i915_cur_delayinfo.

I wonder if re-enabling rc6 may have caused your issues?  That would be:

commit 29a15061ff5df5bf9bf49c05c17f41eb2807a55a
Author: Jesse Barnes <jbarnes@virtuousgeek.org>
Date:   Wed Jan 5 12:01:24 2011 -0800

    drm/i915: re-enable rc6 support for Ironlake+

-- 
Jesse Barnes, Intel Open Source Technology Center
