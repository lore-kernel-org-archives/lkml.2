Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752404Ab1BGKCP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 05:02:15 -0500
Received: from webbox4.loswebos.de ([213.187.93.205]:60635 "EHLO
	webbox4.loswebos.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751723Ab1BGKCO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 05:02:14 -0500
Date: Mon, 7 Feb 2011 11:02:10 +0100
From: Marc Koschewski <marc@osknowledge.org>
To: Takashi Iwai <tiwai@suse.de>
Cc: Jeff Chua <jeff.chua.linux@gmail.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <lenb@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Commit 500f7147cf5bafd139056d521536b10c2bc2e154 breaks _resume_
Message-ID: <20110207100210.GB12725@marc.osknowledge.org>
References: <AANLkTi=h+H+N=f4m4pE+RZ4n5h7oxQuwzmK-qmmWAGtL@mail.gmail.com>
 <s5hfws1whq8.wl%tiwai@suse.de>
 <AANLkTi=iHL+eVPRPzFXRMBZkXU7nXwkeZQiQUcyqSS-H@mail.gmail.com>
 <AANLkTikE_Oa=HGhW3zpc_rdeBvOWckpZ6dfFWq=JnL9R@mail.gmail.com>
 <849307$bf0dak@azsmga001.ch.intel.com>
 <AANLkTi=Z1fCA1N47YaCh1tn=PCAAboWtNCUyUH-N3yUo@mail.gmail.com>
 <AANLkTik0eJVr1S5=bCO8kmkwCxYzLE_kh9C3ccpn+mWX@mail.gmail.com>
 <s5hy65suu7t.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5hy65suu7t.wl%tiwai@suse.de>
X-PGP-Fingerprint: D514 7DC1 B5F5 8989 083E 38C9 5ECF E5BD 3430 ABF5
X-PGP-Key: http://www.kosik.org/pubkey.asc
X-Blog: http://www.kosik.org/blog/
X-Operating-System: Linux marc 2.6.37-ck1-dezzy
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Takashi,

is this potentially breaking S3 resume with nouveau cards, too?

Regards,
Marc

* Takashi Iwai <tiwai@suse.de> [2011-02-07 09:25:42 +0100]:

> At Mon, 7 Feb 2011 13:02:46 +0800,
> Jeff Chua wrote:
> > 
> > On Mon, Feb 7, 2011 at 12:48 PM, Jeff Chua <jeff.chua.linux@gmail.com> wrote:
> > > On Sun, Feb 6, 2011 at 11:27 PM, Chris Wilson <chris@chris-wilson.co.uk> wrote:
> > >> One last step: move contents of intel_crtc_reset() back to
> > >> intel_crtc_init() one by one.
> > >>
> > >> The active flag is my suspicion. I was thinking that we brought up the
> > >> outputs in a similar manner upon resume as upon initial boot. On
> > >> reflection, this is the not case.
> > >>
> > >> However, the first action we take inside modesetting is to disable the
> > >> outputs about to be reconfigured. So setting active should be the right
> > >> course of action so that cleanup any residual state from resume.
> > >>
> > >> So I am intrigued as to which line is the cause, and just where the
> > >> machine becomes unresponsive...
> > >
> > > It's this line causing the problem.
> > >
> > > intel_crtc->active = true; /* force the pipe off on setup_init_config */
> > >
> > >
> > > When it's called before entering intel_crtc_reset(&intel_crtc->base),
> > > it works, but if called within the function, it doesn't work. Strange.
> > > Not sure whether is passing the correct value to to_intel_crtc(crtc)?
> > 
> > I've added printk() below and the function returns a different value
> > of intel_crtc.
> > 
> > 
> > static void intel_crtc_reset(struct drm_crtc *crtc)
> > {
> >         struct intel_crtc *intel_crtc = to_intel_crtc(crtc);
> >         printk("intel_crtc %p\n", intel_crtc); ===> intel_crtc ffff8802349d1000
> > 
> > }
> > 
> > printk("intel_crtc %p\n", intel_crtc); ===> intel_crtc ffff8802349d0000
> > intel_crtc_reset(&intel_crtc->base);
> 
> That's weird.  Since base is the first member, both intel_crtc and crtc
> must be identical.
> 
> 
> Takashi
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 

-- 
Marc Koschewski
