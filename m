Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756683Ab2ARLnR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 06:43:17 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:63186 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756047Ab2ARLnQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 06:43:16 -0500
Date: Wed, 18 Jan 2012 12:43:08 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Chris Wilson <chris@chris-wilson.co.uk>, Jiri Slaby <jslaby@suse.cz>,
        LKML <linux-kernel@vger.kernel.org>, dri-devel@lists.freedesktop.org
Subject: Re: g33: GPU hangs
Message-ID: <20120118114308.GA4002@phenom.ffwll.local>
Mail-Followup-To: Jiri Slaby <jirislaby@gmail.com>,
	Chris Wilson <chris@chris-wilson.co.uk>,
	Jiri Slaby <jslaby@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
	dri-devel@lists.freedesktop.org
References: <4ED7735A.1020903@suse.cz>
 <d08817$2d9rsk@azsmga001.ch.intel.com>
 <4F16917E.1090401@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F16917E.1090401@gmail.com>
X-Operating-System: Linux phenom 3.2.0-rc6+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 18, 2012 at 10:31:42AM +0100, Jiri Slaby wrote:
> On 12/01/2011 01:47 PM, Chris Wilson wrote:
> > On Thu, 01 Dec 2011 13:30:18 +0100, Jiri Slaby <jslaby@suse.cz> wrote:
> >> Hi,
> >>
> >> both yesterday and today, my GPU hung. Both happened when I opened
> >> google front page in firefox.
> >>
> >> I'm running 3.2.0-rc3-next-20111130. Given it happened twice in the past
> >> 24 hours, it looks like a regression from next-20111124. Or is this a
> >> userspace issue (I might updated some packages)?
> >>
> >> i915_error_state dumps from the two hangs are here:
> >> http://www.fi.muni.cz/~xslaby/sklad/panics/915_error_state_0
> >> http://www.fi.muni.cz/~xslaby/sklad/panics/915_error_state_second
> > 
> > Both error states contain the same bug: a fence register in conflict
> > with the command stream. The batch is using the buffer at 0x03d0000 
> > as an untiled 40x40 rgba buffer with pitch 192. However, a fence
> > register is programmed to
> >   fence[3] = 03d00001
> >     valid, x-tiled, pitch: 512, start: 0x03d00000, size: 1048576
> > 
> > Also note that buffer is also not listed as currently active, so
> > presumably we reused the buffer as tiled (and so reprogrammed the
> > fence registered) before the GPU retired the batch. That sounds eerily
> > similar to this bug:
> > 
> > From 2b76187d2f5fc2352e391914b1828f91f93bb356 Mon Sep 17 00:00:00 2001
> > From: Chris Wilson <chris@chris-wilson.co.uk>
> > Date: Tue, 29 Nov 2011 15:12:16 +0000
> > Subject: [PATCH] drm/i915: Only clear the GPU domains upon a successful
> >  finish
> 
> Hi, do you plan to push this patch upstream? Or am I supposed to not use
> it anymore?

It's on track to get merged to drm-intel-next. I'll probably pick it up in a week
or so.
-Daniel
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
