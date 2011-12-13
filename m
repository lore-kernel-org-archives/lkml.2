Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756146Ab1LMXE3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 18:04:29 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:61495 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751909Ab1LMXE2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 18:04:28 -0500
MIME-Version: 1.0
X-Originating-IP: [178.83.130.250]
Date: Wed, 14 Dec 2011 00:04:26 +0100
Message-ID: <CAKMK7uEOOod4Q_29WCXonR7YsQ=WfKCakptkhgk61bVysLQE_w@mail.gmail.com>
Subject: Patches queued to drm-intel-fixes
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Keith Packard <keithp@keithp.com>
Cc: Dave Airlie <airlied@redhat.com>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Keith,

I've noticed that you merged my patch "rm/i915: properly prefault for
pread/pwrite" into your -fixes branch (which I assume is headed for
3.2). Please remove that from your queue again for the following
reasons:

- The right thing to do is to fix up the prefault handlers in pagemap.h
- It's really ugly code (which Chris Wilson later on complained
about), so ugly actually that it confused you while reviewing it.
- It changes the semantics of pread/pwrite in funny ways (something
you actually complained about in review a while ago, too).
- This bug has been lying around for almost half a year already, so I
don't see the need for a rush now.
- It only papers over the underlying issue, the real minimal and
proper fix is queued up (and reviewed) in my-next in my own git repo
for 3.3.
- I actually managed to blow things up while playing with the prefault
stuff, so it's imo not really risk-free.
- But most important this late in the -rc cylce: It doesn't fix a regression.

I've also noticed that you have my patch "drm/i915: check ACTHD of all
rings" queued up in -fixes. I wouldn't have minded this getting merged
a few weeks ago into an early -rc but again I think it's too late for
this one for the following reasons:
- It touches on the hangcheck code, one of the most important pieces
to be able to debug issues and hence support users of our driver, but
also one of the least tested ones (we essentially only test it when
hitting actual hangs).
- A similar patch by Ben Widawsky actually blew things up for Chris Wilson.
- Again it doesn't fix a regression.

Dave, please reject a pull request for 3.2 containing these patches -
I've already embarrassed myself with the vt-d oneliner (which should
imo have been merged about 4 weeks ago, but mea culpa).

Yours, Daniel
-- 
Daniel Vetter
daniel.vetter@ffwll.ch - +41 (0) 79 365 57 48 - http://blog.ffwll.ch
