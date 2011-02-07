Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752059Ab1BGEtA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 23:49:00 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:59515 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751670Ab1BGEs7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 23:48:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=Medls446sh7RkOo3SgLkp0piXzBFNtZxl01ITQrpOZk26e+c6goTCTAU9x2oOAbzie
         Hw+RK/24yDS3zZ5S0TDgQTSytOy2zfCDOaQcTf57iOVXCCqREEmzahnxOrxUKeXXoRFC
         g5mGjfAPB/mGJ+hwmAkNOZ5P20OJPCp28f0vo=
MIME-Version: 1.0
In-Reply-To: <849307$bf0dak@azsmga001.ch.intel.com>
References: <AANLkTi=h+H+N=f4m4pE+RZ4n5h7oxQuwzmK-qmmWAGtL@mail.gmail.com>
	<s5hfws1whq8.wl%tiwai@suse.de>
	<AANLkTi=iHL+eVPRPzFXRMBZkXU7nXwkeZQiQUcyqSS-H@mail.gmail.com>
	<AANLkTikE_Oa=HGhW3zpc_rdeBvOWckpZ6dfFWq=JnL9R@mail.gmail.com>
	<849307$bf0dak@azsmga001.ch.intel.com>
Date: Mon, 7 Feb 2011 12:48:58 +0800
Message-ID: <AANLkTi=Z1fCA1N47YaCh1tn=PCAAboWtNCUyUH-N3yUo@mail.gmail.com>
Subject: Re: Commit 500f7147cf5bafd139056d521536b10c2bc2e154 breaks _resume_
From: Jeff Chua <jeff.chua.linux@gmail.com>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Takashi Iwai <tiwai@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <lenb@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 6, 2011 at 11:27 PM, Chris Wilson <chris@chris-wilson.co.uk> wrote:
> One last step: move contents of intel_crtc_reset() back to
> intel_crtc_init() one by one.
>
> The active flag is my suspicion. I was thinking that we brought up the
> outputs in a similar manner upon resume as upon initial boot. On
> reflection, this is the not case.
>
> However, the first action we take inside modesetting is to disable the
> outputs about to be reconfigured. So setting active should be the right
> course of action so that cleanup any residual state from resume.
>
> So I am intrigued as to which line is the cause, and just where the
> machine becomes unresponsive...

It's this line causing the problem.

intel_crtc->active = true; /* force the pipe off on setup_init_config */


When it's called before entering intel_crtc_reset(&intel_crtc->base),
it works, but if called within the function, it doesn't work. Strange.
Not sure whether is passing the correct value to to_intel_crtc(crtc)?


Jeff
