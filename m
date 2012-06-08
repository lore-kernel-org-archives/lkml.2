Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760067Ab2FHWyW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 18:54:22 -0400
Received: from smtp.fireflyinternet.com ([109.228.6.236]:53928 "EHLO
	fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757876Ab2FHWxx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 18:53:53 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.66.37;
From: Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: [git pull] drm intel + exynos fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Airlie <airlied@linux.ie>, Daniel Vetter <daniel.vetter@ffwll.ch>,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
In-Reply-To: <CA+55aFxQn_KJcHztPyUptOb=s-+n5-4mDs+dGL1XiN4QbAv2mg@mail.gmail.com>
References: <alpine.DEB.2.00.1206080952010.15272@skynet.skynet.ie> <CA+55aFyASr5Jfok7vVKXg9=n_pBGyjLZf3MmRik90y8qXRNo3g@mail.gmail.com> <1339193608_596134@CP5-2952> <CA+55aFxQn_KJcHztPyUptOb=s-+n5-4mDs+dGL1XiN4QbAv2mg@mail.gmail.com>
Date: Fri, 08 Jun 2012 23:52:52 +0100
X-Originating-IP: 78.156.66.37
Message-ID: <1339196027_596874@CP5-2952>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Jun 2012 15:23:15 -0700, Linus Torvalds <torvalds@linux-foundation.org> wrote:
> On Fri, Jun 8, 2012 at 3:12 PM, Chris Wilson <chris@chris-wilson.co.uk> wrote:
> >
> >           So it falls back to
> > load-detection, which in your case it cannot do since all the available
> > pipes are assigned and so it just reports the VGA connection as unknown.
> 
> Btw, it's a singularly stupid decision to say "Ok, I *know* I have a
> monitor on output X, and I have no clue what-so-ever what I have on
> output Y, and no indication there is anything even there, so let me
> just degrade the output on output Y just in case".

And that was my point. You were blaming the patch for making you aware
of existing behaviour that results in utter confusion, for as Alex
points out there is no sane way for userspace to handle the unknown
connection status from the detection routine. As such it is probably
better if that was handled internally as "result indeterminate; do not
update current detection status" which is the behaviour of some of the
drm helpers but uniformly. If that were true, then userspace would
continue to be told that the connection status was disconnected until
a monitor was plugged in.
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
