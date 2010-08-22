Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751923Ab0HVDdI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Aug 2010 23:33:08 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52134 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751821Ab0HVDdF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Aug 2010 23:33:05 -0400
Date: Sat, 21 Aug 2010 20:32:48 -0700
From: Greg KH <gregkh@suse.de>
To: Pavan Savoy <pavan_savoy@ti.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
        "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "Jain, Naveen" <naveen_jain@ti.com>
Subject: Re: [PATCH] drivers:staging:ti-st: remove st_get_plat_device
Message-ID: <20100822033248.GA4886@suse.de>
References: <1282241331-5178-1-git-send-email-pavan_savoy@ti.com> <4C6D6A9A.3010409@oracle.com> <19F8576C6E063C45BE387C64729E7394044F124F7B@dbde02.ent.ti.com> <4C6D6BCB.2090307@oracle.com> <AANLkTi==HVhXcS0Mxv4GJL1rB0nLc3YQ=b5RbzM0iFwG@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi==HVhXcS0Mxv4GJL1rB0nLc3YQ=b5RbzM0iFwG@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 22, 2010 at 07:20:00AM +0530, Pavan Savoy wrote:
> Greg,
> 
> On Thu, Aug 19, 2010 at 11:07 PM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> > On 08/19/10 10:35, Savoy, Pavan wrote:
> >> Randy,
> >>
> >>
> >>> -----Original Message-----
> >>> From: Randy Dunlap [mailto:randy.dunlap@oracle.com]
> >>> Sent: Thursday, August 19, 2010 12:32 PM
> >>> To: Savoy, Pavan
> >>> Cc: gregkh@suse.de; alan@lxorguk.ukuu.org.uk; linux-kernel@vger.kernel.org;
> >>> devel@driverdev.osuosl.org; Jain, Naveen
> >>> Subject: Re: [PATCH] drivers:staging:ti-st: remove st_get_plat_device
> >>>
> >>> On 08/19/10 11:08, pavan_savoy@ti.com wrote:
> >>>> From: Pavan Savoy <pavan_savoy@ti.com>
> >>>>
> >>>> In order to support multiple ST platform devices, a new symbol
> >>>> 'st_get_plat_device' earlier needed to be exported by the arch/XX/brd-XX.c
> >>>> file which intends to add the ST platform device.
> >>>>
> >>>> On removing this dependency, now inside ST driver maintain the array of
> >>>> ST platform devices that would be registered.
> >>>> As of now let id=0, as and when we end up having such platforms
> >>>> where mutliple ST devices can exist, id would come from
> >>>> protocol drivers (BT, FM and GPS) as to on which platform device
> >>>> they want to register to.
> >>>>
> >>>> Signed-off-by: Pavan Savoy <pavan_savoy@ti.com>
> >>>
> >>> Thanks, that builds cleanly. ??I'm OK with it if you are comfortable with a
> >>> hard limit on the fixed number of devices that can be supported:
> >>
> >> Yep, Thanks for pointing out, sort of cleaned up the code.
> >>
> >>> +#define MAX_ST_DEVICES ?? ?? ??3 ?? ?? ?? /* Imagine 1 on each UART for now */
> >>> +struct platform_device *st_kim_devices[MAX_ST_DEVICES];
> >>>
> >>> We usually try not to have such limits nor use arrays like that,
> >>> but if the nature of the device and its platform/environment is like
> >>> that, so be it.
> >>>
> >>
> >> Actually on all platforms that I have seen there's only 1 such device.
> >> The device is basically a connectivity chip (with Bluetooth, FM and GPS working
> >> on a single UART)
> >>
> >> The number which I mentioned was out of imagination.
> >> I don't think we are ever going to have multiple of them either...
> >
> > OK, thanks.
> >
> > Acked-by: Randy Dunlap <randy.dunlap@oracle.com>
> 
> 
> Can you please merge this patch ? Also please have a look at the driver and
> suggest what needs to be done to move it out of staging.

Yes, I will work on it, sorry, been swamped with other work lately.

Don't worry, this patch is in my "to-apply" queue.

thanks,

greg k-h
