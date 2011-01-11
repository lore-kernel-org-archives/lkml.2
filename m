Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753584Ab1AKTyu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 14:54:50 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55902 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751311Ab1AKTyq convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 14:54:46 -0500
MIME-Version: 1.0
In-Reply-To: <20110111114505.0bd854c7@jbarnes-desktop>
References: <alpine.DEB.2.00.1101102250090.15019@skynet.skynet.ie>
 <AANLkTinW8Yp1K1w+G+BgLa-fPaFANkGsRjqH_W8N+9VL@mail.gmail.com>
 <AANLkTim5oVZqMBtan5_TMOxaWbqkF=aDcBYFNYy55kt_@mail.gmail.com>
 <0aea052d-70ff-41ea-8776-c6d974c10337@email.android.com> <AANLkTim0rn7Vem6YJM5tVKM0PX4YdnNmaeqmpS=Vp7rc@mail.gmail.com>
 <AANLkTi=eRHbgerpdPYdoOo45LruNTk0rNsWvOO-kYxyQ@mail.gmail.com>
 <20110111111203.279eae50@jbarnes-desktop> <AANLkTikMMG1S6qp0-jKnQUcR5DgC+WWVfgOo2PExFA2w@mail.gmail.com>
 <20110111114505.0bd854c7@jbarnes-desktop>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 11 Jan 2011 11:53:52 -0800
Message-ID: <AANLkTi=N-_+PMhArU7i+6U9ZABDiedXwaZPdSYDrTi6C@mail.gmail.com>
Subject: Re: [git pull] drm for rc1
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Dave Airlie <airlied@gmail.com>, Dave Airlie <airlied@linux.ie>,
        Chris Wilson <chris@chris-wilson.co.uk>, Eric Anholt <eric@anholt.net>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, linux-kernel@vger.kernel.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 11, 2011 at 11:45 AM, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
>>
>> Maybe the screen just has to be inactive for a longer time: do you do
>> some dynamic "let's power things down if nothing is changing"?
>
> There are some timeouts, the FBC engine will recompress about once
> every 15s; the self-refresh timers are much smaller though so it should
> be active anytime the CPU enters a deep sleep state.  The clock
> frequency changes in millisecond time too, you can check the status of
> that in /sys/kernel/debug/dri/0/i915_drpc_status and i915_cur_delayinfo.

I assume you meant "info", not "status". If so, that doesn't look all
that interesting:

  [torvalds@i5 linux]$ cat /sys/kernel/debug/dri/0/i915_drpc_info
  HD boost: no
  Boost freq: 0
  HW control enabled: no
  SW control enabled: no
  Gated voltage change: no
  Starting frequency: P0
  Max P-state: P0
  Min P-state: P0
  RS1 VID: 0
  RS2 VID: 38
  Render standby enabled: yes
  [torvalds@i5 linux]$ cat /sys/kernel/debug/dri/0/i915_cur_delayinfo
  Requested P-state: 0
  Requested VID: 0
  Current VID: 37
  Current P-state: 0

(This is in the "working state" - I rebooted because I can't stand
working with a machine that feels like a 110baud terminal).

> I wonder if re-enabling rc6 may have caused your issues?  That would be:
>
> commit 29a15061ff5df5bf9bf49c05c17f41eb2807a55a

I don't have this commit at all, it wasn't part of the merged series.

                            Linus
