Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753091Ab1LSUPs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 15:15:48 -0500
Received: from smtprelay-b11.telenor.se ([62.127.194.20]:37578 "EHLO
	smtprelay-b11.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752951Ab1LSUPo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 15:15:44 -0500
X-SENDER-IP: [85.230.168.209]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqBGAK2a705V5qjRPGdsb2JhbABDqReCThkBAQEBNzKBcgEBBScTHCMQCAMYLhQlChqID7giE4sOYwSNBCmHUIVejFI
X-IronPort-AV: E=Sophos;i="4.71,378,1320620400"; 
   d="scan'208";a="14857118"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Mon, 19 Dec 2011 21:30:59 +0100
To: Oliver Neukum <oliver@neukum.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Matthew Garrett <mjg@redhat.com>
Subject: Re: [PATCH v2] Input: bcm5974 - Fix USB autosuspend
Message-ID: <20111219203059.GA6749@polaris.bitmath.org>
References: <1324314123-2200-1-git-send-email-rydberg@euromail.se>
 <201112191842.08635.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201112191842.08635.oliver@neukum.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 19, 2011 at 06:42:08PM +0100, Oliver Neukum wrote:
> Am Montag, 19. Dezember 2011, 18:02:03 schrieb Henrik Rydberg:
> >  static int bcm5974_suspend(struct usb_interface *iface, pm_message_t message)
> > @@ -870,6 +884,9 @@ static int bcm5974_probe(struct usb_interface *iface,
> >                          dev->tp_data, dev->cfg.tp_datalen,
> >                          bcm5974_irq_trackpad, dev, 1);
> >  
> > +       /* Required for autosuspend */
> > +       iface->needs_remote_wakeup = 1;
> > +
> >         /* create bcm5974 device */
> >         usb_make_path(udev, dev->phys, sizeof(dev->phys));
> >         strlcat(dev->phys, "/input0", sizeof(dev->phys));
> 
> It is not nice to set needs_remote_wakeup on suspend() because
> it influences the decision of usbcore to suspend at all, in particular
> manually set quirks will not be fully honored if you do it this way.
> In addition it will never be reset, even as the device is closed.
> 
> Please set it in open() and clear it in close()

Oliver: thanks for the advice, and thanks for the review.

Matthew: There seems to be a problem with the hardware wake-up in
response to short taps on the trackpad. Too much of a regression to be
acceptable, I am afraid. Unless this laptop (MBA 3.1) turns out to be
a special case, I think we will have to let this patch rest.

Thanks,
Henrik
