Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754290Ab1CNLjr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 07:39:47 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:28645 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752677Ab1CNLjp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 07:39:45 -0400
X-IronPort-AV: E=Sophos;i="4.62,315,1297036800"; 
   d="scan'208";a="4772039"
Date: Mon, 14 Mar 2011 11:39:15 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        Olaf Hering <olaf@aepfle.de>
Subject: Re: [PATCH] input/xen-fbfront: advertise either absolute or relative
 coordinates
In-Reply-To: <20110313062411.GB31566@core.coreip.homeip.net>
Message-ID: <alpine.DEB.2.00.1103141135170.3382@kaball-desktop>
References: <alpine.DEB.2.00.1103111124400.2968@kaball-desktop> <20110313062411.GB31566@core.coreip.homeip.net>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 13 Mar 2011, Dmitry Torokhov wrote:
> Hi Stefano,
> 
> On Fri, Mar 11, 2011 at 11:30:10AM +0000, Stefano Stabellini wrote:
> > From: Olaf Hering <olaf@aepfle.de>
> > 
> > A virtualized display device is usually viewed with the vncviewer
> > application, either by 'xm vnc domU' or with vncviewer localhost:port.
> > vncviewer and the RFB protocol provides absolute coordinates to the
> > virtual display. These coordinates are either passed through to a PV
> > guest or converted to relative coordinates for a HVM guest.
> > 
> > A PV guest receives these coordinates and passes them to the kernels
> > evdev driver. There it can be picked up by applications such as the
> > xorg-input drivers. Using absolute coordinates avoids issues such as
> > guest mouse pointer not tracking host mouse pointer due to wrong mouse
> > acceleration settings in the guests X display.
> > 
> > Advertise either absolute or relative coordinates to the input system
> > and the evdev driver, depending on what dom0 provides. The xorg-input
> > driver prefers relative coordinates even if a devices provides both.
> 
> So if I am reading this correctly the original version handled changes
> in backend capabilities and could switch between delivering either
> relative or absolute coordinates. The new version selects the
> capabilities at boot time and sticks with them. Was it really the
> intended behavior?
 
Yes, as Olaf said, we prefer absolute coordinates so we want to make
sure absolute coordinates are the ones that are used if both are
available.


> BTW, drivers/input is intended for core input and handlers stuff with
> drivers suppsed to be in drivers/input/<type>. Would you mind if I moved
> this driver to drivers/input/misc?

I am OK with it.
Konrad, any comments on this?
