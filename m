Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752073Ab0KCVh2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 17:37:28 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:39478 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751558Ab0KCVh0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 17:37:26 -0400
From: "Arce, Abraham" <x0066660@ti.com>
To: Greg KH <greg@kroah.com>, Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Linus Walleij <linus.walleij@stericsson.com>,
        Naveen Kumar GADDIPATI <naveen.gaddipati@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        STEricsson_nomadik_linux <STEricsson_nomadik_linux@list.st.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>
Date: Wed, 3 Nov 2010 16:37:14 -0500
Subject: RE: [PATCHv1] staging: Synaptics RMI4 touchpad driver support
Thread-Topic: [PATCHv1] staging: Synaptics RMI4 touchpad driver support
Thread-Index: Act7jIPRAEQHCY5NSnuvbzsiadSGKgADqlZg
Message-ID: <27F9C60D11D683428E133F85D2BB4A530468A82B1A@dlee03.ent.ti.com>
References: <1288699725-14405-1-git-send-email-naveen.gaddipati@stericsson.com>
 <20101102140337.GC9387@kroah.com> <4CD01CD8.3090206@stericsson.com>
 <20101102154029.GH11778@core.coreip.homeip.net>
 <20101103181058.GE7441@kroah.com>
 <20101103190752.GA4552@core.coreip.homeip.net>
 <20101103191958.GA9912@kroah.com>
In-Reply-To: <20101103191958.GA9912@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Naveen,

> From: linux-input-owner@vger.kernel.org [mailto:linux-input-
> owner@vger.kernel.org] On Behalf Of Greg KH
> Sent: Wednesday, November 03, 2010 1:20 PM
> To: Dmitry Torokhov
> Cc: Linus Walleij; Naveen Kumar GADDIPATI; linux-kernel@vger.kernel.org;
> STEricsson_nomadik_linux; linux-input@vger.kernel.org
> Subject: Re: [PATCHv1] staging: Synaptics RMI4 touchpad driver support
> 
> On Wed, Nov 03, 2010 at 12:07:52PM -0700, Dmitry Torokhov wrote:
> > On Wed, Nov 03, 2010 at 11:10:58AM -0700, Greg KH wrote:
> > > On Tue, Nov 02, 2010 at 08:40:30AM -0700, Dmitry Torokhov wrote:
> > > > On Tue, Nov 02, 2010 at 03:14:48PM +0100, Linus Walleij wrote:
> > > > > Greg KH wrote:
> > > > >
> > > > > >> +Wait for the official upstream synaptics rmi4 clearpad drivers as
> promised over the past few months
> > > > > >> +Merge any device support needed from this driver into it
> > > > > >> +Delete this driver
> > > > > >
> > > > > > Huh?
> > > > > >
> > > > > > Why not just add this driver to the kernel tree instead?  When the
> > > > > > "promised" driver then eventually shows up (who is promising it?)
> then
> > > > > > delete the thing.
> > > >
> > > > The same reason as there were several wireless drivers in staging?
> > >
> > > Ok, that's a good enough reason for me :)
> > >
> > > > > Well, Alan (on behalf of Ramesh Agarwal) sent out a very similar
> > > > > patch (Titled "Synaptics TM1217 Touchscreen Controller driver")
> > > > > the other day, and OTOMH that was after discussions with Synaptics
> > > > > where they said they were working on a "real" driver (a rather
> > > > > complex RMI4 bus driver) and we believe they will fix that sooner
> > > > > or later.
> > > > >
> > > > > So, until sooner or later happens we thought we'd keep it in staging.
> > > > >
> > > > > If you prefer both Alan and we can probably submit our patches for
> > > > > inclusion in the proper place.
> > > > >
> > > > > A side effect may be that the Synaptics RMI4 people may have trouble
> > > > > to merge their driver into input/ since they may be requested to
> > > > > refactor the existing drivers to use it rather than merging new stuff,
> > > > > putting some burden on their shoulders.
> > > > >
> > > >
> > > > No, they have not been requested to change any existing [in tree]
> > > > drivers. They however been asked to convert to the driver core
> > > > primitives instead of rolling their own infprastructure to implement
> > > > devices and drivers binding.
> > >
> > > If you don't object to this driver going in, and there is a path forward
> > > in the future for it to be able to be removed, then I will be glad to
> > > add it.
> > >
> > > Can I add your Acked-by: to the patch for this?
> > >
> >
> > Umm... I haven't looked in detail, but I think it is sane enough for
> > staging... Much better than Alan's version that seemed to create a
> > separate input device for every finger. Needs to depend on INPUT and
> > probably regulators framework...  Probe function may call
> > input_free_device() after calling input_register_device() which is not
> > good.
> 
> Great, thanks for this.
> 
> > Basically staging is yours, you can add whatever you want to it ;)
> 
> Heh, well, I try to at least cooperate with the different subsystem
> maintainers.  I don't need even more people pissed-off at me than I
> normally get :)
> 
> I'll queue this up for .38.
> 

I have done some initial testing with this patch, it includes some modifications to the board file, I have a gpio acting as irq plus driver code itself

I won't be able to get events (board will hang) unless adding the following code, is this due to the usage of a gpio as interrupt? If you could please clarify...

@@ -481,6 +483,9 @@ static int synaptics_rmi4_sensor_report(struct synaptics_rmi4_data *pdata)
                                                                        rfi);
                }
        }
+
+       enable_irq(gpio_to_irq(pdata->irq_number));
+
        /* return the number of touch points */
        return touch;
 }
@@ -498,6 +503,8 @@ static irqreturn_t synaptics_rmi4_irq(int irq, void *data)
        struct synaptics_rmi4_data *pdata = data;
        int touch_count;
        do {
+               disable_irq_nosync(gpio_to_irq(pdata->irq_number));
+
                touch_count = synaptics_rmi4_sensor_report(pdata);
                if (touch_count)
                        wait_event_timeout(pdata->wait, pdata->touch_stopped,

Best Regards
Abraham

