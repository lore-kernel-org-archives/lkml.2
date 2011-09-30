Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756743Ab1I3Rzk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 13:55:40 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:35399 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754722Ab1I3Rzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 13:55:39 -0400
Date: Fri, 30 Sep 2011 19:56:14 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Keith Packard <keithp@keithp.com>
Cc: Daniel Vetter <daniel@ffwll.ch>, Dave Airlie <airlied@redhat.com>,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [PATCH 02/21] drm/i915: Shut down PCH interrupts during
 irq_uninstall
Message-ID: <20110930175614.GM2859@phenom.ffwll.local>
Mail-Followup-To: Keith Packard <keithp@keithp.com>,
	Dave Airlie <airlied@redhat.com>, intel-gfx@lists.freedesktop.org,
	linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
References: <20110923085243.6e4b7b4c@jbarnes-x220>
 <1317344993-24945-1-git-send-email-keithp@keithp.com>
 <1317344993-24945-3-git-send-email-keithp@keithp.com>
 <20110930162048.GB2859@phenom.ffwll.local>
 <yunaa9m7wnd.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yunaa9m7wnd.fsf@aiko.keithp.com>
X-Operating-System: Linux phenom 3.1.0-rc4+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 30, 2011 at 10:44:22AM -0700, Keith Packard wrote:
> On Fri, 30 Sep 2011 18:20:48 +0200, Daniel Vetter <daniel@ffwll.ch> wrote:
> 
> > Shouldn't we mask/ack south DE irqs before before we mask DE irqs to avoid
> > races, i.e.  move this new code up?
> 
> I don't know. What about the GT interrupts? I just stuck stuff at the
> bottom, figuring it would do the least harm...

Thinking this through again I don't see the race anymore. I've forgotten
that masking things in IMR also prevents stuff from showing up in IIR and
hence a SDE irq after clearing DE irqs can't leave garbage behind in
DEIIR. So no need to clear things in the order the irqs propagate, i.e.
SDE->DE->GT. For the patch:

Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
