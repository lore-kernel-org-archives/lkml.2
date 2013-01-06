Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753109Ab3AFUxV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2013 15:53:21 -0500
Received: from mail-wg0-f51.google.com ([74.125.82.51]:46424 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752294Ab3AFUxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2013 15:53:18 -0500
Date: Sun, 6 Jan 2013 21:55:11 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alexey Zaytsev <alexey.zaytsev@gmail.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Rodrigo Vivi <rodrigo.vivi@gmail.com>,
        Peter Ujfalusi <peter.ujfalusi@gmail.com>,
        stable <stable@vger.kernel.org>
Subject: Re: Linux 3.8-rc2
Message-ID: <20130106205511.GR5737@phenom.ffwll.local>
Mail-Followup-To: Linus Torvalds <torvalds@linux-foundation.org>,
	Alexey Zaytsev <alexey.zaytsev@gmail.com>,
	Chris Wilson <chris@chris-wilson.co.uk>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Jesse Barnes <jbarnes@virtuousgeek.org>,
	Rodrigo Vivi <rodrigo.vivi@gmail.com>,
	Peter Ujfalusi <peter.ujfalusi@gmail.com>,
	stable <stable@vger.kernel.org>
References: <CA+55aFxQ9vH70UrqC0ypm-diNbGcZbWbdhYa3FLH+0Vbrk4hUQ@mail.gmail.com>
 <CAB9v_DHJYAEcZDuPd3XBEib_nGca=_sKbZngV3z1N6H8KcJJGQ@mail.gmail.com>
 <CA+55aFzQtxET9JWdaLGi52OL=A9yRbj+vaa7RfniuBvfB5K04Q@mail.gmail.com>
 <6c3329$7ukf5e@orsmga002.jf.intel.com>
 <CAB9v_DE1gt6O=xvSpmkfhfoWxGSXjQ+SBFBK3gPQKm2OrhCk3w@mail.gmail.com>
 <CA+55aFw5hnByqQHhsOYgc14DHTejHqmWV=fW2pm4LuzF6UxwCQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFw5hnByqQHhsOYgc14DHTejHqmWV=fW2pm4LuzF6UxwCQ@mail.gmail.com>
X-Operating-System: Linux phenom 3.7.0-rc4+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 03, 2013 at 03:18:54PM -0800, Linus Torvalds wrote:
> On Thu, Jan 3, 2013 at 3:12 PM, Alexey Zaytsev <alexey.zaytsev@gmail.com> wrote:
> >
> > Chris: The patch does not seem to have any effect on the problem.
> >
> > Peter: I've attached the dmesgs, as well as the diff between the
> > interesting parts. The patch does not seem to make any difference
> > there.
> 
> Alexey, what happens if you just avoid the divide-by-zero? There might
> be other complications downstream, but something like the attached
> patch should at least avoid doing the "divide-by-clock" when clock is
> zero..

Yeah, that looks like the better duct-tape. For context, we're in the
middle of the long road to fastboot, i.e. taking over the output setup
done by the bios to avoid a costly modeset at boot-up (at least for
somewhat sane firmware which doesn't use legacy vga mode any more but the
native resolution of the panel). But since we don't yet read out the full
hw state some assumptions are now broken in our code, so we need to catch
them.

Chris has a more complete patch covering all the other
generations/code-paths accessing crtc->mode.clock (but lost you from cc).
I'll forward his patch asap (still digging through the mail flood from
vacation).

Cheers, Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
