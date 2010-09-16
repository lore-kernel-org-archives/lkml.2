Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756263Ab0IPU7m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 16:59:42 -0400
Received: from kroah.org ([198.145.64.141]:55979 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756205Ab0IPU7l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 16:59:41 -0400
Date: Thu, 16 Sep 2010 13:59:29 -0700
From: Greg KH <greg@kroah.com>
To: "Savoy, Pavan" <pavan_savoy@ti.com>
Cc: "gregkh@suse.de" <gregkh@suse.de>,
        "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC 3/3] include:linux: make ti_wilink_st like the rest
Message-ID: <20100916205929.GA12515@kroah.com>
References: <1284148738-21643-1-git-send-email-pavan_savoy@ti.com>
 <1284148738-21643-2-git-send-email-pavan_savoy@ti.com>
 <1284148738-21643-3-git-send-email-pavan_savoy@ti.com>
 <1284148738-21643-4-git-send-email-pavan_savoy@ti.com>
 <1284148738-21643-5-git-send-email-pavan_savoy@ti.com>
 <20100916200058.GI10397@kroah.com>
 <19F8576C6E063C45BE387C64729E73940468914048@dbde02.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19F8576C6E063C45BE387C64729E73940468914048@dbde02.ent.ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 17, 2010 at 01:48:53AM +0530, Savoy, Pavan wrote:
> > Also, why not just use 'u8' and friends instead?  That's the "proper"
> > kernel types to be using, not the uint8_t mess that is not correct
> > kernel types.
> 
> Yes a mistake here too.
> This should have been in the patch where I plan to combine all the headers into 1 header and have it in include/linux/
> [the headers like st_core.h, st_kim.h, st_ll.h, bt_drv.h and fm and GPs headers]
> 
> Yes, and the Bluetooth driver to go into drivers/Bluetooth/ and ST
> driver (st_core.c/st_kim.c and st_ll.c) to go into drivers/char/ And
> the upcoming FM V4L2 to go into the drivers/media/radio/
> 
> Does this sound fine?

Yes.

> > > @@ -386,6 +392,7 @@ void st_ll_wakeup(struct st_data_s *);
> > >
> > >  /**
> > >   * structures and declarations used by the st_core for FM packets
> > > + * and GPS packets
> > >   */
> > >  struct fm_event_hdr {
> > >  	unsigned char plen;
> > 
> > Oh, is it?  That should go somewhere else.
> 
> Plan is to have just 1 large header to be included by all protocol drivers (BT, FM and GPS)...
> Is it a bad idea?

No, as long as all drivers need it.

> > >  #endif /* ST_H */
> > 
> > I don't think this file is called "ST_H" here anymore.
> 
> Yes, need your input here. This file will be made use by the rest of
> the protocol drivers I plan to push patches for.
> So does ti_wilink_st.h sound fine? And in include/linux? So that rest
> of the drivers can be in their individual directories.

Yes, that name is fine, but it needs to be the same as the #ifdef
guard as well.

thanks,

greg k-h
