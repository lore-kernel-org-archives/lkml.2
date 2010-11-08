Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754720Ab0KHLeR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 06:34:17 -0500
Received: from dallas.jonmasters.org ([72.29.103.172]:47179 "EHLO
	dallas.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754516Ab0KHLeP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 06:34:15 -0500
Subject: Re: [bisected] offset display bug in i915
From: Jon Masters <jonathan@jonmasters.org>
To: James Courtier-Dutton <james.dutton@gmail.com>
Cc: Chris Wilson <chris@chris-wilson.co.uk>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <AANLkTimXxYw7WLr3SKQxX5-Tadt0EJTQQSbKsqsLJNiL@mail.gmail.com>
References: <1289211512.3916.383.camel@constitution.bos.jonmasters.org>
	 <b9dded$h0q3am@orsmga002.jf.intel.com>
	 <AANLkTimXxYw7WLr3SKQxX5-Tadt0EJTQQSbKsqsLJNiL@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Organization: World Organi[sz]ation of Broken Dreams
Date: Mon, 08 Nov 2010 06:34:33 -0500
Message-ID: <1289216073.3916.404.camel@constitution.bos.jonmasters.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 74.92.29.237
X-SA-Exim-Mail-From: jonathan@jonmasters.org
X-SA-Exim-Scanned: No (on dallas.jonmasters.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-11-08 at 11:26 +0000, James Courtier-Dutton wrote:
> On 8 November 2010 10:27, Chris Wilson <chris@chris-wilson.co.uk> wrote:
> > On Mon, 08 Nov 2010 05:18:32 -0500, Jon Masters <jonathan@jonmasters.org> wrote:
> >> Hi Chris,
> >>
> >> The following patch that you recently committed breaks my ASUS Eee PC
> >> 1015PEM by causing the display to be offset by about 1 inch (a few
> >> centimeters) when the mode is (re)set during boot. I previously posted
> >> both photographs and video of the problem in another "PROBLEM" thread.
> >
> > [snip]
> >
> >> I'll look at the patch. Either the EDID is *not* consistent (in which
> >> case, why are we not seeing other bugs like this?) or there is something
> >> specific to this system or panel used.
> >
> > Interesting. Or even downright bizarre! Can you disable the caching
> > (hopefully the patch is still revertible) and save the EDID
> > (/sys/class/drm/card0-LVDS-1/edid) periodically? Might be simplest just to
> > dump the EDID every time we probe the LVDS if it has changed.

> I have observed major corruption issues for kernel 2.6.37.

Sad to hear, but none of what you are describing is related to this bug.
This bug has to do specifically with a small patch that added cacheing
of EDID panel data under the assumption that it wouldn't change. It only
affects your display, not linker, library objects, file systems, or in
fact anything other than getting geometry and location on screen right.

> Going back to 2.6.36 stable restores things to normality.
> I unfortunately do not have time to track down the problem, but I
> thought I would mention it as it could be causing your problem.
> My problems were:
> Corrupting the library cache so that .so files failed to load any more.
> Corrupting .o files during compilation so that the linker did not even
> recognize them as .o files.
> Corrupted data between a DVB card and the recording on the HD.
> I am just mentioning it, because the cause might in fact be somewhere else.

You might have a bad compiler, be switching distro packages, who knows.
Perhaps you can file a detailed bug report explaining your problems on
the bugzilla.kernel.org, or followup with more detail (to a new thread).

Jon.


