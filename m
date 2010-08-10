Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932135Ab0HJOzR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 10:55:17 -0400
Received: from perceval.irobotique.be ([92.243.18.41]:53772 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757731Ab0HJOzO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 10:55:14 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [patch -NEXT] usb/gadget/webcam: fix Kconfig depends again
Date: Tue, 10 Aug 2010 16:53:04 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.34; KDE/4.4.3; x86_64; ; )
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, gregkh@suse.de,
        lud <linux-usb@vger.kernel.org>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        David Brownell <dbrownell@users.sourceforge.net>
References: <20100809132314.789e13f3.sfr@canb.auug.org.au> <201008101416.31188.laurent.pinchart@ideasonboard.com> <4C6166D9.60607@oracle.com>
In-Reply-To: <4C6166D9.60607@oracle.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201008101653.08358.laurent.pinchart@ideasonboard.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Randy,

On Tuesday 10 August 2010 16:48:57 Randy Dunlap wrote:
> On 08/10/10 05:16, Laurent Pinchart wrote:
> > On Monday 09 August 2010 19:55:20 Randy Dunlap wrote:
> >> From: Randy Dunlap <randy.dunlap@oracle.com>
> >> 
> >> The USB gadget webcam driver uses V4L2 interfaces, so it should depend
> >> on VIDEO_V4L2 instead of VIDEO_DEV.  This fixes a lot of build errors
> >> when V4L2 is not enabled:
> >> 
> >> ERROR: "v4l2_event_unsubscribe" [drivers/usb/gadget/g_webcam.ko]
> >> undefined! ERROR: "v4l2_event_queue" [drivers/usb/gadget/g_webcam.ko]
> >> undefined! ERROR: "video_device_release"
> >> [drivers/usb/gadget/g_webcam.ko] undefined! ERROR: "video_usercopy"
> >> [drivers/usb/gadget/g_webcam.ko] undefined! ERROR: "v4l2_event_dequeue"
> >> [drivers/usb/gadget/g_webcam.ko] undefined! ERROR:
> >> "video_register_device" [drivers/usb/gadget/g_webcam.ko] undefined!
> >> ERROR: "video_device_alloc" [drivers/usb/gadget/g_webcam.ko] undefined!
> >> ERROR: "v4l2_event_subscribe" [drivers/usb/gadget/g_webcam.ko]
> >> undefined! ERROR: "video_unregister_device"
> >> [drivers/usb/gadget/g_webcam.ko] undefined!
> >> ERROR: "v4l2_fh_init" [drivers/usb/gadget/g_webcam.ko] undefined!
> >> ERROR: "v4l2_event_pending" [drivers/usb/gadget/g_webcam.ko] undefined!
> >> ERROR: "v4l2_event_init" [drivers/usb/gadget/g_webcam.ko] undefined!
> >> ERROR: "video_devdata" [drivers/usb/gadget/g_webcam.ko] undefined!
> >> ERROR: "v4l2_event_alloc" [drivers/usb/gadget/g_webcam.ko] undefined!
> >> ERROR: "v4l2_fh_add" [drivers/usb/gadget/g_webcam.ko] undefined!
> >> ERROR: "v4l2_fh_del" [drivers/usb/gadget/g_webcam.ko] undefined!
> >> ERROR: "v4l2_fh_exit" [drivers/usb/gadget/g_webcam.ko] undefined!
> > 
> > All those symbols should be defined when VIDEO_DEV is selected.
> > 
> >> ERROR: "v4l2_ctrl_fill" [drivers/media/video/v4l2-common.ko] undefined!
> >> ERROR: "v4l2_ctrl_get_menu" [drivers/media/video/v4l2-common.ko]
> >> undefined!
> > 
> > Those 2 symbols require VIDEO_V4L2 but are not used by the webcam gadget
> > driver.
> > 
> >> ERROR: "v4l2_device_unregister_subdev"
> >> [drivers/media/video/v4l2-common.ko] undefined!
> >> ERROR: "v4l2_device_register_subdev"
> >> [drivers/media/video/v4l2-common.ko] undefined!
> > 
> > Those two symbols should be defined when VIDEO_DEV is selected. They are
> > not used by the webcam gadget driver.
> 
> Summary:  I should drop this patch and look elsewhere for the problem,
> Right?

I think the problem comes from somewhere else, yes. Your patch won't hurt, but 
I don't see how it could fix the problem either.

-- 
Regards,

Laurent Pinchart
