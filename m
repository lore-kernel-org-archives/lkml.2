Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756725Ab0KSU0J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 15:26:09 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:54316 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754797Ab0KSU0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 15:26:08 -0500
Date: Fri, 19 Nov 2010 20:25:59 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, rpurdie@rpsys.net,
        nouveau@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-acpi@vger.kernel.org,
        lenb@kernel.org
Subject: Re: [PATCH 1/5] Backlight: Add backlight type
Message-ID: <20101119202558.GA10898@srcf.ucam.org>
References: <1290182036-30484-1-git-send-email-mjg@redhat.com> <20101119120523.15bc341c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101119120523.15bc341c.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 19, 2010 at 12:05:23PM -0800, Andrew Morton wrote:
> On Fri, 19 Nov 2010 10:53:52 -0500
> Matthew Garrett <mjg@redhat.com> wrote:
> 
> > There may be multiple ways of controlling the backlight on a given machine.
> > Allow drivers to expose the type of interface they are providing, making
> > it possible for userspace to make appropriate policy decisions.
> > 
> > ...
> >
> >  60 files changed, 102 insertions(+), 0 deletions(-)
> 
> This patch has a pretty short half-life.

Well, ideally it would have landed in the backlight tree when I sent it 
months ago. Then we'd have the opportunity to ensure that everything was 
fixed up before it went in in the merge window.

> > @@ -62,6 +68,8 @@ struct backlight_properties {
> >  	/* FB Blanking active? (values as for power) */
> >  	/* Due to be removed, please use (state & BL_CORE_FBBLANK) */
> >  	int fb_blank;
> > +	/* Backlight type */
> > +	enum backlight_type type;
> >  	/* Flags used to signal drivers of state changes */
> >  	/* Upper 4 bits are reserved for driver internal use */
> >  	unsigned int state;
> 
> And if/when the half-life expires, we'll have drivers in-tree which
> forget to set backlight_properties.type.  I haven't checked, but if
> we're lucky they will default to "0".

Depends entirely on whether they kzalloc the structure or not before
calling backlight_device_register(). 

> What will be the runtime effects upon such unconverted drivers? 
> Ideally we'd like them to continue to work OK, and to emit a runtime
> warning.  In which case you'll need BACKLIGHT_RAW=1 so the unconverted
> driver can be detected, warned about and fixed up by the core code.

The worst case I can think of is that we walk off the array - I guess 
there's an argument for sanity checking that in backlight_show_type().

-- 
Matthew Garrett | mjg59@srcf.ucam.org
