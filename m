Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752664Ab1LIRWb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 12:22:31 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:47917 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751338Ab1LIRWa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 12:22:30 -0500
MIME-Version: 1.0
X-Originating-IP: [134.134.139.70]
In-Reply-To: <BAY151-W65C39B54A590BCA4E3AEBDA1B80@phx.gbl>
References: <BAY151-W65C39B54A590BCA4E3AEBDA1B80@phx.gbl>
Date: Fri, 9 Dec 2011 18:22:29 +0100
Message-ID: <CAKMK7uEm8=bGWxDSbLtOEM3CBmbMSH+gWrUy0Od327ozvjOd5g@mail.gmail.com>
Subject: Re: kernel BUG at drivers/gpu/drm/i915/i915_gem
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Rocko Requin <rockorequin@hotmail.com>
Cc: intel-gfx <intel-gfx@lists.freedesktop.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rocko,

Thanks for the bug report. Please report bugs always on the public
mailing list so that all interest people can join in (also I'm
travelling atm, so I can't do much).
Afaics we're hitting

BUG_ON(seqno == 0)

in wait_requst. Unfortunately you've cut out the backtrace from the
kernel oops, so I can't tell anything more.

Please add the full dmesg and the usual details about your macine.

Yours, Daniel

On Fri, Dec 9, 2011 at 00:11, Rocko Requin <rockorequin@hotmail.com> wrote:
> Hi Daniel,
>
> Since I applied commit eb1711bb94991e93669c5a1b5f84f11be2d51ea1 (drm/i915:
> fix infinite recursion on unbind due to ilk vt-d w/a) to my kernel yesterday
> afternoon, I've had the kernel lock up completely three times on me, so I'm
> assuming it might have been the cause. (I was previously using a kernel
> compiled from git on Dec 4th without problems.)
>
> The last lockup showed this in the syslog:
>
> Dec  9 06:23:15 sierra kernel: [44486.289428] kernel BUG at
> drivers/gpu/drm/i915/i915_gem.c:1952!
> Dec  9 06:23:15 sierra kernel: [44486.289460] invalid opcode: 0000 [#1] SMP
> ...
> Dec  9 06:23:15 sierra kernel: [44486.289844] RIP:
> 0010:[<ffffffffa02eccd3>]  [<ffffffffa02eccd3>]
> i915_wait_request+0x563/0x580 [i915]
>
> I have attached a longer version of the log (but note that it was truncated
> by the crash).
>
> I am booting the kernel with i915.i915_enable_rc6=1 but I didn't have any
> lockup issues until yesterday.
>
> Thanks,
> rocko



-- 
Daniel Vetter
daniel.vetter@ffwll.ch - +41 (0) 79 365 57 48 - http://blog.ffwll.ch
