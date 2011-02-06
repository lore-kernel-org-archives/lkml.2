Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751923Ab1BFIUH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 03:20:07 -0500
Received: from webbox4.loswebos.de ([213.187.93.205]:33632 "EHLO
	webbox4.loswebos.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751803Ab1BFIUF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 03:20:05 -0500
Date: Sun, 6 Feb 2011 09:19:51 +0100
From: Marc Koschewski <marc@osknowledge.org>
To: Jeff Chua <jeff.chua.linux@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Takashi Iwai <tiwai@suse.de>,
        Chris Wilson <chris@chris-wilson.co.uk>, Len Brown <lenb@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Commit 500f7147cf5bafd139056d521536b10c2bc2e154 breaks _resume_
Message-ID: <20110206081950.GA12659@marc.osknowledge.org>
References: <AANLkTi=h+H+N=f4m4pE+RZ4n5h7oxQuwzmK-qmmWAGtL@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=h+H+N=f4m4pE+RZ4n5h7oxQuwzmK-qmmWAGtL@mail.gmail.com>
X-PGP-Fingerprint: D514 7DC1 B5F5 8989 083E 38C9 5ECF E5BD 3430 ABF5
X-PGP-Key: http://www.kosik.org/pubkey.asc
X-Blog: http://www.kosik.org/blog/
X-Operating-System: Linux marc 2.6.37-ck1-dezzy
User-Agent: Mutt/1.5.21hg (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

* Jeff Chua <jeff.chua.linux@gmail.com> [2011-02-06 09:50:51 +0800]:
> On Sun, Feb 6, 2011 at 2:24 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> >> The suspend monster is back! The suspend-to-ram is fine, but upon
> >> resume, screen is blank. Haven't bisected in case someone has also
> >> done so.
> >
> > BTW, please don't reply to messages containing patches with reports of problems
> > that aren't caused by those patches.  It's confusing at best and at worst it
> > may result in the patches being rejected.
> 
> Sorry. New subject now:)
> 
> 
> On Sun, Feb 6, 2011 at 2:51 AM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >> It's very recent. ... between commit
> >> 831d52bc153971b70e64eccfbed2b232394f22f8 and
> >> 44f2c5c841da1b1e0864d768197ab1497b5c2cc1.
> >
> > Hmm. It's almost certainly one of the DRI patches, but which one? I
> > think bisection is the only way to figure it out. It shouldn't be too
> > bad, since there's only 120 commits in that range.
> >
> > In fact, you can almost certainly just bisect from 89840966c579 to
> > bb5b583b5279, which is just 31 commits and should get you bisected in
> > just five tries or so.
> 
> Yea, I've just done that. It came down to the following commit.
> Reverting it solves the problem. I've gone thru a few cycles, and
> notebook still survives.
> 
> Thanks,
> Jeff

I reverted the specified commit and my box still suffers the
resume-turns-into-cold-boot behavior. Retried two times with the commit reverted
on top of HEAD...

Regards,
Marc

> 
> 
> commit 500f7147cf5bafd139056d521536b10c2bc2e154
> Author: Chris Wilson <chris@chris-wilson.co.uk>
> Date:   Mon Jan 24 15:14:41 2011 +0000
> 
>     drm/i915: Reset state after a GPU reset or resume
> 
>     Call drm_mode_config_reset() after an invalidation event to restore any
>     cached state to unknown.
> 
>     Tested-by: Takashi Iwai <tiwai@suse.de>
>     Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 

-- 
Marc Koschewski
