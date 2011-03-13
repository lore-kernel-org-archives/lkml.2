Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752336Ab1CMGYx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Mar 2011 01:24:53 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:60515 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751714Ab1CMGYr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Mar 2011 01:24:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=jRQFsWH6LxyT7YWpDxV/0FtTXW+hxJtrRbTmuH2iNoCXEPU3wexA2MRGKeRFF3pW5v
         qRGK92avmk9QoT4MJpUdJb+Ilq7zjcrE7UWtNBU6ySmWKCSBf1s6+9G09AFEZEZm262s
         RMEKU/CVpC4OzXB+qwVaFOxgy+ntJxAMWVtg8=
Date: Sat, 12 Mar 2011 22:24:11 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: linux-kernel@vger.kernel.org, Jeremy Fitzhardinge <jeremy@goop.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        xen-devel@lists.xensource.com, linux-input@vger.kernel.org,
        Olaf Hering <olaf@aepfle.de>
Subject: Re: [PATCH] input/xen-fbfront: advertise either absolute or relative
 coordinates
Message-ID: <20110313062411.GB31566@core.coreip.homeip.net>
References: <alpine.DEB.2.00.1103111124400.2968@kaball-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1103111124400.2968@kaball-desktop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stefano,

On Fri, Mar 11, 2011 at 11:30:10AM +0000, Stefano Stabellini wrote:
> From: Olaf Hering <olaf@aepfle.de>
> 
> A virtualized display device is usually viewed with the vncviewer
> application, either by 'xm vnc domU' or with vncviewer localhost:port.
> vncviewer and the RFB protocol provides absolute coordinates to the
> virtual display. These coordinates are either passed through to a PV
> guest or converted to relative coordinates for a HVM guest.
> 
> A PV guest receives these coordinates and passes them to the kernels
> evdev driver. There it can be picked up by applications such as the
> xorg-input drivers. Using absolute coordinates avoids issues such as
> guest mouse pointer not tracking host mouse pointer due to wrong mouse
> acceleration settings in the guests X display.
> 
> Advertise either absolute or relative coordinates to the input system
> and the evdev driver, depending on what dom0 provides. The xorg-input
> driver prefers relative coordinates even if a devices provides both.

So if I am reading this correctly the original version handled changes
in backend capabilities and could switch between delivering either
relative or absolute coordinates. The new version selects the
capabilities at boot time and sticks with them. Was it really the
intended behavior?

BTW, drivers/input is intended for core input and handlers stuff with
drivers suppsed to be in drivers/input/<type>. Would you mind if I moved
this driver to drivers/input/misc?

Thanks.

-- 
Dmitry
