Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752839Ab1BFOvB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 09:51:01 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59406 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752739Ab1BFOvA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 09:51:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=R72frbrE4AkijWGxiM0RuKZOw6k8wWZebBW310sIb7JYv+68TgVlhTlka/Yzv4ChSz
         m9Q8b+HzsauwLaJD+4jDpffNRKPDpHZINJz4bSUzBnXOUQpWf61hxTSLDDM676PKZISd
         bkyqfiQPjoiNZ8lo6Cd19sbLaPGonCzR90Yfk=
MIME-Version: 1.0
In-Reply-To: <b9dded$hs5ggh@orsmga002.jf.intel.com>
References: <AANLkTi=h+H+N=f4m4pE+RZ4n5h7oxQuwzmK-qmmWAGtL@mail.gmail.com>
	<s5hfws1whq8.wl%tiwai@suse.de>
	<AANLkTi=iHL+eVPRPzFXRMBZkXU7nXwkeZQiQUcyqSS-H@mail.gmail.com>
	<b9dded$hs5ggh@orsmga002.jf.intel.com>
Date: Sun, 6 Feb 2011 22:51:00 +0800
Message-ID: <AANLkTi=PEhcFYy7Q8e2Dj9p60x2wc=D7vMzR=btEGeUc@mail.gmail.com>
Subject: Re: Commit 500f7147cf5bafd139056d521536b10c2bc2e154 breaks _resume_
From: Jeff Chua <jeff.chua.linux@gmail.com>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Takashi Iwai <tiwai@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <lenb@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 6, 2011 at 10:47 PM, Chris Wilson <chris@chris-wilson.co.uk> wrote:
> On Sun, 6 Feb 2011 22:01:22 +0800, Jeff Chua <jeff.chua.linux@gmail.com> wrote:
>> It's the commit below. I've checked it twice. Reverting it solves the
>> problem. Suspend to Ram ok. Upon resume, screen is blank. Keyboard
>> hangs. Had to do a hard reset.
>
>> >> commit 500f7147cf5bafd139056d521536b10c2bc2e154
>> >> Author: Chris Wilson <chris@chris-wilson.co.uk>
>> >> Date:   Mon Jan 24 15:14:41 2011 +0000
>> >>
>> >>     drm/i915: Reset state after a GPU reset or resume
>
> Makes no difference to my x201s.
>
> I would have thought a bisection would have resulted in either
> f3269058e7a80083dcdf89698bfcd1a6c6f8fd12 or
> 5d1d0cc87fc0887921993ea0742932e0c8adeda0
>
> Can you try reverting those two to see if either of those is the true
> culprit?

You're too fast. It's the commit below.

commit 5d1d0cc87fc0887921993ea0742932e0c8adeda0
Author: Chris Wilson <chris@chris-wilson.co.uk>
Date:   Mon Jan 24 15:02:15 2011 +0000

    drm/i915: Reset crtc after resume

    Based on a patch by Takashi Iwai.

    Reported-by: Matthias Hopf <mat@mshopf.de>
    Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=27272
    Tested-by: Takashi Iwai <tiwai@suse.de>
    Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>


Thanks,
Jeff.
