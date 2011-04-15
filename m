Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752676Ab1DOGLj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 02:11:39 -0400
Received: from isilmar-3.linta.de ([188.40.101.200]:40834 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751744Ab1DOGLi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 02:11:38 -0400
Date: Fri, 15 Apr 2011 08:11:36 +0200
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Ben Skeggs <bskeggs@redhat.com>, airlied@redhat.com,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        mjg@redhat.com, maciej.rutecki@gmail.com,
        nouveau@lists.freedesktop.org
Subject: Re: 2.6.39-rc1 nouveau regression (bisected)
Message-ID: <20110415061136.GA21979@isilmar-3.linta.de>
Mail-Followup-To: Dominik Brodowski <linux@dominikbrodowski.net>,
	Marcin Slusarz <marcin.slusarz@gmail.com>,
	Ben Skeggs <bskeggs@redhat.com>, airlied@redhat.com,
	dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
	mjg@redhat.com, maciej.rutecki@gmail.com,
	nouveau@lists.freedesktop.org
References: <20110403181206.GA19291@comet.dominikbrodowski.net> <20110407151129.GA24977@comet.dominikbrodowski.net> <20110414170559.GA10768@comet.dominikbrodowski.net> <20110414190117.GA3493@joi.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110414190117.GA3493@joi.lan>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 14, 2011 at 09:02:01PM +0200, Marcin Slusarz wrote:
> On Thu, Apr 14, 2011 at 07:05:59PM +0200, Dominik Brodowski wrote:
> > Thought about CCing Linus to show him that 2.6.39-rcX isn't as "calm"
> > to everyone, but then chose to CC Maciej instead: Would you be so kind and
> > add this to your regression list? Thanks!
> > 
> > Since commit 38f1cff
> > 
> >     From: Dave Airlie <airlied@redhat.com>
> >     Date: Wed, 16 Mar 2011 11:34:41 +1000
> >     Subject: [PATCH] Merge commit '5359533801e3dd3abca5b7d3d985b0b33fd9fe8b' into dr
> > 
> >     This commit changed an internal radeon structure, that meant a new driver
> >     in -next had to be fixed up, merge in the commit and fix up the driver.
> > 
> >     Also fixes a trivial nouveau merge.
> > 
> >     Conflicts:
> >         drivers/gpu/drm/nouveau/nouveau_mem.c
> > 
> > booting my atom/NM10/ION2 system crashes hard during boot, right after
> > blanking the screen, and before the initramfs gets loaded. I just
> > re-checked: both parent commits ( 5359533 and 4819d2e ) do indeed work
> > just fine, but the merge commit ( 38f1cff ) fails, same as tip ( 85f2e68 ).
> 
> Can you activate netconsole and check whether kernel spits anything interesting?
> You might try to load nouveau module after boot - maybe something will be saved
> to /var/log or you could even ssh into the box and check dmesg...

Compiling it as a module seems to work fine. When I do so, no regression is
obvious from what gets reported in "dmesg". However, somehow I now do get
some output: The last message I see is

[drm] nouveau 0000:01:00.0: allocated 1680x1050, fb 0x40.... b0 <some pointer value>

Then, nothing more. However, it really is quite strange why this error only
appears in the CONFIG_NOUVEAU=y case, not in the =m case...

Best,
	Dominik
