Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934056Ab1IOPaG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 11:30:06 -0400
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:46584 "EHLO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933872Ab1IOPaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 11:30:04 -0400
Subject: Re: Proposal for a low-level Linux display framework
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
To: Keith Packard <keithp@keithp.com>
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linaro-dev@lists.linaro.org,
        "Clark, Rob" <rob@ti.com>, Archit Taneja <archit@ti.com>
In-Reply-To: <yunboul7sx7.fsf@aiko.keithp.com>
References: <1316088425.11294.78.camel@lappyti>
	 <yunboul7sx7.fsf@aiko.keithp.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 15 Sep 2011 18:29:54 +0300
Message-ID: <1316100594.23214.65.camel@deskari>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-09-15 at 09:59 -0500, Keith Packard wrote:
> On Thu, 15 Sep 2011 15:07:05 +0300, Tomi Valkeinen <tomi.valkeinen@ti.com> wrote:
> 
> > This was a very rough and quite short proposal, but I'm happy to improve
> > and extend it if it's not totally shot down.
> 
> Jesse Barnes has put together a proposal much like this to work within
> the existing DRM environment. This is pretty much the last piece of
> missing mode-setting functionality that we know of, making DRM capable
> of fully supporting existing (and planned) devices.
> 
> Here's a link to some older discussion on the issue, things have changed
> a bit since then and we had a long talk about this during the X
> Developers' Conference this week in Chicago. Expect an update to his
> proposal in the coming weeks.
> 
> http://lists.freedesktop.org/archives/dri-devel/2011-April/010559.html
> 

Thanks for the link.

Right, DRM has already components I described in my proposal, and adding
overlays brings it even closer. However, I think there are two major
differences:

1) It's part of DRM, so it doesn't help fb or v4l2 drivers. Except if
the plan is to make DRM the core Linux display framework, upon which
everything else is built, and fb and v4l2 are changed to use DRM.

But even if it was done like that, I see that it's combining two
separate things: 1) the lower level HW control, and 2) the upper level
buffer management, policies and userspace interfaces.

2) It's missing the panel driver part. This is rather important on
embedded systems, as the panels often are not "dummy" panels, but they
need things like custom initialization, sending commands to adjust
backlight, etc.

 Tomi


