Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753426Ab2ABVaK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jan 2012 16:30:10 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:60483 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752606Ab2ABVaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jan 2012 16:30:08 -0500
MIME-Version: 1.0
X-Originating-IP: [178.83.130.250]
In-Reply-To: <20120102080905.3ab2de84@x220>
References: <20111221195410.5e4c065a@x220.fritz.box>
	<864nwty9sq.fsf@sumi.keithp.com>
	<20111221222626.0b8c3a30@x220.fritz.box>
	<861urxy1pw.fsf@sumi.keithp.com>
	<20111222014520.7ace1ab2@x220.fritz.box>
	<20111222080928.GA3904@phenom.ffwll.local>
	<20120102080905.3ab2de84@x220>
Date: Mon, 2 Jan 2012 22:30:07 +0100
X-Google-Sender-Auth: LITYnJ12ukhy1eLkllONxqRsprg
Message-ID: <CAKMK7uGgoomEO7=WJkKw1sHMthLuPH11mS0-d7sv82yaikMspw@mail.gmail.com>
Subject: Re: GPU hung with Linux-3.2-rc6
From: Daniel Vetter <daniel@ffwll.ch>
To: Udo Steinberg <udo@hypervisor.org>
Cc: Keith Packard <keithp@keithp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 2, 2012 at 08:09, Udo Steinberg <udo@hypervisor.org> wrote:
> On Thu, 22 Dec 2011 09:22:33 +0100 Daniel Vetter (DV) wrote:
>
> DV> Can you please apply the patch available at
> DV>
> DV> http://cgit.freedesktop.org/~danvet/drm/patch/?id=0b3ecfa8c9b00f50d514fbcc12e34882b0fa695a
> DV>
> DV> This one will let your gpu keep hanging in the "stuck on semphore wait"
> DV> condition. Later on the hangcheck should kick in and grab a gpu error
> DV> state (in the file i915_error_state in debugfs). Can you please attach
> DV> that one?
>
> Hi,
>
> i915_error_state and dmesg are attached. This was with Linux 3.2.0-rc6 and
> the aforementioned patch applied.

Thanks a lot for gathering the error state. It looks like the
semaphore code deadlocked, which should not have happened. Can you
please test with the my-next branch available at:

http://cgit.freedesktop.org/~danvet/drm/log/?h=my-next

It contains a few fixes for races (that might cause your issue) and
dumps some additional information into the error state. You need to
boot with i915.semaphores=1 because they're not enabled by default in
that tree.

Again, please attach the error state if the gpu hangs.

Yours, Daniel
-- 
Daniel Vetter
daniel.vetter@ffwll.ch - +41 (0) 79 364 57 48 - http://blog.ffwll.ch
