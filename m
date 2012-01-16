Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756557Ab2APTlj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 14:41:39 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:50473 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755947Ab2APTli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 14:41:38 -0500
Date: Mon, 16 Jan 2012 20:41:32 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Dave Airlie <airlied@gmail.com>, Keith Packard <keithp@keithp.com>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: New drm-intel-next tree
Message-ID: <20120116194132.GC3627@phenom.ffwll.local>
Mail-Followup-To: Dave Airlie <airlied@gmail.com>,
	Keith Packard <keithp@keithp.com>,
	DRI Development <dri-devel@lists.freedesktop.org>,
	Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
	LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Operating-System: Linux phenom 3.2.0-rc6+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Because Keith is routinely really busy with all kinds of things, notably
gathering fixes for drm-intel-fixes, the patch merge process for the next
release cycle sometimes falls behind. To support him and improve things I've
been volunteered to take over handling the -next tree. 

The main aim is to shift the drm/i915 -next merge process massively ahead with
the goals to:
- Reduce pressure to merge questionable patches into -rc kernels because the
  -next tree is not yet open for patches.
- Allow our QA at Intel and also the community to actually test things before
  they land in mainline. The lack of such testing has severly bitten us in the
  past few releases.
- Refocus -fixes on handling regressions with absolute top priority (as it
  should).
- And generally get a steady and predictable patch-flow towards mainline back
  into gears.

I plan to run this -next tree with a few simple rules:
- I'll open the drm/i915 -next tree around -rc1 (maybe earlier in the future)
  and cut regular new trees about every 2nd week or so. 2 weeks should be enough
  for both our qa and the community to give it some decent testing.

- I intend to send out the previous -next to Dave Airlie (assuming it tests ok)
  so that he has a good check on the stuff that's going on in i915-land. A few
  other people also asked for a better overview of what's going on on drm/i915 -
  I'll plan to announce every new -next tree with a short mail (maybe together
  with the pull request to Dave for the old one).

- -next will close about 1-2 weeks before the merge opens. No new features after
  that point for a given release cycle.

- To make this really work we also need to cut down on what can go into -fixes.
  drm/i915 unfortunately has the reputation that deserves it a bunch of
  draconian rules (which are stricter than drm/* in general):

  - Only fixes for serious issues and regressions after the -next tree went to
    Dave.
  - After -rc2 regression fixes only. It simply happend why too often that an
    "obvious" patch blew up late in the -rc release cycle, my patches included.
  - After -rc4/5 only reverts and disable patches. Imo it's way too late to play
    games by then, the real fix should go straight to -next (which will close
    only a few weeks afterwards already).

- Regressions have top priority, if they get neglected due to ongoing work
  headed for -next I'll refuse to merge the patches.

- We have a test-suite in the intel-gpu-tools package for the kernel. Expect me
  to be annoying about patches that should have testcases for them but don't.
  This includes new features, but also bugs that can be reproduced with a
  reasonable amount of effort.

- To avoid me pushing utter crack I will only merge my own patches after they
  have gathered sufficient review on intel-gfx. Please yell at me at the top of
  your voice (and in public) if I violate this.

- The main discussion list for patches to drm/i915 is
  intel-gfx@lists.freedesktop.org - I don't keep up with lkml usually.

- I'll reserve my human right to act like an incompetent arrogant fool once in a
  while.

Last but not least, the new tree is available at

http://cgit.freedesktop.org/~danvet/drm-intel
git://people.freedesktop.org/~danvet/drm-intel

drm-intel-next is the main branch, but I expect at least a for-airlied branch
for pull requests and maybe other branches with proposed patches to show up.

Comments, flames and suggestions highly welcome.

Yours, Daniel

PS: Quick version for people with too short attentation spans:

- -next will open around -rc1, a new tree should show up about every second
  week. -next trees that are tested will regurarly be forwarded to Dave.

- No stuff in -fixes that should go into -next instead.

- -next will close for features about 1-2 weeks ahead of the upstream merge window.

- Regressions have top priority.

- Implementing proper tests is required.

- Hit me hard if I break these rules for my own patches.

- Sometimes I'll screw things up badly.

Now grab the tree from

git://people.freedesktop.org/~danvet/drm-intel
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
