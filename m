Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755811Ab1J1NWb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 09:22:31 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:58284 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755755Ab1J1NWa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 09:22:30 -0400
Date: Fri, 28 Oct 2011 21:22:13 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: linux-kernel@vger.kernel.org, Keith Packard <keithp@keithp.com>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org
Subject: Re: [Known BUG?] i915 hang on 3.0.0-12 (Ubuntu 11.10 release)
Message-ID: <20111028132213.GA6003@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <20111028122235.GA5593@zhy>
 <e0d58a$21chp4@orsmga002.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <e0d58a$21chp4@orsmga002.jf.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 28, 2011 at 01:56:39PM +0100, Chris Wilson wrote:
> On Fri, 28 Oct 2011 20:22:35 +0800, Yong Zhang <yong.zhang0@gmail.com> wrote:
> > Hi,
> > 
> > Just got below error on Ubuntu-11.10 (kernel: 3.0.0-12-generic),
> > and after that my screen can't show normally.
> > No sure if it's a known issue.
> 
> No, that is the first time I've seen that. It looks as if the fence was
> not released, or reacquired, before the the batch was executed. (There
> is a later batch that also uses this buffer.)
> 
> The fence is programmed with:
>   fence[15] = 04e00001
>     valid, x-tiled, pitch: 512, start: 0x04e00000, size: 1048576
> 
> And the BLT command uses:
>   0x0df006b0:      0x54300004: XY_COLOR_BLT (rgb enabled, alpha enabled, dst tile 
> 0)
>   0x0df006b4:      0x03f00100:    format 8888, pitch 256, clipping disabled
>   0x0df006b8:      0x00000000:    (0,0)
>   0x0df006bc:      0x00140037:    (55,20)
>   0x0df006c0:      0x04e00000:    offset 0x04e00000
>   0x0df006c4:      0x00000000:    color
>   0x0df006c8:      0x54f00006: XY_SRC_COPY_BLT (rgb enabled, alpha enabled, src tile 0, dst tile 0)
>   0x0df006cc:      0x03cc0100:    format 8888, dst pitch 256, clipping disabled
>   0x0df006d0:      0x00000000:    dst (0,0)
>   0x0df006d4:      0x00140037:    dst (55,20)
>   0x0df006d8:      0x04e00000:    dst offset 0x04e00000
>   0x0df006dc:      0x012c0003:    src (3,300)
>   0x0df006e0:      0x00000400:    src pitch 1024
>   0x0df006e4:      0x08500000:    src offset 0x08500000
> 
> So we try to perform an undefined operation and the GPU hangs. I suspect
> this will be timing dependent, but if you can find a way to reproduce
> it, that would be very useful.

Just got it by accident when I'm browsing web with firefox & chromium,
and the machine has been running for a long time.

No reliable way to reproduce it for now :(

Thanks,
Yong
