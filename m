Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756697Ab0KSUgG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 15:36:06 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40032 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754622Ab0KSUgE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 15:36:04 -0500
Date: Fri, 19 Nov 2010 12:35:50 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-kernel@vger.kernel.org, rpurdie@rpsys.net,
        nouveau@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-acpi@vger.kernel.org,
        lenb@kernel.org
Subject: Re: [PATCH 1/5] Backlight: Add backlight type
Message-Id: <20101119123550.cf2ccff5.akpm@linux-foundation.org>
In-Reply-To: <20101119202558.GA10898@srcf.ucam.org>
References: <1290182036-30484-1-git-send-email-mjg@redhat.com>
	<20101119120523.15bc341c.akpm@linux-foundation.org>
	<20101119202558.GA10898@srcf.ucam.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Nov 2010 20:25:59 +0000
Matthew Garrett <mjg59@srcf.ucam.org> wrote:

> On Fri, Nov 19, 2010 at 12:05:23PM -0800, Andrew Morton wrote:
> > On Fri, 19 Nov 2010 10:53:52 -0500
> > Matthew Garrett <mjg@redhat.com> wrote:
> > 
> > > There may be multiple ways of controlling the backlight on a given machine.
> > > Allow drivers to expose the type of interface they are providing, making
> > > it possible for userspace to make appropriate policy decisions.
> > > 
> > > ...
> > >
> > >  60 files changed, 102 insertions(+), 0 deletions(-)
> > 
> > This patch has a pretty short half-life.
> 
> Well, ideally it would have landed in the backlight tree when I sent it 
> months ago. Then we'd have the opportunity to ensure that everything was 
> fixed up before it went in in the merge window.

Richard got distracted.  At present I'm grabbing the leds and backlight
patches and Richard is reviewing them as they fly past.

I don't see there's much point in me merging this patch series so if it
survives review, I'd suggest that you put it into an mjg tree and
thence into linux-next and mainline?

> > > @@ -62,6 +68,8 @@ struct backlight_properties {
> > >  	/* FB Blanking active? (values as for power) */
> > >  	/* Due to be removed, please use (state & BL_CORE_FBBLANK) */
> > >  	int fb_blank;
> > > +	/* Backlight type */
> > > +	enum backlight_type type;
> > >  	/* Flags used to signal drivers of state changes */
> > >  	/* Upper 4 bits are reserved for driver internal use */
> > >  	unsigned int state;
> > 
> > And if/when the half-life expires, we'll have drivers in-tree which
> > forget to set backlight_properties.type.  I haven't checked, but if
> > we're lucky they will default to "0".
> 
> Depends entirely on whether they kzalloc the structure or not before
> calling backlight_device_register(). 

Well.  Even if it's uninitialised, the chances of the value being 1, 2
or 3 for all users are pretty small, so we'll still get to hear about
it if the runtime check is appropriately implemented.

> > What will be the runtime effects upon such unconverted drivers? 
> > Ideally we'd like them to continue to work OK, and to emit a runtime
> > warning.  In which case you'll need BACKLIGHT_RAW=1 so the unconverted
> > driver can be detected, warned about and fixed up by the core code.
> 
> The worst case I can think of is that we walk off the array - I guess 
> there's an argument for sanity checking that in backlight_show_type().

OK, well please have a think about it, see what you can do to handle
unconverted (and possibly out-of-tree) drivers in a friendly fashion.

