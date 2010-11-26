Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754301Ab0KZONX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 09:13:23 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:52889 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776Ab0KZONW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 09:13:22 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [RFC/PATCH v6 03/12] media: Entities, pads and links
Date: Fri, 26 Nov 2010 15:13:36 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.36-gentoo-r1; KDE/4.5.3; x86_64; ; )
Cc: linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, sakari.ailus@maxwell.research.nokia.com,
        lennart@poettering.net
References: <1290652099-15102-1-git-send-email-laurent.pinchart@ideasonboard.com> <201011251640.42206.laurent.pinchart@ideasonboard.com> <20101125154952.GJ22298@rakim.wolfsonmicro.main>
In-Reply-To: <20101125154952.GJ22298@rakim.wolfsonmicro.main>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201011261513.37491.laurent.pinchart@ideasonboard.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Thursday 25 November 2010 16:49:52 Mark Brown wrote:
> On Thu, Nov 25, 2010 at 04:40:41PM +0100, Laurent Pinchart wrote:
> > On Thursday 25 November 2010 14:36:50 Mark Brown wrote:
> > > On Thu, Nov 25, 2010 at 03:28:10AM +0100, Laurent Pinchart wrote:
> > > > +	MEDIA_LINK_FLAG_ACTIVE indicates that the link is active and can be
> > > > +	used to transfer media data. When two or more links target a sink
> > > > pad, +	only one of them can be active at a time.
> > > 
> > > Is this supposed to reflect the current state (if the link is carrying
> > > data right now) or if it's possible for the link to carry data?
> > 
> > It's supposed to reflect whether the link can carry data. Think of the
> > active flag as a valve on a pipe. If the valve is open, the link is
> > active. If the valve is closed, the link is inactive. This is unrelated
> > to whether water actually flows through the pipe.
> 
> This seems a confusing name, then - I'd expect an active link to be one
> which is actually carrying data rather than one which is available to
> carry data.  How a more neutrally worded name such as "connected" (which
> is what ASoC uses currently)?

In our current vocabulary "connected" refers to entities between which a link 
exist, regardless of the link state ("valve opened" or "valve closed"). I'm 
not totally happy with "active" either, but if we replace it with "connected" 
we need another word to replace current uses of "connected".

> This also falls through into the power management stuff, we don't want
> to be powering things up unless they're actually doing something right
> now.
> 
> > Immutable links have no valve (in theory you could have an inactive
> > immutable link, but that's not very useful, unless we define immutable
> > as no user- controllable valve, in which case it might be better to
> > rename it as read- only, or create separate immutable and read-only
> > flags - just brainstorming here).
> 
> That was what I was expecting immutable to mean - no user control.  A
> link that's permanantly wired can have the data flow controlled through
> its inputs and outputs, even if it is not itself controllable.

-- 
Regards,

Laurent Pinchart
