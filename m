Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754888Ab1ATCkr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 21:40:47 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55827 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753331Ab1ATCkp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 21:40:45 -0500
MIME-Version: 1.0
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 19 Jan 2011 18:39:54 -0800
Message-ID: <AANLkTimOkFckq+r4cD-PSzc_RNs+HJL5CcEM-3Yh+dF6@mail.gmail.com>
Subject: more intel drm issues (was Re: [git pull] drm intel only fixes)
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Dave Airlie <airlied@linux.ie>,
        linux-kernel@vger.kernel.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok, so I have a new issue that I'm currently bisecting but that people
may be able to figure out even befor emy bisect finishes.

On my slow Atom netbook (that I'm planning on using as my traveling
companion for LCA), suspend-to-RAM takes a long time with current git.
It's quite noticeable - it used to be pretty much instant, now it
takes three seconds. And it's all i915 graphics (although I haven't
bisected it down fully, I've bisected it down to the drm merge).

In the good case (like plain 2.6.37), a suspend event will look
something like this:

   ...
   PM: suspend of devices complete after 147.646 msecs
   ...

but the i915 driver at some point made it take 3s:

  ...
  PM: suspend of devices complete after 3059.656 msecs
  ...

which is definitely long enough to be worth fixing.

Maybe the person responsible will go "oh, that's obviously due to
xyz", and just fix it. But I'll continue to bisect in case nobody
steps up to admit to wasting time..

                    Linus
