Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753386Ab1DEOmh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 10:42:37 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44168 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753303Ab1DEOmg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 10:42:36 -0400
MIME-Version: 1.0
In-Reply-To: <b7da2f$qvoau5@fmsmga001.fm.intel.com>
References: <AANLkTi=VqkYjdiDLJvM-OfmBSGx-EkRkt=4XCDEnvZsU@mail.gmail.com>
 <1301395589-8121-1-git-send-email-chris@chris-wilson.co.uk>
 <20110401114429.GA3526@viiv.ffwll.ch> <AANLkTik6njOQTLGsB4KzPP-J=fE=p4CHopAyvsDzdDSF@mail.gmail.com>
 <BANLkTimUZY+2E=kXG-as8-moAAS4+F5bTg@mail.gmail.com> <b7da2f$qvoau5@fmsmga001.fm.intel.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 5 Apr 2011 07:42:14 -0700
Message-ID: <BANLkTinXZVOy9-j4TiJ7HMcTvv9Q8RS+DA@mail.gmail.com>
Subject: Re: [Intel-gfx] [PATCH] drm/i915: Disable all outputs early, before
 KMS takeover
To: Chris Wilson <chris@chris-wilson.co.uk>, Keith Packard <keithp@keithp.com>
Cc: Tomas Winkler <tomasw@gmail.com>, Pekka Enberg <penberg@kernel.org>,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Daniel Vetter <daniel@ffwll.ch>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 5, 2011 at 3:30 AM, Chris Wilson <chris@chris-wilson.co.uk> wrote:
> On Tue, 5 Apr 2011 13:21:08 +0300, Tomas Winkler <tomasw@gmail.com> wrote:
>> On Fri, Apr 1, 2011 at 2:51 PM, Pekka Enberg <penberg@kernel.org> wrote:
>> > Unfortunately I get a blank screen with after boot:
>> > Nacked-by: Pekka Enberg <penberg@kernel.org>
>
> But until you can tell me where it explodes on your system, we fix
> issues on several other machines...

NO.

Chris, you need to understand the issue of "NO REGRESSIONS".

It's a very simple rule: it DOES NOT MATTER ONE WHIT how many machines
you fix. You never ever regress. Patches that cause regressions are
reverted.

There are multiple reasons for that rule, but the basic one ends up
being very simple: you only _think_ you fix more machines than you
break. Why? Because the people who test out your patches are the
"active" people - and often predominantly the active people who have
problems. In contrast, the people for whom things already work aren't
even testing your patches in the first place. Then, six months later,
when they update to a new Fedora version, things suddenly don't work
for them, and it turns out that yes, you fixed ten active testers, but
you broke a thousand random people.

So even _one_ person saying "this is a regression" is a total blocker.
Really. It's that simple.

YOU NEVER EVER BREAK WORKING MACHINES.

Seriously. We had this for years in ACPI-land and with suspend/resume
with "one step forward, two steps back", and nobody ever knew if we
were doing any real progress at all, because machines that had working
suspend/resume one kernel version would be broken again the next.
There was no real pattern of improvement, there was just a random
pattern of "things get fixed on one machine, and break on another".

We introduced the "no regressions" rule, and things got seriously
better. Suddenly things started getting _reliably_ better.

The whole situation with i915 has been pretty damn random lately, and
you really really need to understand that this is simply not how it's
done. Your cavalier attitude ("but it fixes things for others") is
absolutely not acceptable.

Keith Cc'd, because that patch had better not show up in my tree.

                       Linus
