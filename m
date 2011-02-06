Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752491Ab1BFMYN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 07:24:13 -0500
Received: from webbox4.loswebos.de ([213.187.93.205]:35948 "EHLO
	webbox4.loswebos.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752045Ab1BFMYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 07:24:12 -0500
Date: Sun, 6 Feb 2011 13:24:08 +0100
From: Marc Koschewski <marc@osknowledge.org>
To: Takashi Iwai <tiwai@suse.de>
Cc: Jeff Chua <jeff.chua.linux@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Chris Wilson <chris@chris-wilson.co.uk>, Len Brown <lenb@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Commit 500f7147cf5bafd139056d521536b10c2bc2e154 breaks _resume_
Message-ID: <20110206122408.GD22960@marc.osknowledge.org>
References: <AANLkTi=h+H+N=f4m4pE+RZ4n5h7oxQuwzmK-qmmWAGtL@mail.gmail.com>
 <s5hfws1whq8.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5hfws1whq8.wl%tiwai@suse.de>
X-PGP-Fingerprint: D514 7DC1 B5F5 8989 083E 38C9 5ECF E5BD 3430 ABF5
X-PGP-Key: http://www.kosik.org/pubkey.asc
X-Blog: http://www.kosik.org/blog/
X-Operating-System: Linux marc 2.6.37-ck1-dezzy
User-Agent: Mutt/1.5.21hg (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Read this

	[REGRESSION g01539ba] Hibernate broken on T510i

or this

	[REGRESSION] S3 resume on SandyBridge doesn't work with NX protection (5bd5a45)

Marc

* Takashi Iwai <tiwai@suse.de> [2011-02-06 12:00:15 +0100]:

> At Sun, 6 Feb 2011 09:50:51 +0800,
> Jeff Chua wrote:
> > 
> > On Sun, Feb 6, 2011 at 2:24 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > >> The suspend monster is back! The suspend-to-ram is fine, but upon
> > >> resume, screen is blank. Haven't bisected in case someone has also
> > >> done so.
> > >
> > > BTW, please don't reply to messages containing patches with reports of problems
> > > that aren't caused by those patches.  It's confusing at best and at worst it
> > > may result in the patches being rejected.
> > 
> > Sorry. New subject now:)
> > 
> > 
> > On Sun, Feb 6, 2011 at 2:51 AM, Linus Torvalds
> > <torvalds@linux-foundation.org> wrote:
> > >> It's very recent. ... between commit
> > >> 831d52bc153971b70e64eccfbed2b232394f22f8 and
> > >> 44f2c5c841da1b1e0864d768197ab1497b5c2cc1.
> > >
> > > Hmm. It's almost certainly one of the DRI patches, but which one? I
> > > think bisection is the only way to figure it out. It shouldn't be too
> > > bad, since there's only 120 commits in that range.
> > >
> > > In fact, you can almost certainly just bisect from 89840966c579 to
> > > bb5b583b5279, which is just 31 commits and should get you bisected in
> > > just five tries or so.
> > 
> > Yea, I've just done that. It came down to the following commit.
> > Reverting it solves the problem. I've gone thru a few cycles, and
> > notebook still survives.
> 
> Hrm, what is the symptom?  I couldn't find it because you cut off the
> thread, and it's not cited.
> 
> The commit you mentioned just adds an interface, and the the callbacks
> aren't defined.  The real change is either in
>   commit f3269058e7a80083dcdf89698bfcd1a6c6f8fd12
>     drm/i915/crt: Force the initial probe after reset
> or
>   commit 5d1d0cc87fc0887921993ea0742932e0c8adeda0
>     drm/i915: Reset crtc after resume
> 
> Also the fix might interact with
>   commit 811aaa55ba21ab37407018cfc01770d6b037d3fb
>     drm: Only set DPMS ON when actually configuring a mode
> 
> 
> thanks,
> 
> Takashi
> 
> > 
> > Thanks,
> > Jeff
> > 
> > 
> > commit 500f7147cf5bafd139056d521536b10c2bc2e154
> > Author: Chris Wilson <chris@chris-wilson.co.uk>
> > Date:   Mon Jan 24 15:14:41 2011 +0000
> > 
> >     drm/i915: Reset state after a GPU reset or resume
> > 
> >     Call drm_mode_config_reset() after an invalidation event to restore any
> >     cached state to unknown.
> > 
> >     Tested-by: Takashi Iwai <tiwai@suse.de>
> >     Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> > 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 

-- 
Marc Koschewski
