Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751403Ab0HRWrW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 18:47:22 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:50939 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750977Ab0HRWrV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 18:47:21 -0400
From: "Savoy, Pavan" <pavan_savoy@ti.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>
Date: Thu, 19 Aug 2010 04:16:58 +0530
Subject: RE: [PATCH 0/3] drivers:staging:ti-st: patches
Thread-Topic: [PATCH 0/3] drivers:staging:ti-st: patches
Thread-Index: Acs/GU3krzJ/gHZiQ1mnNg+lo79ylQADZq6Q
Message-ID: <19F8576C6E063C45BE387C64729E7394044F124CB2@dbde02.ent.ti.com>
References: <1279794727-7669-1-git-send-email-pavan_savoy@ti.com>
	<20100722125348.e4cd696f.randy.dunlap@oracle.com>
	<AANLkTil64PBJ4FNNSftkXvy6ZjhoDc96rTH0csqAfU34@mail.gmail.com>
	<4C49B2A2.8080100@oracle.com>
	<AANLkTik7bzRMfko0sqgVuJh-dkb_LMz4dcnK2UvLiek=@mail.gmail.com>
 <20100818140440.7a838177.randy.dunlap@oracle.com>
In-Reply-To: <20100818140440.7a838177.randy.dunlap@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy,


> -----Original Message-----
> From: Randy Dunlap [mailto:randy.dunlap@oracle.com]
> Sent: Wednesday, August 18, 2010 4:05 PM
> To: Savoy, Pavan
> Cc: devel@driverdev.osuosl.org; gregkh@suse.de; linux-kernel@vger.kernel.org;
> alan@lxorguk.ukuu.org.uk
> Subject: Re: [PATCH 0/3] drivers:staging:ti-st: patches
> 
> On Mon, 26 Jul 2010 10:37:02 +0530 Pavan Savoy wrote:
> 
> > On Fri, Jul 23, 2010 at 8:47 PM, Randy Dunlap <randy.dunlap@oracle.com>
> wrote:
> > > On 07/22/10 21:56, Pavan Savoy wrote:
> > >> Randy,
> > >>
> > >> On Fri, Jul 23, 2010 at 1:23 AM, Randy Dunlap <randy.dunlap@oracle.com>
> wrote:
> > >>> On Thu, 22 Jul 2010 05:32:04 -0500 pavan_savoy@ti.com wrote:
> > >>>
> > >>>> From: Pavan Savoy <pavan_savoy@ti.com>
> > >>>>
> > >>>> The following patches cleanup bit of a mess and also adds functionality
> to protocol drivers.
> > >>>> with the 3rd patch now providing context to even the protocol drivers,
> the single device limit
> > >>>> or support for multiple devices would be easier to implement.
> > >>>>
> > >>>> These patches depend on the previously submitted
> > >>>> 0001-drivers-staging-ti-st-make-use-of-linux-err-codes.patch
> > >>>> commit d39d49b393d94f4137cee4f64526a4695352f183
> > >>>>
> > >>>> Pavan Savoy (3):
> > >>>>   drivers:staging:ti-st: smarten, reduce logs
> > >>>>   drivers:staging:ti-st: cleanup code comments
> > >>>>   drivers:staging:ti-st: give proto drivers context
> > >>>>
> > >>>>  drivers/staging/ti-st/bt_drv.c  |   23 +++++---
> > >>>>  drivers/staging/ti-st/st.h      |   52 +++++++++--------
> > >>>>  drivers/staging/ti-st/st_core.c |  118 +++++++++++++++++++------------
> --------
> > >>>>  drivers/staging/ti-st/st_core.h |   74 +++++++++++++++++--------
> > >>>>  drivers/staging/ti-st/st_kim.c  |   73 ++++++++++++++----------
> > >>>>  drivers/staging/ti-st/st_kim.h  |   77 ++++++++++++++++---------
> > >>>>  drivers/staging/ti-st/st_ll.c   |    4 +-
> > >>>>  drivers/staging/ti-st/st_ll.h   |    9 +++-
> > >>>>  8 files changed, 255 insertions(+), 175 deletions(-)
> > >>>
> > >>> Hi,
> > >>>
> > >>> I have reported this error a few times.  Where is the patch for it??
> > >>>
> > >>> ERROR: "st_get_plat_device" [drivers/staging/ti-st/st_drv.ko] undefined!
> > >>
> > >>
> > >> Yes, on one of the earlier patch sets, I had mentioned that the ST
> > >> driver being a platform device, needs definition in any of the
> > >> arch/XX/mach-XX/board-XX.c or devices.c or somewhere...
> > >>
> > >> and hence it is in that board-XX.c file that the symbol
> > >> st_get_plat_device needs to be exported, the reason for that being,
> > >>
> > >> ST driver being both a TTY ldisc driver and platform driver, in TTY
> > >> contexts it would need to refer to platform driver's data. So it does
> > >> a st_get_plat_device which returns the platform device structure, and
> > >> then does a dev_getdrvdata from it.
> > >>
> > >> here's a snippet of code ...
> > >> /*
> > >>  * ST related functions related functions
> > >>  */
> > >> #include <linux/platform_device.h>
> > >>
> > >> long gpios[] = { 55, -1, -1 };
> > >> static struct platform_device ti_st_device = {
> > >>         .name           = "kim",
> > >>         .id             = -1,
> > >>         .dev.platform_data      = &gpios,
> > >> };
> > >>
> > >> struct platform_device *st_get_plat_device(void)
> > >> {
> > >>         return &ti_st_device;
> > >> }
> > >> EXPORT_SYMBOL(st_get_plat_device);
> > >>
> > >> static __init int add_ti_st_device(void)
> > >> {
> > >>         platform_device_register(&ti_st_device);
> > >>         dev_info(&ti_st_device.dev,"registered platform TI ST device\n");
> > >>
> > >>         return 0;
> > >> }
> > >> device_initcall(add_ti_st_device);
> > >>
> > >>
> > >> We have that in our local trees in arch/arm/mach-omap2/board-sdp4430.c
> > >
> > > Thanks for the explanation.
> > >
> > > Is the driver platform-specific?
> > > E.g., should it not even be built on x86?
> >
> > Yes. Requirement of the hardware is very much a must.
> > However it is a separate peripheral (WiLink 7 - uart interfaced), may
> > be there is a x86 platform with this - but certainly not desktops.
> >
> > on linux-next, I generally put in that st_dev.c file for x86 - verify
> > whether it builds as a module, inserts/rmmod, basic other
> > functionalities (which doesn't involve response from chip..)
> > But verify full functionality on board which constitutes that.
> 
> Hi,
> Please make this driver build cleanly on X86 or prevent it from being built
> there.

Do you do something like a make allyesconfig?
I am having a hard time figuring out why is it building for you in the first place?
make defconfig doesn't build it, neither does make i386_defconfig.

May be a patch which does 'default N' in drivers/staging/ti-st/Kconfig, would suffice?
Please suggest...

> thanks,
> ---
> ~Randy
> *** Remember to use Documentation/SubmitChecklist when testing your code ***
