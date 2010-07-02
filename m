Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756921Ab0GBBeH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 21:34:07 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60469 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753441Ab0GBBeF convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 21:34:05 -0400
MIME-Version: 1.0
In-Reply-To: <AANLkTilfkCBfZtRQlybQ721PSF4lSlqeOKL3rYnEz2G1@mail.gmail.com>
References: <alpine.LFD.2.00.1001270327580.24253@localhost.localdomain>
	<1264605932-8540-1-git-send-email-chris@chris-wilson.co.uk>
	<alpine.LFD.2.00.1001270738220.24253@localhost.localdomain>
	<89k77n$ms73l9@fmsmga001.fm.intel.com>
	<alpine.LFD.2.00.1001270917120.24253@localhost.localdomain>
	<AANLkTilpK6FfgbgVf4e7jJSvVwVDVLfrxIy3WmgliuLK@mail.gmail.com>
	<89khjo$fr177d@orsmga002.jf.intel.com>
	<AANLkTilwmuXlNYhlFkmpYHSmegPy3ws4x-YRFwkbk8Xm@mail.gmail.com>
	<AANLkTinLB5YtqsnFwWrP37i3Ucr4fOaQzVuDLnyWBRGQ@mail.gmail.com>
	<4C2D180C.5050805@superonline.com>
	<AANLkTiklUBmNYs3710WftVX0Z3QihxFtDlK7tPlHZh8H@mail.gmail.com>
	<AANLkTilOWu6ZwWjwPfHvNXDhyjb6n4N5KV1rUx6byJmq@mail.gmail.com>
	<AANLkTilfkCBfZtRQlybQ721PSF4lSlqeOKL3rYnEz2G1@mail.gmail.com>
Date: Thu, 1 Jul 2010 18:28:01 -0700
Message-ID: <AANLkTikpw42jE5Eh0EkXuRh70mb9x3njX6R4JNshawe5@mail.gmail.com>
Subject: Re: [Intel-gfx] [PATCH] drm/i915: Selectively enable self-reclaim
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dave Airlie <airlied@gmail.com>
Cc: "M. Vefa Bicakci" <bicave@superonline.com>,
       Chris Wilson <chris@chris-wilson.co.uk>, earny@net4u.de,
       Roman Jarosz <kedgedev@gmail.com>, intel-gfx@lists.freedesktop.org,
       linux-kernel@vger.kernel.org, jcnengel@googlemail.com,
       "A. Boulan" <arnaud.boulan@libertysurf.fr>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Pekka Enberg <penberg@cs.helsinki.fi>, A Rojas <nqn1976list@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, rientjes@google.com,
       michael@reinelt.co.at, stable@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 1, 2010 at 5:49 PM, Dave Airlie <airlied@gmail.com> wrote:
>
> RECLAIMABLE added also seems fine, of course you can't have
> RECLAIMABLE and MOVABLE (I find this out when it oopses on boot).

Yes. They are both flags for the anti-fragmentation code, and I think
I'll leave the decision as to whether the i915 driver should use
__GFP_RECLAIMABLE to the people who work with and care about the
fragmentation issues. I doubt it matters much in practice, at least
not for the loads that the fragmentation people tend to care most
about.

> So I suspect MOVABLE is the problem. but I don't know enough about gfp
> flags to know what RECLAIMABLE buys us, and where it  might bite us so
> I can test some more.

I think I'll just apply your previous tested patch - GFP_HIGHUSER
should take care of all the flags that matter fundamentally, and then
the reclaimable flag is really just a small detail for others to worry
about.

                                 Linus
