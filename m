Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754388Ab1BHNgM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 08:36:12 -0500
Received: from mga09.intel.com ([134.134.136.24]:19454 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753991Ab1BHNgL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 08:36:11 -0500
Message-Id: <b9dded$hsnlfd@orsmga002.jf.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,441,1291622400"; 
   d="scan'208";a="600561133"
Date: Tue, 08 Feb 2011 13:36:06 +0000
To: Jeff Chua <jeff.chua.linux@gmail.com>, Takashi Iwai <tiwai@suse.de>
Subject: Re: Commit 500f7147cf5bafd139056d521536b10c2bc2e154 breaks _resume_
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <lenb@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <AANLkTi=h+H+N=f4m4pE+RZ4n5h7oxQuwzmK-qmmWAGtL@mail.gmail.com> <s5hfws1whq8.wl%tiwai@suse.de> <AANLkTi=iHL+eVPRPzFXRMBZkXU7nXwkeZQiQUcyqSS-H@mail.gmail.com> <AANLkTikE_Oa=HGhW3zpc_rdeBvOWckpZ6dfFWq=JnL9R@mail.gmail.com> <849307$bf0dak@azsmga001.ch.intel.com> <AANLkTi=Z1fCA1N47YaCh1tn=PCAAboWtNCUyUH-N3yUo@mail.gmail.com> <AANLkTik0eJVr1S5=bCO8kmkwCxYzLE_kh9C3ccpn+mWX@mail.gmail.com> <s5hy65suu7t.wl%tiwai@suse.de> <AANLkTi=KGMJ9vLaLfkzGQrc-F2eB5CRmDX1L5UohPTZ=@mail.gmail.com> <s5htyggusyg.wl%tiwai@suse.de> <s5htyggi21m.wl%tiwai@suse.de> <AANLkTinv=pfArgT4VFCUeY_bKb4q3KSREvU+L8V5k0G9@mail.gmail.com> <AANLkTim2czZfsbGaG=K-=dV5hENgUOUhjBpWoa+mTjyb@mail.gmail.com>
From: Chris Wilson <chris@chris-wilson.co.uk>
In-Reply-To: <AANLkTim2czZfsbGaG=K-=dV5hENgUOUhjBpWoa+mTjyb@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Feb 2011 22:11:29 +0800, Jeff Chua <jeff.chua.linux@gmail.com> wrote:
> Same issue encountered even after a fresh build.

I've been testing on the same hardware (x201s, 64bit, with and without
external DP) and I've not encountered the same issue. Every time I look
at the code, by not setting crtc->active we may incorrectly skip disabling
an active output after resume. If the output is inactive, then disabling it
*should* be a no-op, and thus safe. So I am still at a loss to understand
what fails here and so whether we have a bigger problem on our hands.

Please can you add drm.debug=0xe to your boot parameters (or echo 0xe >
/sys/module/drm/parameters/debug might just be enough) and attach the
dmesg whilst resuming. Also attaching the failing Xorg.0.log would be
useful to rule out any other issues.
-Chris
-- 
Chris Wilson, Intel Open Source Technology Centre
