Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751711Ab1CNKB5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 06:01:57 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:59093 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750958Ab1CNKBz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 06:01:55 -0400
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+zrwiavkK6tmQaLfmztM8TOFGjy0GEyo=
X-RZG-CLASS-ID: mo00
Date: Mon, 14 Mar 2011 11:01:44 +0100
From: Olaf Hering <olaf@aepfle.de>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        linux-kernel@vger.kernel.org, Jeremy Fitzhardinge <jeremy@goop.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        xen-devel@lists.xensource.com, linux-input@vger.kernel.org
Subject: Re: [PATCH] input/xen-fbfront: advertise either absolute or relative
 coordinates
Message-ID: <20110314100144.GA4572@aepfle.de>
References: <alpine.DEB.2.00.1103111124400.2968@kaball-desktop>
 <20110313062411.GB31566@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20110313062411.GB31566@core.coreip.homeip.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 12, Dmitry Torokhov wrote:

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

Yes, as mentioned in the description above, using absolute coordinates in
the guests X11 is prefered because it avoids that the guest mouse
pointer gets out of sync with the host/desktop mouse pointer.
Very old Xen versions did not send absolute coordinates, but recent
versions do.

Olaf
