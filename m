Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756148Ab1G2K23 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 06:28:29 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:45087 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756056Ab1G2K21 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 06:28:27 -0400
Date: Fri, 29 Jul 2011 12:25:12 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Keith Packard <keithp@keithp.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Daniel Vetter <daniel@ffwll.ch>,
        Dave Airlie <airlied@redhat.com>, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: [Intel-gfx] [PATCH] drm/i915: Hold struct_mutex during hotplug
 processing
Message-ID: <20110729102512.GB2697@phenom.ffwll.local>
Mail-Followup-To: Keith Packard <keithp@keithp.com>,
	Jesse Barnes <jbarnes@virtuousgeek.org>,
	Dave Airlie <airlied@redhat.com>, intel-gfx@lists.freedesktop.org,
	linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
References: <1311613829-4990-1-git-send-email-keithp@keithp.com>
 <CAKMK7uHO1jqUNrnqC9sd=JJ9Vr=hmAjnJ06eDYxfeyTTFAMK1w@mail.gmail.com>
 <yunsjpt2hi6.fsf@aiko.keithp.com>
 <20110726121225.3ae7acce@jbarnes-desktop>
 <yunk4b43wq3.fsf@aiko.keithp.com>
 <20110727090331.60e0c5be@jbarnes-desktop>
 <yun39hqc95z.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yun39hqc95z.fsf@aiko.keithp.com>
X-Operating-System: Linux phenom 3.0.0-rc7-00009-g9095109
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 28, 2011 at 03:50:00PM -0700, Keith Packard wrote:
> On Wed, 27 Jul 2011 09:03:31 -0700, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> > On Wed, 27 Jul 2011 02:21:24 -0700
> > Keith Packard <keithp@keithp.com> wrote:
> > > So the work may get executed immediately rather than being run later at
> > > some point?
> > 
> > It sure looks that way... but I don't remember any rule about work
> > queue items having inter dependencies like this.

I've checked the workqueue code and haven't found it to run a work
immediately, it's always queued. Further this problem is very easy to
diagnose: Even without lockdep the scheduler will notice the stuck task
after about 120s and the backtrace should make matters extremely clear. On
the other hand if somebody adds some nice state clobbering in the drm
helper, we have a very hard bug to track down.

Generally modesetting isn't perf critical, so I vote for more locking,
just in case.
-Daniel
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
