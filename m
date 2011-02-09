Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753409Ab1BIJcP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 04:32:15 -0500
Received: from mga11.intel.com ([192.55.52.93]:29946 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752082Ab1BIJcN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 04:32:13 -0500
Message-Id: <b7da2f$qco1ng@fmsmga001.fm.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,446,1291622400"; 
   d="scan'208";a="885786352"
Date: Wed, 09 Feb 2011 09:32:09 +0000
To: Indan Zupancic <indan@nul.nu>, Jeff Chua <jeff.chua.linux@gmail.com>
Subject: Re: Commit 500f7147cf5bafd139056d521536b10c2bc2e154 breaks _resume_
Cc: Takashi Iwai <tiwai@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <lenb@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <AANLkTi=h+H+N=f4m4pE+RZ4n5h7oxQuwzmK-qmmWAGtL@mail.gmail.com> <s5hfws1whq8.wl%tiwai@suse.de> <AANLkTi=iHL+eVPRPzFXRMBZkXU7nXwkeZQiQUcyqSS-H@mail.gmail.com> <AANLkTikE_Oa=HGhW3zpc_rdeBvOWckpZ6dfFWq=JnL9R@mail.gmail.com> <849307$bf0dak@azsmga001.ch.intel. <AANLkTinYnehdaXn=Om-hVdo_U9N47BWFTgFoJbjpzuo=@mail.gmail.com> <d41841c1e5f524f976edea8cdd075238.squirrel@webmail.greenhost.nl>
From: Chris Wilson <chris@chris-wilson.co.uk>
In-Reply-To: <d41841c1e5f524f976edea8cdd075238.squirrel@webmail.greenhost.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Feb 2011 03:56:36 +0100 (CET), "Indan Zupancic" <indan@nul.nu> wrote:
> All in all it seems quite wrong, no matter if it happens to work, because
> it depends on the calling order done by the drm layer. If *_crtc_enable()
> is called instead it won't do anything because of that active = true thing.
> This seems to be happening in your case.

The order is very well defined.

modesetting (upon resume we set the previous mode):
  for each enabled crtc:
    crtc_helper->prepare -> intel_crtc_disable()
    crtc->mode_set -> intel_crtc_mode_set() 
    crtc_helper->commit -> intel_crtc_enable()
  for each !enabled crtc:
    crtc->disable -> intel_crtc_disable()
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
