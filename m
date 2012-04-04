Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756868Ab2DDPwj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 11:52:39 -0400
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:57408 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756415Ab2DDPwi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 11:52:38 -0400
Date: Wed, 4 Apr 2012 18:52:34 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: "ABRAHAM, KISHON VIJAY" <kishon@ti.com>
Cc: Felipe Balbi <balbi@ti.com>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        davinci-linux-open-source@linux.davincidsp.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb: musb: make modules behave better
Message-ID: <20120404155234.GC2913@valkosipuli.localdomain>
References: <1327574749-18552-1-git-send-email-balbi@ti.com>
 <20120402143448.GD922@valkosipuli.localdomain>
 <CAAe_U6+kqyn7mdujJKr-ysC+HyA0=pyO012H-FxYY6DSRjznJQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAe_U6+kqyn7mdujJKr-ysC+HyA0=pyO012H-FxYY6DSRjznJQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kishon,

On Mon, Apr 02, 2012 at 10:33:10PM +0530, ABRAHAM, KISHON VIJAY wrote:
> Hi,
> 
> On Mon, Apr 2, 2012 at 8:04 PM, Sakari Ailus <sakari.ailus@iki.fi> wrote:
> > Hi Felipe,
> >
> > On Thu, Jan 26, 2012 at 12:45:49PM +0200, Felipe Balbi wrote:
> >> There's really no point in doing all that
> >> initcall trickery when we can safely let
> >> udev handle module probing for us.
> >>
> >> Remove all of that trickery, by moving everybody
> >> to module_init() and making proper use of
> >> platform_device_register() rather than
> >> platform_device_probe().
> >>
> >> Signed-off-by: Felipe Balbi <balbi@ti.com>
> >> ---
> >>
> >> Because this falls into the "has never worked before" category
> >> I will be sending this only on the next merge window. This
> >> also gives people enough time to complain about any mistakes
> >> on the patch.
> >
> > This patch looks correct and right to me, but it breaks musb when it's
> > compiled into the kernel, at least on the Nokia N950. I haven't yet figured
> > out exactly why, though.
> 
> Is it an abort?
> You can use the patch which I've sent to the list last week for fixing it.
> http://www.spinics.net/lists/linux-usb/msg60603.html.

It wasn't abort --- the USB simply refused to work. I tested your patch and
it does indeed fix the problem I had.

Feel free to add:

Tested-by: Sakari Ailus <sakari.ailus@iki.fi>

Cheers,

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
