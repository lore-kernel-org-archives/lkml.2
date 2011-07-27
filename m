Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754786Ab1G0QYu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 12:24:50 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:56942 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754508Ab1G0QYs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 12:24:48 -0400
X-Sasl-enc: 0EV7h2Mpu3snij1PjBPulZn8IRKH+ekYFVqna/vmdLZE 1311783887
Date: Wed, 27 Jul 2011 09:11:21 -0700
From: Greg KH <greg@kroah.com>
To: Gopal <gtiwari@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: DELL-ST2220T Touch Screen Monitor Driver Patch
Message-ID: <20110727161121.GC19660@kroah.com>
References: <4E2FF73A.8090906@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E2FF73A.8090906@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 27, 2011 at 05:02:10PM +0530, Gopal wrote:
> Hi,
> 
> We have recently Created support for the DELL-ST2220T Touch Screen Monitor.
> 
> More of Technical Details :
> 
> We have Written separate driver and merge it with the different
> touchscreen monitor drivers in
> /driver/input/touchscreen/usbtouchscreen.c.
> 
> changes as in :
> 
> 1) Device Specific USB Control Request.
> 
>    ctrl_buf[0] = 0x07;
>         ctrl_buf[1] = 0x02;
>         ctrl_buf[2] = 0x02;
> 
>         for (i = 0; i < 3; i++)
>         {
>                 ret = usb_control_msg(udev, usb_sndctrlpipe(udev, 0), 0x09,
>                 0x21, 0x0307, 0x00, ctrl_buf,
>                 0x03, USB_CTRL_SET_TIMEOUT);
> 
>                 dbg("%s - usb_control_msg - 0x21 0x09 - bytes|err: %d\n",
>                     __func__, ret);
> 
>                 if (ret == 0 )
>                         break;
> 
>                 msleep(150);
>         }
> 
>         msleep(150);
> 
>         for (i = 0; i < 6; i++)
>         {
>                 ret = usb_control_msg(udev, usb_rcvctrlpipe(udev, 0),
>                                       0x01,
>                                       0xA1,
>                                       0x308, 0x00, ctrl_buf, 2,
> USB_CTRL_SET_TIMEOUT);
>                 dbg("%s - usb_control_msg - bytes|err: %d",
>                     __func__, ret);
> 
>                 dbg(" %x %x\n", ctrl_buf[0], ctrl_buf[1]);
> 
>                 msleep(50);
>         }
> 
> 
> 
> 2) Blacklisting from the HID Class as device does not support
> Standard Mouse Protocol as per the Interface Descriptor of the
> Device.
>  So Instead of making it separate Driver we merge it with
> driver/input/touchscreen Section.
> 
> 
> 
> 3) HID Data Fatching protocol parsing.
> 
> 
> static int st2220t_read_data(struct usbtouch_usb *dev, unsigned char *pkt)
> {
>         if(pkt[9] != 0xff && pkt[11])
>         {
>                 dev->x = (pkt[10]<< 8)| pkt[9];
>                 dev->y = (pkt[12]<< 8)| pkt[11];
>                 dev->x =  ((dev->x)* 9) - 0x200;
>                 dev->y =  (dev->y)* 15;
>                 input_report_abs(dev->input, ABS_X, dev->x);
>                 input_report_abs(dev->input, ABS_Y, dev->y);
>         }
> 
>         dev->x = (pkt[4]<< 8)| pkt[3];
>         dev->y = (pkt[6]<< 8)| pkt[5];
>         dev->x =  ((dev->x)* 9) - 0x200;
>         dev->y =  (dev->y)* 15;
> 
>         dev->touch = (pkt[2] & 0x03) ? 1 : 0;
> 
>         return 1;
> }
> 
> Some of the changes to the respective file is mentioned in the mail
> to get the full driver changes you can see with in the patch attach
> with this mail.
> 
> Please Verify this and reply me.

Very nice, but could you take a look at Documentation/SubmittingPatches
and resend it with the proper Signed-off-by: line and cc: the correct
subsystem maintainer (as found by scripts/get_maintainer.pl).

thanks,

greg k-h
