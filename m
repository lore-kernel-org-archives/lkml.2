Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758806Ab2FFV1h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 17:27:37 -0400
Received: from mga01.intel.com ([192.55.52.88]:32056 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758537Ab2FFV1e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 17:27:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="161871729"
Date: Thu, 7 Jun 2012 06:27:32 +0900
From: Fengguang Wu <fengguang.wu@intel.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Hans Verkuil <hans.verkuil@cisco.com>, Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        linux-media <linux-media@vger.kernel.org>
Subject: Re: radio-maxiradio.c: undefined reference to `snd_tea575x_init'
Message-ID: <20120606212732.GA8093@localhost>
References: <20120329144217.6cacd2f040fa9abb9190ae1e@canb.auug.org.au>
 <4F74900E.5010501@xenotime.net>
 <20120606204014.GA8264@localhost>
 <201206062315.04124.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201206062315.04124.hverkuil@xs4all.nl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 06, 2012 at 11:15:04PM +0200, Hans Verkuil wrote:
> On Wed June 6 2012 22:40:14 Fengguang Wu wrote:
> > On Thu, Mar 29, 2012 at 09:38:38AM -0700, Randy Dunlap wrote:
> > > On 03/28/2012 08:42 PM, Stephen Rothwell wrote:
> > > 
> > > > Hi all,
> > > > 
> > > > Reminder: please do not add stuff destined for v3.5 to linux-next
> > > > included trees/branches until after v3.4-rc1 has been released.
> > > > 
> > > > Changes since 20120328:
> > > 
> > > 
> > > on x86_64:
> > > 
> > > radio-maxiradio.c:(.devinit.text+0x356ac): undefined reference to `snd_tea575x_init'
> > > radio-maxiradio.c:(.devexit.text+0x503e): undefined reference to `snd_tea575x_exit'
> > 
> > I run into this issue, too, in the 3.5-rc1 based tip/master.
> > 
> >         drivers/built-in.o: In function `maxiradio_probe':
> >          radio-maxiradio.c:(.devinit.text+0x35a27): undefined reference to `snd_tea575x_init'
> >         drivers/built-in.o: In function `maxiradio_remove':
> >          radio-maxiradio.c:(.devexit.text+0x6754): undefined reference to `snd_tea575x_exit'
> > 
> > Any fixes available now? The related commit is:
> > 
> >         commit cfb19b0ab13847a0e0e49521eb94113b0b315e3b
> >         Author: Hans Verkuil <hans.verkuil@cisco.com>
> >         Date:   Sun Feb 5 09:53:17 2012 -0300
> > 
> >             [media] radio-maxiradio: use the tea575x framework
> >             
> >             This card is based on the tea575x receiver. Use the tea575x-tuner framework
> >             instead of reinventing the wheel.
> >             
> >             Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> >             Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> > 
> > Thanks,
> > Fengguang
> 
> Works for me with 3.5-rc1. There was a fix done in sound/pci/Kconfig that
> should have solved this.

Nice.

> Is CONFIG_SND_TEA575X defined? Do you have a snd_tea575x_tuner module?

Sorry I lost the .config. I'll report back if the error shows up again.

Thanks,
Fengguang
