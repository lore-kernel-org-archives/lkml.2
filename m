Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965820Ab2B1Qub (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 11:50:31 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:53310 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965803Ab2B1Qu2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 11:50:28 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of gregkh@linuxfoundation.org designates 10.68.212.3 as permitted sender) smtp.mail=gregkh@linuxfoundation.org
Date: Tue, 28 Feb 2012 08:47:02 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: stable@kernel.org, stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org
Subject: Re: OMAP4 HDMI PHY bug work-around for stable
Message-ID: <20120228164702.GB11021@kroah.com>
References: <1328787865.1909.64.camel@deskari>
 <1330416193.2123.4.camel@deskari>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1330416193.2123.4.camel@deskari>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 28, 2012 at 10:03:13AM +0200, Tomi Valkeinen wrote:
> Hi,
> 
> I haven't seen these merged nor any comment for these. Perhaps
> stable@kernel.org was wrong address, so adding stable@vger.kernel.org
> too.

Yes, stable@kernel.org has been "dead" since last October.

> I have added one additional fix into for-3.2-stable branch, which fixes
> a problem with panel detection that the GPIO changes brought.

Sorry, but I don't accept pull requests.  I need patches in email form,
as described in the file, Documentation/stable_kernel_rules.txt.  Please
feel free to send them from your git tree that way.

> On Thu, 2012-02-09 at 13:44 +0200, Tomi Valkeinen wrote:
> > Hi,
> > 
> > There is a hardware bug on OMAP4, which may cause the HDMI output to
> > break irreversibly. A work-around for the bug has been merged into
> > mainline, but is missing from stable.
> > 
> > I've backported the necessary patches on top of 3.0, 3.1 and 3.2 stable
> > trees, and pushed the following branches to:

3.1 is long dead, so I can't do anything with those patches, sorry.

> > git://gitorious.org/linux-omap-dss2/linux.git
> > 
> > fixes/for-3.0-stable
> > fixes/for-3.1-stable
> > fixes/for-3.2-stable
> > 
> > 3.0 and 3.1 branches additionally contain a patch "OMAP: DSS2: HDMI: use
> > default dividers", which fixes a problem with the HDMI clock divider.
> > Without that the HDMI output won't start at all on those versions.
> > 
> > The branches contain the following backported patches:
> > 
> >       OMAP: DSS2: HDMI: use default dividers
> >       OMAP: 4430SDP/Panda: use gpio_free_array to free HDMI gpios
> >       OMAP: 4430SDP/Panda: rename HPD GPIO to CT_CP_HPD
> >       OMAPDSS: remove wrong HDMI HPD muxing
> >       OMAP: 4430SDP/Panda: setup HDMI GPIO muxes
> >       OMAP: 4430SDP/Panda: add HDMI HPD gpio
> >       OMAPDSS: HDMI: PHY burnout fix
> > 
> > Of those, the actual fix is in the last one, but as the GPIOs for HDMI
> > were a mess, they needed some cleanup patches before the fix could be
> > made.

That seems like a lot of backporting for a single fix, but I'll be glad
to review them when you send them.

> > I'm not familiar with the process with stable kernels, so are the
> > branches above fine to get them merged? Or should I send the patches
> > with git-send-email?

Again, please read Documentation/stable_kernel_rules.txt, it explains
how this all works.

thanks,

greg k-h
