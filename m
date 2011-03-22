Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755370Ab1CVQqe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 12:46:34 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51824 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753370Ab1CVQqc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 12:46:32 -0400
Date: Tue, 22 Mar 2011 09:44:54 -0700
From: Greg KH <gregkh@suse.de>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Tao Ma <tm@tao.ma>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb_wwan: fix build error in play_delayed.
Message-ID: <20110322164454.GB15916@suse.de>
References: <1300768162-18394-1-git-send-email-tm@tao.ma>
 <1300773955.2837.24.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1300773955.2837.24.camel@edumazet-laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 22, 2011 at 07:05:55AM +0100, Eric Dumazet wrote:
> Le mardi 22 mars 2011 à 12:29 +0800, Tao Ma a écrit :
> > From: Tao Ma <boyu.mt@taobao.com>
> > 
> > There is a build error in today's linus tree.
> > drivers/usb/serial/usb_wwan.c: In function ‘play_delayed’:
> > drivers/usb/serial/usb_wwan.c:702: error: ‘struct dev_pm_info’ has no member named ‘usage_count’
> > The reason is that usage_count is wrapped with macro CONFIG_PM_RUNTIME
> > now in dev_pm_info.
> > 
> > So use the corresponding pm_runtime_get_noresume instead.
> > 
> > Cc: Greg Kroah-Hartman <gregkh@suse.de>
> > Signed-off-by: Tao Ma <boyu.mt@taobao.com>
> > ---
> >  drivers/usb/serial/usb_wwan.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/usb/serial/usb_wwan.c b/drivers/usb/serial/usb_wwan.c
> > index a65ddd5..5858ce4 100644
> > --- a/drivers/usb/serial/usb_wwan.c
> > +++ b/drivers/usb/serial/usb_wwan.c
> > @@ -699,7 +699,7 @@ static void play_delayed(struct usb_serial_port *port)
> >  			do {
> >  				unbusy_queued_urb(urb, portdata);
> >  				//extremely dirty
> > -				atomic_dec(&port->serial->interface->dev.power.usage_count);
> > +				pm_runtime_get_noresume(&port->serial->interface->dev);
> >  			} while ((urb = usb_get_from_anchor(&portdata->delayed)));
> >  			break;
> >  		}
> 
> Oh well, thats the third time this patch is sent

Yes, sorry, been busy with other stuff, this will get fixed soon, I have
enough copies of it in my queue :)

thanks,

greg k-h
