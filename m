Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754146Ab3ACWGG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 17:06:06 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:38232 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753643Ab3ACWGD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 17:06:03 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFzQtxET9JWdaLGi52OL=A9yRbj+vaa7RfniuBvfB5K04Q@mail.gmail.com>
References: <CA+55aFxQ9vH70UrqC0ypm-diNbGcZbWbdhYa3FLH+0Vbrk4hUQ@mail.gmail.com>
	<CAB9v_DHJYAEcZDuPd3XBEib_nGca=_sKbZngV3z1N6H8KcJJGQ@mail.gmail.com>
	<CA+55aFzQtxET9JWdaLGi52OL=A9yRbj+vaa7RfniuBvfB5K04Q@mail.gmail.com>
Date: Thu, 3 Jan 2013 23:06:00 +0100
Message-ID: <CAJ4QQ2_qLd6kC0iz2OqqrGGJY0QyghO=4zo38r9qq5afR2ZhZw@mail.gmail.com>
Subject: Re: Linux 3.8-rc2
From: Peter Ujfalusi <peter.ujfalusi@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alexey Zaytsev <alexey.zaytsev@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Rodrigo Vivi <rodrigo.vivi@gmail.com>, stable <stable@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Thu, Jan 3, 2013 at 10:32 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Thu, Jan 3, 2013 at 1:09 PM, Alexey Zaytsev <alexey.zaytsev@gmail.com> wrote:
>>
>> i915 got broken on my machine (Lenovo ThinkPad SL500) by this -rc. The screen
>> goes blank after loading the module. I've bisected the problem to
>> b0a2658acb5bf9ca86b4aab011b7106de3af0add "drm/i915: don't disable
>> disconnected outputs".
>
> Hmm. Daniel - should I just revert it, or do you have a patch to
> possibly fix the divide-by-zero error in g4x_compute_wm0() (which may
> involve not getting that deep in the call chain to begin with or
> whatever)? Maybe that fixes the blank screen too without a revert..

I have reported the issue [1] which resulted the b0a2658 patch. My laptop
boots fine with 3.8-rc2+ but if I revert b0a2658 I have NULL pointer crash as
in bug report.

Alexey: to aim Daniel to figure out what is going on can you boot the kernel
with drm.debug=0x0e cmd line parameter?

[1] https://bugs.freedesktop.org/show_bug.cgi?id=58396

-- 
Péter
