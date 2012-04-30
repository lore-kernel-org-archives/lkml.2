Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752043Ab2D3HfF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 03:35:05 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33013 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751803Ab2D3HfD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 03:35:03 -0400
MIME-Version: 1.0
In-Reply-To: <4F9E39F1.5030600@kernel.org>
References: <4F9E39F1.5030600@kernel.org>
Date: Mon, 30 Apr 2012 10:35:02 +0300
X-Google-Sender-Auth: riqg2vxqEWplZ2pPLIrcI5Dj9Zs
Message-ID: <CAOJsxLE3A3b5HSrRm0NVCBmzv7AAs-RWEiZC1BL=se309+=WTA@mail.gmail.com>
Subject: Re: vmevent: question?
From: Pekka Enberg <penberg@kernel.org>
To: Minchan Kim <minchan@kernel.org>
Cc: linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Leonid Moiseichuk <leonid.moiseichuk@nokia.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Minchan,

On Mon, Apr 30, 2012 at 10:06 AM, Minchan Kim <minchan@kernel.org> wrote:
> vmevent_smaple gathers all registered values to report to user if vmevent match.
> But the time gap between vmevent match check and vmevent_sample_attr could make error
> so user could confuse.
>
> Q 1. Why do we report _all_ registered vmstat value?
>     In my opinion, it's okay just to report _a_ value vmevent_match happens.

It makes the userspace side simpler for "lowmem notification" use
case. I'm open to changing the ABI if it doesn't make the userspace
side too complex.

> Q 2. Is it okay although value when vmevent_match check happens is different with
>     vmevent_sample_attr in vmevent_sample's for loop?
>     I think it's not good.

Yeah, that's just silly and needs fixing.

> Q 3. Do you have any plan to change getting value's method?
>     Now it's IRQ context so we have limitation to get a vmstat values so that
>     It couldn't be generic. IMHO, To merge into mainline, we should solve this problem.

Yes, that needs fixing as well. I was hoping to reuse perf sampling
code for this.

> Q 4. Do you have any plan for this patchset to merge into mainline?

Yes, I'm interested in pushing it forward if we can show that the ABI
makes sense, is stable and generic enough, and fixes real world
problems.

                        Pekka
