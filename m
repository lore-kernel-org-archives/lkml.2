Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752817Ab1BFOtk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 09:49:40 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:43274 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752739Ab1BFOtj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 09:49:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=XKYCX/CHABXxOAMcS9N7sdwlC5mhKt3t5lsG6oKfoi2SDZjDT8qDhMIUT/b6r2ctGx
         EyGqdoz2d8c2h/WGarp0/4ak5xQccefb76VGKLyF0y8g/Ti62QiWBrS5E4vLCG8R2vlw
         mWVGp3UcL84IiH7RTpgi1G7Es0gdwCxsn9dA0=
MIME-Version: 1.0
In-Reply-To: <AANLkTi=iHL+eVPRPzFXRMBZkXU7nXwkeZQiQUcyqSS-H@mail.gmail.com>
References: <AANLkTi=h+H+N=f4m4pE+RZ4n5h7oxQuwzmK-qmmWAGtL@mail.gmail.com>
	<s5hfws1whq8.wl%tiwai@suse.de>
	<AANLkTi=iHL+eVPRPzFXRMBZkXU7nXwkeZQiQUcyqSS-H@mail.gmail.com>
Date: Sun, 6 Feb 2011 22:49:38 +0800
Message-ID: <AANLkTikE_Oa=HGhW3zpc_rdeBvOWckpZ6dfFWq=JnL9R@mail.gmail.com>
Subject: Re: Commit 500f7147cf5bafd139056d521536b10c2bc2e154 breaks _resume_
From: Jeff Chua <jeff.chua.linux@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Chris Wilson <chris@chris-wilson.co.uk>, Len Brown <lenb@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 6, 2011 at 10:01 PM, Jeff Chua <jeff.chua.linux@gmail.com> wrote:
> On Sun, Feb 6, 2011 at 7:00 PM, Takashi Iwai <tiwai@suse.de> wrote:
>> At Sun, 6 Feb 2011 09:50:51 +0800,
>> Jeff Chua wrote:
>>>
>>> On Sun, Feb 6, 2011 at 2:24 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>>> >> The suspend monster is back! The suspend-to-ram is fine, but upon
>>> >> resume, screen is blank. Haven't bisected in case someone has also
>>> >> done so.
>
>> Hrm, what is the symptom?  I couldn't find it because you cut off the
>> thread, and it's not cited.
>
> Takashi-san,
>
> It's the commit below. I've checked it twice. Reverting it solves the
> problem. Suspend to Ram ok. Upon resume, screen is blank. Keyboard
> hangs. Had to do a hard reset.

> The commit you mentioned just adds an interface, and the the callbacks
> aren't defined.  The real change is either in
>  commit f3269058e7a80083dcdf89698bfcd1a6c6f8fd12
>    drm/i915/crt: Force the initial probe after reset
> or
>  commit 5d1d0cc87fc0887921993ea0742932e0c8adeda0
>    drm/i915: Reset crtc after resume

uh, Sorry, misread your original post. I've retest it, and it's the 2nd one.

commit 5d1d0cc87fc0887921993ea0742932e0c8adeda0
Author: Chris Wilson <chris@chris-wilson.co.uk>
Date:   Mon Jan 24 15:02:15 2011 +0000

    drm/i915: Reset crtc after resume

    Based on a patch by Takashi Iwai.


I wasn't really doing a bisect last night. Just reverting those
patches that seems to be the problem last night. Just arrived in Tokyo
last night. Long flight, too tired to do the bisect. By luck, the
commit I reverted worked, but you caught me!

This time. it down to the root cause!

Thanks,
Jeff.
