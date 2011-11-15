Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757040Ab1KOSHN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 13:07:13 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:45651 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756827Ab1KOSHL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 13:07:11 -0500
X-Sasl-enc: vda+NZVmUw201xsPYTGygfXrGJdRJm8mpPq12zyhmdWw 1321380430
Date: Tue, 15 Nov 2011 09:54:29 -0800
From: Greg KH <greg@kroah.com>
To: wangyanqing <Udknight@gmail.com>, Greg KH <gregkh@suse.de>, wd@denx.de,
        stable@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH]usb: serial: pl2303: rm id
Message-ID: <20111115175429.GA28924@kroah.com>
References: <20111110060408.GA25028@udknight.homenetwork>
 <20111114011130.GA4433@udknight.homenetwork>
 <20111114035815.GA17996@suse.de>
 <20111115050426.GA3738@udknight.homenetwork>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111115050426.GA3738@udknight.homenetwork>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 15, 2011 at 01:04:26PM +0800, wangyanqing wrote:
> On Sun, Nov 13, 2011 at 07:58:15PM -0800, Greg KH wrote:
> > On Mon, Nov 14, 2011 at 09:11:30AM +0800, wangyanqing wrote:
> > > On Thu, Nov 10, 2011 at 02:04:08PM +0800, wangyanqing wrote:
> > > > I get report from customer that his usb-serial
> > > > converter doesn't work well,it sometimes work,
> > > > but sometimes it doesn't.
> > > > 
> > > > The usb-serial converter's id:
> > > > vendor_id product_id
> > > > 0x4348    0x5523
> > > > 
> > > > Then I search the usb-serial codes, and there are
> > > > two drivers announce support this device, pl2303
> > > > and ch341, commit 026dfaf1 cause it. Through many
> > > > times to test, ch341 works well with this device,
> > > > and pl2303 doesn't work quite often(it just work quite little).
> > > > 
> > > > ch341 works well with this device, so we doesn't
> > > > need pl2303 to support.I try to revert 026dfaf1 first,
> > > > but it failed. So I prepare this patch by hand to revert it.
> > > > 
> > > > Signed-off-by: Wang YanQing <Udknight@gmail.com>
> > > > ---
> > > >  drivers/usb/serial/pl2303.c |    1 -
> > > >  drivers/usb/serial/pl2303.h |    4 ----
> > > >  2 files changed, 0 insertions(+), 5 deletions(-)
> > > > 
> > > > diff --git a/drivers/usb/serial/pl2303.c b/drivers/usb/serial/pl2303.c
> > > > index 9083d1e..fc2d66f 100644
> > > > --- a/drivers/usb/serial/pl2303.c
> > > > +++ b/drivers/usb/serial/pl2303.c
> > > > @@ -91,7 +91,6 @@ static const struct usb_device_id id_table[] = {
> > > >  	{ USB_DEVICE(SONY_VENDOR_ID, SONY_QN3USB_PRODUCT_ID) },
> > > >  	{ USB_DEVICE(SANWA_VENDOR_ID, SANWA_PRODUCT_ID) },
> > > >  	{ USB_DEVICE(ADLINK_VENDOR_ID, ADLINK_ND6530_PRODUCT_ID) },
> > > > -	{ USB_DEVICE(WINCHIPHEAD_VENDOR_ID, WINCHIPHEAD_USBSER_PRODUCT_ID) },
> > > >  	{ USB_DEVICE(SMART_VENDOR_ID, SMART_PRODUCT_ID) },
> > > >  	{ }					/* Terminating entry */
> > > >  };
> > > > diff --git a/drivers/usb/serial/pl2303.h b/drivers/usb/serial/pl2303.h
> > > > index 3d10d7f..c38b8c0 100644
> > > > --- a/drivers/usb/serial/pl2303.h
> > > > +++ b/drivers/usb/serial/pl2303.h
> > > > @@ -145,10 +145,6 @@
> > > >  #define ADLINK_VENDOR_ID		0x0b63
> > > >  #define ADLINK_ND6530_PRODUCT_ID	0x6530
> > > >  
> > > > -/* WinChipHead USB->RS 232 adapter */
> > > > -#define WINCHIPHEAD_VENDOR_ID		0x4348
> > > > -#define WINCHIPHEAD_USBSER_PRODUCT_ID	0x5523
> > > > -
> > > >  /* SMART USB Serial Adapter */
> > > >  #define SMART_VENDOR_ID	0x0b8c
> > > >  #define SMART_PRODUCT_ID	0x2303
> > > > -- 
> > > > 1.7.3.4
> > > > 
> > > Hi all.
> > > Maybe it should be noticed that not only one usb-serial converter base 
> > > this chip have this issue, but there are about 50(even more) usb-serial 
> > > coverter lines have the same issue, so we can't ignore it.
> > > Of course we can make all the drivers work well, but we should make it
> > > useful at the first.
> > 
> > Why not add the device id to the other driver at the same time, that
> > would ensure that the device continues to work, right?
> > 
> > thanks,
> > 
> > greg k-h
> 
> Ok greg, thanks for your reply!
> But I means maybe I make a very very "bad" subject in the email at all!
> There are ch341 and pl2303 , two drivers announce to support this device,
> ch341 works well and pl2303 does't work always.
> 
> Maybe I should make the email "shorter" next time.
> This is the origin email.
> https://lkml.org/lkml/2011/11/10/66
> 
> We don't need to add the device id to the other driver, ch341 have done it!!
> Please looks at ch341.c:76 line
> "
>        { USB_DEVICE(0x4348, 0x5523) }, "

Ah, sorry, I missed that, I'll go queue this patch up right now, sorry
for the confusion.

greg k-h


> 
> Thanks again.
>  
