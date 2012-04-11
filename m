Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761183Ab2DKU0g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 16:26:36 -0400
Received: from smtp.fireflyinternet.com ([109.228.6.236]:24754 "EHLO
	fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755356Ab2DKU0f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 16:26:35 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.66.37;
From: Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: [PATCH 4/8 v7] drm/i915/intel_i2c: use WAIT cycle, not STOP
To: Daniel Kurtz <djkurtz@chromium.org>
Cc: Daniel Vetter <daniel@ffwll.ch>, Keith Packard <keithp@keithp.com>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, Benson Leung <bleung@chromium.org>,
        Yufeng Shen <miletus@chromium.org>
In-Reply-To: <CAGS+omAftY7bCYzRp-0XLbGt7-YTz9My6dPz21G1Hr4qC=g=Jw@mail.gmail.com>
References: <1333108003-6341-1-git-send-email-djkurtz@chromium.org> <1333108003-6341-5-git-send-email-djkurtz@chromium.org> <20120410103746.GH4115@phenom.ffwll.local> <20120410104147.GI4115@phenom.ffwll.local> <CAGS+omAjDPxs1qR-EwzKhjE9c5J26fZinv6+5RFz1RyAsfStmw@mail.gmail.com> <20120410150304.GJ4115@phenom.ffwll.local> <1334093645_352764@CP5-2952> <CAGS+omAftY7bCYzRp-0XLbGt7-YTz9My6dPz21G1Hr4qC=g=Jw@mail.gmail.com>
Date: Wed, 11 Apr 2012 21:26:23 +0100
X-Originating-IP: 78.156.66.37
Message-ID: <1334175985_372722@CP5-2952>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Apr 2012 02:17:46 +0800, Daniel Kurtz <djkurtz@chromium.org> wrote:
> On Wed, Apr 11, 2012 at 5:34 AM, Chris Wilson <chris@chris-wilson.co.uk> wrote:
> > The last major item on the wishlist is solving how to drive the SDVO i2c
> > over gmbus. I think it is just a matter of massaging in the channel
> > switch as msg[0].
> 
> I noticed that random other i2c adapter, but haven't looked at it to
> know why it is so different than the others.  What is it?

Every command sequence over SDVO is preceded by an instruction to the
controller as to which function to send the command to. Originally I
tried to reuse the GPIO method of simply sending that switch command
immediately followed by the real message, but I never succeeded in
setting up the SDVO devices in that manner. I suspect what is actually
required is to rebuild the message to include the preceeding bus switch.

However, if you don't have any SDVO devices to experiment with we can
find somebody who does.
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
