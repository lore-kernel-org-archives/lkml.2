Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752197Ab1BFBux (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 20:50:53 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48503 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752022Ab1BFBuw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 20:50:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=otTkFseAtJAtWXinBBMIcz5jSr4pW317H7NBI341c3ImuPcTqTsckr4sAVWhMyIzKL
         GbnpuL58r+ft89HqKCBeQW75WNcKZ0Je6R2PaEfF+8WUPsJxd6vYfWu6k/anavOQ9VBQ
         tyMHSAKBjflzlhJ2yvG/3HWs30uILQ27xA6wo=
MIME-Version: 1.0
Date: Sun, 6 Feb 2011 09:50:51 +0800
Message-ID: <AANLkTi=h+H+N=f4m4pE+RZ4n5h7oxQuwzmK-qmmWAGtL@mail.gmail.com>
Subject: Commit 500f7147cf5bafd139056d521536b10c2bc2e154 breaks _resume_
From: Jeff Chua <jeff.chua.linux@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Takashi Iwai <tiwai@suse.de>,
        Chris Wilson <chris@chris-wilson.co.uk>
Cc: Len Brown <lenb@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 6, 2011 at 2:24 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> The suspend monster is back! The suspend-to-ram is fine, but upon
>> resume, screen is blank. Haven't bisected in case someone has also
>> done so.
>
> BTW, please don't reply to messages containing patches with reports of problems
> that aren't caused by those patches.  It's confusing at best and at worst it
> may result in the patches being rejected.

Sorry. New subject now:)


On Sun, Feb 6, 2011 at 2:51 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>> It's very recent. ... between commit
>> 831d52bc153971b70e64eccfbed2b232394f22f8 and
>> 44f2c5c841da1b1e0864d768197ab1497b5c2cc1.
>
> Hmm. It's almost certainly one of the DRI patches, but which one? I
> think bisection is the only way to figure it out. It shouldn't be too
> bad, since there's only 120 commits in that range.
>
> In fact, you can almost certainly just bisect from 89840966c579 to
> bb5b583b5279, which is just 31 commits and should get you bisected in
> just five tries or so.

Yea, I've just done that. It came down to the following commit.
Reverting it solves the problem. I've gone thru a few cycles, and
notebook still survives.

Thanks,
Jeff


commit 500f7147cf5bafd139056d521536b10c2bc2e154
Author: Chris Wilson <chris@chris-wilson.co.uk>
Date:   Mon Jan 24 15:14:41 2011 +0000

    drm/i915: Reset state after a GPU reset or resume

    Call drm_mode_config_reset() after an invalidation event to restore any
    cached state to unknown.

    Tested-by: Takashi Iwai <tiwai@suse.de>
    Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
