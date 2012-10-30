Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759868Ab2J3Azo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 20:55:44 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:43278 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755517Ab2J3Azn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 20:55:43 -0400
MIME-Version: 1.0
In-Reply-To: <20121030004958.GA6976@gamma.logic.tuwien.ac.at>
References: <6c3329$6sai31@orsmga002.jf.intel.com>
	<20121023053830.GA30776@gamma.logic.tuwien.ac.at>
	<CAPM=9txr4TzuG-BbL0bXeEK6AzkOK9pH0kh-nP=Njv53sgFZew@mail.gmail.com>
	<20121024003659.GA30962@gamma.logic.tuwien.ac.at>
	<b94cdc$72fm1r@fmsmga001.fm.intel.com>
	<20121028024753.GA4254@gamma.logic.tuwien.ac.at>
	<eeac1e$4q1mqm@AZSMGA002.ch.intel.com>
	<A941F80C-7EDB-4FCF-A8DE-4AE5532D2CB5@logic.at>
	<20121029071715.GA17023@mac.home>
	<20121030004958.GA6976@gamma.logic.tuwien.ac.at>
Date: Tue, 30 Oct 2012 10:55:42 +1000
Message-ID: <CAPM=9tw_0vDcRG25i2ypJEKT+JNqWzkXw2+jg=qj6H5M1hoJXg@mail.gmail.com>
Subject: Re: drm i915 hangs on heavy io load
From: Dave Airlie <airlied@gmail.com>
To: Norbert Preining <preining@logic.at>
Cc: Chris Wilson <chris@chris-wilson.co.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 30, 2012 at 10:49 AM, Norbert Preining <preining@logic.at> wrote:
> On Mo, 29 Okt 2012, Tino Keitel wrote:
>> Section "Device"
>>         Option     "AccelMethod" "SNA"
>>         Identifier  "Card0"
>>         Driver      "intel"
>> EndSection
>
> Thanks, running now with SNA. Let us see what happens.

Please don't, we ain't going to find the bug any quicker changing
variables, if the only thing that changed on your system was the
kernel then we need to figure out which kernel changes caused it and
remove them. Changing userspace is only complicating things and making
it less likely we'll ever find the regressions. Once we find the
regression, changing userspace optiosn to help understand it is more
reasonable.

How long does it take you to reproduce, and does it happen when in
actual use. On my laptop I've noticed I come back to it sometimes and
gnome-shell is dead. This never happened pre 3.7-rc's. But for me its
a 3-4 day window so far for it to die, which makes bisecting it a bit
of a major problem. and I'm just finished bisecting the last Ironlake
regression that took over a month.

I would suggest starting a bisect on drivers/gpu/drm/i915 from 3.6
final to 3.7-rc1 or maybe -rc2.

Dave.
