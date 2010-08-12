Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933624Ab0HLNLm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 09:11:42 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46204 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751879Ab0HLNLk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 09:11:40 -0400
Date: Thu, 12 Aug 2010 15:11:39 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Alan Ott <alan@signal11.us>
Cc: Markus Trippelsdorf <markus@trippelsdorf.de>, Heinz Diehl <htd@fritha.org>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-input@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [BUG] object: is not initialized, yet kobject_put() is being  
 called
In-Reply-To: <4C63F285.8070801@signal11.us>
Message-ID: <alpine.LNX.2.00.1008121510180.2702@pobox.suse.cz>
References: <20100810210941.GA7938@fritha.org> <20100810223215.GA1609@arch.tripp.de> <alpine.LNX.2.00.1008121108540.2702@pobox.suse.cz> <20100812091659.GA1591@arch.tripp.de> <alpine.LNX.2.00.1008121148100.2702@pobox.suse.cz> <20100812113624.GB1591@arch.tripp.de>
 <20100812114513.GA1584@arch.tripp.de> <20100812115657.GA1611@arch.tripp.de> <alpine.LNX.2.00.1008121401580.2702@pobox.suse.cz> <alpine.LNX.2.00.1008121457060.2702@pobox.suse.cz> <20100812130411.GA1626@arch.tripp.de> <4C63F285.8070801@signal11.us>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Aug 2010, Alan Ott wrote:

> > > > > commit bd25f4dd6972755579d0ea50d1a5ace2e9b00d1a
> > > > > Author: Arnd Bergmann<arnd@arndb.de>
> > > > > Date:   Sun Jul 11 15:34:05 2010 +0200
> > > > > 
> > > > >      HID: hiddev: use usb_find_interface, get rid of BKL
> > > > > 
> > > > >      This removes the private hiddev_table in the usbhid
> > > > >      driver and changes it to use usb_find_interface
> > > > >      instead.
> > > > > 
> > > > >      The advantage is that we can avoid the race between
> > > > >      usb_register_dev and usb_open and no longer need the
> > > > >      big kernel lock.
> > > > > 
> > > > >      This doesn't introduce race condition -- the intf pointer could
> > > > > be
> > > > >      invalidated only in hiddev_disconnect() through
> > > > > usb_deregister_dev(),
> > > > >      but that will block on minor_rwsem and not actually remove the
> > > > > device
> > > > >      until usb_open().
> > > > > 
> > > > >      Signed-off-by: Arnd Bergmann<arnd@arndb.de>
> > > > >      Cc: Jiri Kosina<jkosina@suse.cz>
> > > > >      Cc: "Greg Kroah-Hartman"<gregkh@suse.de>
> > > > >      Signed-off-by: Jiri Kosina<jkosina@suse.cz>
> > > > >          
> > > > Thanks, I had my suspicion about this commit (that's why I asked to you
> > > > verify with CONFIG_USB_HIDDEV turned off as well).
> > > > 
> > > > Adding Arnd to CC and will look into it myself as well soon.
> > > > 
> > > > Arnd, the complete thread can be found at
> > > > http://lkml.org/lkml/2010/8/10/280
> > > >        
> > > Could please those of you, who are able to reproduce the problem, verify
> > > whether the patch below (completely untested) makes everything behave
> > > again? Thanks.
> > >      
> > Yes, everything behaves again. Thanks Jiri.
> >    
> 
> Seconded. Works good. Thanks for your support Jiri.

Thanks for your testing. I still need to think a little bit more about 
whether this is indeed an appropriate fix or there might be still some 
problem.

Once I will be applying this, I will put

	Reported-and-tested-by: 

tag for both of you Alan and Markus, is that fine?

Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
