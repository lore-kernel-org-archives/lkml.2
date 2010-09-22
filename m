Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753412Ab0IVJoX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 05:44:23 -0400
Received: from ist.d-labs.de ([213.239.218.44]:50144 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752289Ab0IVJoW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 05:44:22 -0400
Date: Wed, 22 Sep 2010 11:44:19 +0200
From: Florian Mickler <florian@mickler.org>
To: Andy Walls <awalls@md.metrocast.net>
Newsgroups: gmane.linux.kernel,gmane.comp.video.dri.devel
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, Dave Airlie <airlied@redhat.com>,
        Jon Smirl <jonsmirl@gmail.com>,
        =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
        Alex Deucher <alexdeucher@gmail.com>,
        Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: [PATCH] drm/sysfs: Provide per connector control of DRM KMS
 polling
Message-ID: <20100922114419.7f9766c5@schatten.dmk.lab>
In-Reply-To: <1285017108.30856.7.camel@morgan.silverblock.net>
References: <1284987540.2242.29.camel@morgan.silverblock.net>
	<20100920185232.GA29263@kroah.com>
	<1285017108.30856.7.camel@morgan.silverblock.net>
X-Newsreader: Claws Mail 3.7.6cvs31 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[cc'd chris wilson]

Hi Andy!

On Mon, 20 Sep 2010 19:02:30 -0400
Andy Walls <awalls@md.metrocast.net> wrote:

> BTW, I found that Chris Wilson recently committed a change to inhibit
> all drm connector polling globally for a different reason:
> 
> http://git.kernel.org/?p=linux/kernel/git/airlied/drm-2.6.git;a=commit;h=e58f637bb96d5a0ae0919b9998b891d1ba7e47c9
> 
> That commit message shows a case where the driver decides polling needs
> to happen, but the human knows differently and manual control over
> connector polling mitigates the problem.


On Mon, 20 Sep 2010 17:11:48 -0400
Andy Walls <awalls@md.metrocast.net> wrote:

> On Mon, 2010-09-20 at 11:52 -0700, Greg KH wrote:
> > On Mon, Sep 20, 2010 at 08:59:00AM -0400, Andy Walls wrote:
>  
> > > This change allows the root user to disable (and re-enable) DRM KMS
> > > connector polling on a per connector basis via sysfs, like so:
> > > 
> > >         # cat /sys/class/drm/card0/card0-DVI-D-1/polled
> > >         [hotplug_detectable] connect disconnect
> 
> > You are adding a sysfs file, yet you forgot to add a file in
> > Documentation/ABI.  Please fix that and resend the patch.
> 
> Oops, process failure, sorry.
> Will do.
> 
> Regards,
> Andy
> 

I thought sysfs files should be one thing per file... so, maybe
card0-DVI-D-1/link_status and card0-DVI-D-1/hotplug_detectable with 0/1
content would be easier to manipulate and parse? 

I have to defer to the drm maintainers for the usecases. But how is
having a monitor with a broken edid handled right now? While the output
is connected and used, it probably just stops polling?

cheers,
Flo




