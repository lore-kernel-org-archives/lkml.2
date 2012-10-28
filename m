Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751630Ab2J1CsA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2012 22:48:00 -0400
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:34989 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751096Ab2J1Cr6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2012 22:47:58 -0400
Date: Sun, 28 Oct 2012 11:47:53 +0900
From: Norbert Preining <preining@logic.at>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Dave Airlie <airlied@gmail.com>, linux-kernel@vger.kernel.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        dri-devel@lists.freedesktop.org
Subject: Re: drm i915 hangs on heavy io load
Message-ID: <20121028024753.GA4254@gamma.logic.tuwien.ac.at>
References: <20121023053830.GA30776@gamma.logic.tuwien.ac.at> <6c3329$6sai31@orsmga002.jf.intel.com> <20121023053830.GA30776@gamma.logic.tuwien.ac.at> <CAPM=9txr4TzuG-BbL0bXeEK6AzkOK9pH0kh-nP=Njv53sgFZew@mail.gmail.com> <20121024003659.GA30962@gamma.logic.tuwien.ac.at> <b94cdc$72fm1r@fmsmga001.fm.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b94cdc$72fm1r@fmsmga001.fm.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chris,

I haven't answered due to several reboots necessary (sometimes 
I have to work on Win***) and no effect, but ..

On Mi, 24 Okt 2012, Chris Wilson wrote:
> > > http://cgit.freedesktop.org/~danvet/drm/commit/?h=ilk-wa-pile&id=0d5fed2de763b49bb1a90140758153481f043757
> > > is the missing ingredient.
> > 
> > I am compiling a kernel with this patch based on current git now.
> > Should I still use the above kernel cmd argument (i915...rc6=0)
> > or try without it?
> 
> Without any rc6 parameter would be best. But if rc6=0 wasn't the
> solution for you, then I may have identified the wrong w/a. Can I ask
> you try the patches in that branch until you find one (or more perhaps)
> that stabilise your system?

I pulled the whole branch into my compile branch, and removed everything
from kernel cmd line regarding rc6, and got the
	[drm:i915_hangcheck_hung] *ERROR* Hangcheck timer elapsed... GPU hung
	[drm] capturing error event; look for more information in /debug/dri/0/i915_error_state
	[drm:i915_hangcheck_hung] *ERROR* Hangcheck timer elapsed... GPU hung
	[drm:i915_reset] *ERROR* GPU hanging too fast, declaring wedged!
	[drm:i915_reset] *ERROR* Failed to reset chip.
new i915_error_state.gz at the same place.

So it seems that the patches in the ilk-wa-pile branch do not help.

All the best

Norbert
------------------------------------------------------------------------
Norbert Preining            preining@{jaist.ac.jp, logic.at, debian.org}
JAIST, Japan                                 TeX Live & Debian Developer
DSA: 0x09C5B094   fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
------------------------------------------------------------------------
SCRONKEY (n.)
Something that hits the window as a result of a violent sneeze.
			--- Douglas Adams, The Meaning of Liff
