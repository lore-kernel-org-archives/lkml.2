Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754735Ab0ELNhu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 09:37:50 -0400
Received: from mx6.sophos.com ([213.31.172.36]:56622 "EHLO mx6.sophos.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754815Ab0ELNhr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 09:37:47 -0400
From: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>
Organization: Sophos Plc
To: Jerome Glisse <glisse@freedesktop.org>
Subject: Re: 2.6.33.2 kmalloc-8 slab leaks ~512 objects per second
Date: Wed, 12 May 2010 14:37:44 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc7; KDE/4.3.5; x86_64; ; )
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Airlie <airlied@linux.ie>,
       "dri-devel@lists.sourceforge.net" <dri-devel@lists.sourceforge.net>
References: <11758_1273660249_4BEA8359_11758_1675_1_201005121121.49135.tvrtko.ursulin@sophos.com> <201005121150.42462.tvrtko.ursulin@sophos.com> <20100512132916.GD2790@barney.localdomain>
In-Reply-To: <20100512132916.GD2790@barney.localdomain>
MIME-Version: 1.0
Message-ID: <201005121437.44632.tvrtko.ursulin@sophos.com>
X-MIMETrack: Itemize by SMTP Server on Mercury/Servers/Sophos(Release 7.0.3|September 26, 2007) at
 12/05/2010 14:37:44,
	Serialize by Router on Mercury/Servers/Sophos(Release 7.0.3|September 26, 2007) at
 12/05/2010 14:37:44,
	Serialize complete at 12/05/2010 14:37:44
X-TNEFEvaluated: 1
Content-Transfer-Encoding: 7BIT
Content-Type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[Snipped localdomain guy from Cc]

On Wednesday 12 May 2010 14:29:16 Jerome Glisse wrote:
> On Wed, May 12, 2010 at 11:50:41AM +0100, Tvrtko Ursulin wrote:
> > On Wednesday 12 May 2010 11:38:05 Tvrtko Ursulin wrote:
> >
> > [snip]
> >
> > > I think it is DRM (radeon) related, leak stopped when I closed all X
> > >  programs. I am compiling 2.6.33.3 right now and will soon reboot into
> > > it.
> >
> > Leak is still present in 2.6.33.3 - the more GUI activity the more it
> > leaks. So the ~512 objects per second was with xosview running, but
> > moving windows or browsing through menus can leak a lot more (per
> > second).
> >
> > Is version of userspace drm library interesting? It is 2.4.20
> > (libdrm-2.4.20-12.1.x86_64).
> >
> > Tvrtko
>
> Do the number of object stay constant over longuer period of time
> (30min, 1hour) ? If there was a leak i think we would have notice
> it by now, some of my desktop are running 24h for several days with
> radeon kms.

No, it grew constantly in presence of compositing activity under X by 512 8
byte objects per second or more, possibly multiples of 512 or very close.

If you haven't seen my original  post, kmalloc-8 cache after some days of
uptime looked like this:

kmalloc-8         68044800 68044800      8  512    1 : tunables    0    0    0
: slabdata 132900 132900      0

I am now running 2.6.34-rc7 which seems not to leak.

Tvrtko

Sophos Plc, The Pentagon, Abingdon Science Park, Abingdon, OX14 3YP, United Kingdom.
Company Reg No 2096520. VAT Reg No GB 348 3873 20.
