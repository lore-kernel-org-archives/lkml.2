Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752958Ab0EFVee (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 17:34:34 -0400
Received: from web94902.mail.in2.yahoo.com ([203.104.17.140]:34905 "HELO
	web94902.mail.in2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751171Ab0EFVec convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 17:34:32 -0400
Message-ID: <141474.48175.qm@web94902.mail.in2.yahoo.com>
X-YMail-OSG: VjhlVY4VM1mjCA6.Y78YgUmcLdUpLZuvJx18WQjtpYc0ba3
 SHd_JZw4ZurGJWZSu.Rs28dyTmZaqpC64lsTnNrdMMudeRTOKyw8CwAFUGHV
 RLjdI9hcpVb8ls0_mPieWkCYzdGve9NRrTK.7NJ2I573uCV41kJC_xN6F2mm
 dD.AgbaVru_e5yHFx75tP6nxZNnPnGzpSF0e4Xlq275OU03ONmyHp8ijZ.a0
 R65_u_YmcxqBEslbfyfZe0Lq_WOx74VBLLJLC7jVJbthguInb2O6bCnD7yfL
 O_.qOvTBRXmMlCT0pw6mp
X-RocketYMMF: pavan_savoy
X-Mailer: YahooMailClassic/10.1.11 YahooMailWebService/0.8.103.269680
Date: Fri, 7 May 2010 03:04:29 +0530 (IST)
From: Pavan Savoy <pavan_savoy@ti.com>
Reply-To: pavan_savoy@ti.com
Subject: RE: [PATCH] drivers: staging: GPS protocol driver for wl128x
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: greg <gregkh@suse.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       NishanthMenon <nm@ti.com>
In-Reply-To: <19F8576C6E063C45BE387C64729E7394044E351E54@dbde02.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



--- On Fri, 7/5/10, Savoy, Pavan <pavan_savoy@ti.com> wrote:

> From: Savoy, Pavan <pavan_savoy@ti.com>
> Subject: RE: [PATCH] drivers: staging: GPS protocol driver for wl128x
> To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
> Cc: "greg" <gregkh@suse.de>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Menon, Nishanth" <nm@ti.com>
> Date: Friday, 7 May, 2010, 2:00 AM
> 
> Alan,
>  
> > -----Original Message-----
> > From: Savoy, Pavan
> > Sent: Wednesday, May 05, 2010 11:04 AM
> > To: 'Alan Cox'
> > Cc: greg; linux-kernel@vger.kernel.org
> > Subject: RE: [PATCH] drivers: staging: GPS protocol
> driver for wl128x
> > 
> > Alan,
> > 
> > 
> > ----------------
> > Thanks & Regards,
> > Pavan Savoy | x0099669
> > 
> > > -----Original Message-----
> > > From: Alan Cox [mailto:alan@lxorguk.ukuu.org.uk]
> > > Sent: Wednesday, May 05, 2010 6:12 AM
> > > To: Savoy, Pavan
> > > Cc: greg; linux-kernel@vger.kernel.org
> > > Subject: Re: [PATCH] drivers: staging: GPS
> protocol driver for wl128x
> > >
> > > On Tue, 4 May 2010 21:55:43 +0530 (IST)
> > > Pavan Savoy <pavan_savoy@ti.com>
> wrote:
> > >
> > > > Greg, Alan,
> > > >
> > > > Just to complete the circle on N_TI_WL, find
> below the GPS driver which makes use of the shared
> > transport
> > > line discipline.
> > > >
> > > > This driver provides a TTY line character
> device to application/middle-ware running on host, as if
> the
> > > device is directly connected over UART to a GPS
> chip.
> > >
> > > This doesn't appear to be a tty device ?
> > 
> > A typo here, I meant "TTY like" character device, and
> it not certainly a character device.
> > 
> > >
> > > > Almost all actions that can be done on a
> /dev/ttySx can be done on this /dev/tigps device.
> > >
> > > Hardly true. A tty driver has a very precisely
> defined set of behaviours
> > > and a lot of ioctls and interfaces your driver
> doesn't. Our gps
> > > interfaces are only tty drivers because
> historically they were plugged
> > > into serial ports so I'm not sure the 'not a tty'
> bit actually matters.
> > 
> > Yes. I agree, and hence mentioned almost all.
> > 
> > > Codewise its the same as all the rest - only one
> instance possible and
> > > poking around in globals with no visible or
> documented locking.
> 
> To support this multiple device thingy and avoid the single
> device limit, I plan to do something like this,
> 
> The ST driver would be platform_device - as it is already.
> ST's probe would do the ldisc registration, and also do the
> dev_set_drvdata of all the internal data (Tx queues, locks,
> list of protocols) on this device.
> 
> Apart from this the BT, FM and GPS would also further be
> platform devices, and then,
> In the dev.platform_data of each of these BT, FM and GPS
> devices, I will enter the "parent ST device", these
> protocols want to attach themselves to.
> 
> And in probe of the driver for each of these BT, FM and GPS
> devices, I will do the same "st_register" where in now I can
> access the ST related data by retrieving the internal using
> the parent device.
> 
> Examples:
> Here are the 2 ST platform devices,
> struct platform_device st_device_0 = {
>         .name = "ST_DEV_0",
>         .id = -1,
>         .dev.platform_data =
> &array,
>         .dev.release =
> any_device_release,
> };
> struct platform_device st_device_1 = {
>         .name = "ST_DEV_1",
>         .id = -1,
>         .dev.platform_data =
> &array,
>         .dev.release =
> any_device_release,
> };
> 
> BT attaching itself to ST_DEV_0,
> static struct protocol_platform_data bt_data = {
>         .parent_dev =
> &st_device_0,
>         .name = "BT",
> };
> 
> static struct platform_device bt_device = {
>         .name = "BT",
>         .id = -1,
>         .dev.platform_data =
> &bt_data,
>         .dev.release =
> bt_device_release,
> };
> 
> And FM attaching itself to - ST_DEV_1,
> static struct protocol_platform_data fm_data = {
>         .parent_dev =
> &st_device_1,
>         .name = "FM",
> };
> static struct platform_device fm_device = {
>         .name = "FM",
>         .id = -1,
>         .dev.platform_data =
> &fm_data,
>         .dev.release =
> fm_device_release,
> };
> 
> My "ST_REGISTER" would now look like,
> int st_register(struct protocol_platform_data *data)
> {
>         struct st_data_s *st_data;
>         struct platform_device *parent
> = data->parent_dev;
> 
>         st_data =
> dev_get_drvdata(&parent->dev);
> 
>         printk("%s registering into
> %s\n", data->name, parent->name);
> 
>         printk("data got is %s\n",
> st_data->name);
>         st_data->name = "Changed
> Name";
>         return 0;
> }
> EXPORT_SYMBOL(st_register);
> 
> 
> However, I would need to have a ST platform driver for each
> of my such ST platform devices (ST_DEV_0, ST_DEV_1).
> 
> It does seem a big-re-write of the probing/registration
> logic..
> So, How does this sound?
> 
> Please suggest.

Just to add, I would have 1 more problem to address, How can I link up my tty->disc_data with my platform-data ?
On registering ldisc_ops I would have liked to have an _private data sent in during tty_open/close/ioctl calls - which currently ldisc_ops doesn't support.

> 
> > Yes, and this is the reason, I posted this patch.
> > BT and GPS had to communicate over a single UART, and
> this is the reason the N_TI_WL line discipline exists.
> > With this sort of architecture, how can I accommodate
> multi-device support? To avoid this single device
> > limits?
> > 
> > Also, what is that you are exactly looking for
> regarding locking.
> > Please suggest.
> > 
> > Thanks.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe
> linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


