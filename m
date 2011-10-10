Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754607Ab1JJTbL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 15:31:11 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:60833 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834Ab1JJTbJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 15:31:09 -0400
MIME-Version: 1.0
In-Reply-To: <s5hy5wtxbmm.wl%tiwai@suse.de>
References: <1317721043.11231.2.camel@jmachine> <CAB=NE6X81KPvx-yt33MghmoftUznoP-jYO8sBxoeW_0fzQ1pdA@mail.gmail.com>
 <s5hy5wtxbmm.wl%tiwai@suse.de>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 10 Oct 2011 12:30:45 -0700
Message-ID: <CAB=NE6UWoFVA5-Jy7v87qbSkdujpX2Oki7EhNfihV2nY3BdTCQ@mail.gmail.com>
Subject: Re: [alsa-devel] Using spdiff for backporting
To: Takashi Iwai <tiwai@suse.de>
Cc: Jesper Andersen <jespera@gmail.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        alsa-devel@alsa-project.org, julia@diku.dk,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 10, 2011 at 5:41 AM, Takashi Iwai <tiwai@suse.de> wrote:
> At Fri, 7 Oct 2011 10:41:06 -0700,
> Luis R. Rodriguez wrote:
>>
>> > Also, in the slides from the plumbers-conf. I think I saw it mentioned
>> > that there's also an alsa-compat git-tree somewhere. Maybe that is a
>> > more compelling usecase? I was unable to find it though so I'd
>> > appreciate a link.
>>
>> It was on kernel.org, but if it got rm -rf'd then its gone as I do not
>> have a local copy.
>
> Oh, I didn't know of such a tree.  So you created alsa driver build
> system with your spdiff?  That's interesting.

Nope, this was pre-spdiff days. It was just a proof of concept I
wanted to make just to see how long it would take me to do it and how
clean it was. It was pretty trivial. I'm now working with Jesper on
seeing how best we can use spdiff for a unified backport of the
kernel.

>> The compat-alsa stuff though was determined to be
>> superflous with the ALSA's team's own backport work which is currently
>> independent.
>
> Yes, the external alsa-driver build tree has existed since 10 years
> ago :)  It was even possible to build with 2.2/2.4 kernels until
> recently.
>
> The current tree is found in github,
>        git://github.com/tiwai/alsa-driver-build.git

That's pretty darn impressive.

>> My hope though is to unify these through the compat.git /
>> compat-kernel (currently just called compat-wireless) effort.
>
> The common framework would be really nice to have.

Agreed!

> V4L also have own build system, and possible other subsystem trees too.

Heh, yeah for Video at least Ubuntu guys just backported a newer DRM
into their distro kernel. I feel as if a generic backport would make
more sense. I have already split out all generic kernel backport stuff
into its own module, compat.git, and anything else that cannot be
backported within an independent module we'e kept on compat-wireless.
compat-wireless at this point should really be called compat-net but
I've been lazy to rename it.

At plumbers I put together slides for metrics of what goes into compat
or compat-wireles, how many lines of code we pull and how much code
consists of backport work. The conclusion was with compat backporting
a new subsystem becomes proportionally easier. Then the legwork to
keep compat-wireless up to date can benefit from spdiff as the
spatches can eseentially generate new patches to help backport new
drivers after just two drivers get backported for a condition which
compat cannot address.

The slides are at:

http://bombadil.infradead.org/~mcgrof/presentations/backport/kernel-backport-for-good.pdf

  Luis
