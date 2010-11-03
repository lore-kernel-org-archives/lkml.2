Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932581Ab0KCTIH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 15:08:07 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:40963 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932446Ab0KCTIC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 15:08:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=j3ulGg3ynDb2sy8jlTDhIO61DsOLQAZQsHgwo3DMa6WEDYBVQbxQyNRalhykn+vf3y
         7mwGRC7OIAnJnAm3wv93zm5KidSkATTWCafC9pNEn9TmrKFlB0LZxrlhaWtANCFhIxDP
         4f2cjy2SZwYWKcxRRvtJG6lbl8bXXB1WG4Y8o=
Date: Wed, 3 Nov 2010 12:07:52 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        Naveen Kumar GADDIPATI <naveen.gaddipati@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        STEricsson_nomadik_linux <STEricsson_nomadik_linux@list.st.com>,
        linux-input@vger.kernel.org
Subject: Re: [PATCHv1] staging: Synaptics RMI4 touchpad driver support
Message-ID: <20101103190752.GA4552@core.coreip.homeip.net>
References: <1288699725-14405-1-git-send-email-naveen.gaddipati@stericsson.com>
 <20101102140337.GC9387@kroah.com>
 <4CD01CD8.3090206@stericsson.com>
 <20101102154029.GH11778@core.coreip.homeip.net>
 <20101103181058.GE7441@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101103181058.GE7441@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 03, 2010 at 11:10:58AM -0700, Greg KH wrote:
> On Tue, Nov 02, 2010 at 08:40:30AM -0700, Dmitry Torokhov wrote:
> > On Tue, Nov 02, 2010 at 03:14:48PM +0100, Linus Walleij wrote:
> > > Greg KH wrote:
> > > 
> > > >> +Wait for the official upstream synaptics rmi4 clearpad drivers as promised over the past few months
> > > >> +Merge any device support needed from this driver into it
> > > >> +Delete this driver
> > > > 
> > > > Huh?
> > > > 
> > > > Why not just add this driver to the kernel tree instead?  When the
> > > > "promised" driver then eventually shows up (who is promising it?) then
> > > > delete the thing.
> > 
> > The same reason as there were several wireless drivers in staging?
> 
> Ok, that's a good enough reason for me :)
> 
> > > Well, Alan (on behalf of Ramesh Agarwal) sent out a very similar
> > > patch (Titled "Synaptics TM1217 Touchscreen Controller driver")
> > > the other day, and OTOMH that was after discussions with Synaptics
> > > where they said they were working on a "real" driver (a rather
> > > complex RMI4 bus driver) and we believe they will fix that sooner
> > > or later.
> > > 
> > > So, until sooner or later happens we thought we'd keep it in staging.
> > > 
> > > If you prefer both Alan and we can probably submit our patches for
> > > inclusion in the proper place.
> > > 
> > > A side effect may be that the Synaptics RMI4 people may have trouble
> > > to merge their driver into input/ since they may be requested to
> > > refactor the existing drivers to use it rather than merging new stuff,
> > > putting some burden on their shoulders.
> > > 
> > 
> > No, they have not been requested to change any existing [in tree]
> > drivers. They however been asked to convert to the driver core
> > primitives instead of rolling their own infprastructure to implement
> > devices and drivers binding.
> 
> If you don't object to this driver going in, and there is a path forward
> in the future for it to be able to be removed, then I will be glad to
> add it.
> 
> Can I add your Acked-by: to the patch for this?
> 

Umm... I haven't looked in detail, but I think it is sane enough for
staging... Much better than Alan's version that seemed to create a
separate input device for every finger. Needs to depend on INPUT and
probably regulators framework...  Probe function may call
input_free_device() after calling input_register_device() which is not
good.

Basically staging is yours, you can add whatever you want to it ;)

-- 
Dmitry
