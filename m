Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753922Ab0HaELJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 00:11:09 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45067 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750913Ab0HaELH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 00:11:07 -0400
Date: Mon, 30 Aug 2010 21:11:14 -0700
From: Greg KH <gregkh@suse.de>
To: "Savoy, Pavan" <pavan_savoy@ti.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>
Subject: Re: [PATCH] drivers:staging:ti-st: remove st_get_plat_device
Message-ID: <20100831041114.GA16009@suse.de>
References: <1282241331-5178-1-git-send-email-pavan_savoy@ti.com> <4C6D6A9A.3010409@oracle.com> <19F8576C6E063C45BE387C64729E7394044F124F7B@dbde02.ent.ti.com> <4C6D6BCB.2090307@oracle.com> <AANLkTi==HVhXcS0Mxv4GJL1rB0nLc3YQ=b5RbzM0iFwG@mail.gmail.com> <20100822033248.GA4886@suse.de> <19F8576C6E063C45BE387C64729E7394046836CB57@dbde02.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19F8576C6E063C45BE387C64729E7394046836CB57@dbde02.ent.ti.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 31, 2010 at 03:39:00AM +0530, Savoy, Pavan wrote:
> Greg,
> 
> 
> 
> > -----Original Message-----
> > From: Greg KH [mailto:gregkh@suse.de]
> > Sent: Saturday, August 21, 2010 10:33 PM
> > To: Savoy, Pavan
> > Cc: Randy Dunlap; alan@lxorguk.ukuu.org.uk; linux-kernel@vger.kernel.org;
> > devel@driverdev.osuosl.org; Jain, Naveen
> > Subject: Re: [PATCH] drivers:staging:ti-st: remove st_get_plat_device
> > 
> > On Sun, Aug 22, 2010 at 07:20:00AM +0530, Pavan Savoy wrote:
> > > Greg,
> > >
> > > On Thu, Aug 19, 2010 at 11:07 PM, Randy Dunlap <randy.dunlap@oracle.com>
> > wrote:
> > > > On 08/19/10 10:35, Savoy, Pavan wrote:
> > > >> Randy,
> > > >>
> > > >>
> > > >>> -----Original Message-----
> > > >>> From: Randy Dunlap [mailto:randy.dunlap@oracle.com]
> > > >>> Sent: Thursday, August 19, 2010 12:32 PM
> > > >>> To: Savoy, Pavan
> > > >>> Cc: gregkh@suse.de; alan@lxorguk.ukuu.org.uk; linux-
> > kernel@vger.kernel.org;
> > > >>> devel@driverdev.osuosl.org; Jain, Naveen
> > > >>> Subject: Re: [PATCH] drivers:staging:ti-st: remove st_get_plat_device
> > > >>>
> > > >>> On 08/19/10 11:08, pavan_savoy@ti.com wrote:
> > > >>>> From: Pavan Savoy <pavan_savoy@ti.com>
> > > >>>>
> > > >>>> In order to support multiple ST platform devices, a new symbol
> > > >>>> 'st_get_plat_device' earlier needed to be exported by the arch/XX/brd-
> > XX.c
> > > >>>> file which intends to add the ST platform device.
> > > >>>>
> > > >>>> On removing this dependency, now inside ST driver maintain the array of
> > > >>>> ST platform devices that would be registered.
> > > >>>> As of now let id=0, as and when we end up having such platforms
> > > >>>> where mutliple ST devices can exist, id would come from
> > > >>>> protocol drivers (BT, FM and GPS) as to on which platform device
> > > >>>> they want to register to.
> > > >>>>
> > > >>>> Signed-off-by: Pavan Savoy <pavan_savoy@ti.com>
> > > >>>
> > > >>> Thanks, that builds cleanly. ??I'm OK with it if you are comfortable
> > with a
> > > >>> hard limit on the fixed number of devices that can be supported:
> > > >>
> > > >> Yep, Thanks for pointing out, sort of cleaned up the code.
> > > >>
> > > >>> +#define MAX_ST_DEVICES ?? ?? ??3 ?? ?? ?? /* Imagine 1 on each UART for
> > now */
> > > >>> +struct platform_device *st_kim_devices[MAX_ST_DEVICES];
> > > >>>
> > > >>> We usually try not to have such limits nor use arrays like that,
> > > >>> but if the nature of the device and its platform/environment is like
> > > >>> that, so be it.
> > > >>>
> > > >>
> > > >> Actually on all platforms that I have seen there's only 1 such device.
> > > >> The device is basically a connectivity chip (with Bluetooth, FM and GPS
> > working
> > > >> on a single UART)
> > > >>
> > > >> The number which I mentioned was out of imagination.
> > > >> I don't think we are ever going to have multiple of them either...
> > > >
> > > > OK, thanks.
> > > >
> > > > Acked-by: Randy Dunlap <randy.dunlap@oracle.com>
> > >
> > >
> > > Can you please merge this patch ? Also please have a look at the driver and
> > > suggest what needs to be done to move it out of staging.
> > 
> > Yes, I will work on it, sorry, been swamped with other work lately.
> > 
> > Don't worry, this patch is in my "to-apply" queue.
> 
> Any update on this?

Nope, sorry.  I got sick and combined with vacation requirements from
the family, and my "real job" and other things lately, I hope to get to
it by the end of this week.  If not, kick me, I'll have time on a
trans-continent flight next week that should give me plenty of time to
do this...

thanks,

greg k-h
