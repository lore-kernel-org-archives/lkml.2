Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755672Ab0KZT14 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 14:27:56 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:32988 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754669Ab0KZT1y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 14:27:54 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: sedat.dilek@gmail.com
Subject: Re: [PATCH 0/13] ACPI / PM: Rework power resources management
Date: Fri, 26 Nov 2010 20:26:54 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc3+; KDE/4.4.4; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Matthew Garrett <mjg59@srcf.ucam.org>,
        Len Brown <lenb@kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
References: <AANLkTimahUpEL3cV6pFhkN8KqrphfVMSOw8xAN2=9jPy@mail.gmail.com> <201011252145.19814.rjw@sisk.pl> <AANLkTimcn_3DamzfWaCk6YEfSCvC78ZJGkw-f+01pj2=@mail.gmail.com>
In-Reply-To: <AANLkTimcn_3DamzfWaCk6YEfSCvC78ZJGkw-f+01pj2=@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201011262026.55052.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, November 26, 2010, Sedat Dilek wrote:
> On Thu, Nov 25, 2010 at 9:45 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > On Thursday, November 25, 2010, Sedat Dilek wrote:
> >> On Thu, Nov 25, 2010 at 9:29 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> >> > On Thursday, November 25, 2010, Rafael J. Wysocki wrote:
> >> >> On Thursday, November 25, 2010, Sedat Dilek wrote:
> >> >> > On Thu, Nov 25, 2010 at 10:41 AM, Sedat Dilek
> >> >> > <sedat.dilek@googlemail.com> wrote:
> >> >> > > On Thu, Nov 25, 2010 at 10:11 AM, Sedat Dilek
> >> >> > > <sedat.dilek@googlemail.com> wrote:
> >> >> > >> Hi Rafael,
> >> >> > >>
> >> >> > [ ... ]
> >> >> > >> # grep "error:" build_linux-next_next20101124.dileks.2.log
> >> >> > >> /home/sd/src/linux-2.6/linux-2.6.37-rc3/debian/build/source_i386_none/drivers/platform/x86/fujitsu-laptop.c:692:
> >> >> > >> error: implicit declaration of function ‘acpi_bus_get_power’
> >> >> > [ ... ]
> >> >> > >
> >> >> > > Guess this is conflicting with your patch
> >> >> > > "12-13-ACPI-PM-Drop-acpi_bus_get_power.patch".
> >> >> > >
> >> >> > > - Sedat -
> >> >> > >
> >> >> > > P.S.: Note to myself, add the following snippet for testing purposes:
> >> >> > >
> >> >> > > [ debian/config/i386/none/config.686 ]
> >> >> > > ...
> >> >> > > ##
> >> >> > > ## file: drivers/platform/x86/Kconfig
> >> >> > > ##
> >> >> > > # CONFIG_FUJITSU_LAPTOP is not set
> >> >> > > - EOT -
> >> >> > >
> >> >> >
> >> >> > Applied on top of linux-next (next-20101125) and running.
> >> >> >
> >> >> >      Tested-by: Sedat Dilek <sedat.dilek@gmail.com>
> >> >>
> >> >> Great, thanks a lot!
> >> >>
> >> >> I should have said the patchset is on top of the current Linus' tree.
> >> >
> >> > Actually it also breaks with the current Linus' tree, but the appended patch
> >> > should fix it.
> >> >
> >> > Thanks,
> >> > Rafael
> >> >
> >> > ---
> >> > From: Rafael J. Wysocki <rjw@sisk.pl>
> >> > Subject: Platform / x86: Make fujitsu_laptop use acpi_bus_update_power()
> >> >
> >> > Use the new function acpi_bus_update_power(), which is safer than
> >> > acpi_bus_get_power(), for getting device power state in
> >> > acpi_fujitsu_add().
> >> >
> >> > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> >> > ---
> >> >  drivers/platform/x86/fujitsu-laptop.c |    2 +-
> >> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >> >
> >> > Index: linux-2.6/drivers/platform/x86/fujitsu-laptop.c
> >> > ===================================================================
> >> > --- linux-2.6.orig/drivers/platform/x86/fujitsu-laptop.c
> >> > +++ linux-2.6/drivers/platform/x86/fujitsu-laptop.c
> >> > @@ -689,7 +689,7 @@ static int acpi_fujitsu_add(struct acpi_
> >> >        if (error)
> >> >                goto err_free_input_dev;
> >> >
> >> > -       result = acpi_bus_get_power(fujitsu->acpi_handle, &state);
> >> > +       result = acpi_bus_update_power(fujitsu->acpi_handle, &state);
> >> >        if (result) {
> >> >                printk(KERN_ERR "Error reading power state\n");
> >> >                goto err_unregister_input_dev;
> >> >
> >>
> >> Sorry, I crapped my own quotes.
> >> Missed to catch line #860?
> >
> > Indeed, sorry.  Updated patch is appended.
> >
> > Rafael
> >
> >
> > ---
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> > Subject: Platform / x86: Make fujitsu_laptop use acpi_bus_update_power()
> >
> > Use the new function acpi_bus_update_power(), which is safer than
> > acpi_bus_get_power(), for getting device power state in
> > acpi_fujitsu_add().
> >
> > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> > ---
> >  drivers/platform/x86/fujitsu-laptop.c |    4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > Index: linux-2.6/drivers/platform/x86/fujitsu-laptop.c
> > ===================================================================
> > --- linux-2.6.orig/drivers/platform/x86/fujitsu-laptop.c
> > +++ linux-2.6/drivers/platform/x86/fujitsu-laptop.c
> > @@ -689,7 +689,7 @@ static int acpi_fujitsu_add(struct acpi_
> >        if (error)
> >                goto err_free_input_dev;
> >
> > -       result = acpi_bus_get_power(fujitsu->acpi_handle, &state);
> > +       result = acpi_bus_update_power(fujitsu->acpi_handle, &state);
> >        if (result) {
> >                printk(KERN_ERR "Error reading power state\n");
> >                goto err_unregister_input_dev;
> > @@ -857,7 +857,7 @@ static int acpi_fujitsu_hotkey_add(struc
> >        if (error)
> >                goto err_free_input_dev;
> >
> > -       result = acpi_bus_get_power(fujitsu_hotkey->acpi_handle, &state);
> > +       result = acpi_bus_update_power(fujitsu_hotkey->acpi_handle, &state);
> >        if (result) {
> >                printk(KERN_ERR "Error reading power state\n");
> >                goto err_unregister_input_dev;
> >
> 
> Feel free to add for
> "Platform-x86-Make-fujitsu_laptop-use-acpi_bus_update_power.patch":
> 
>      Reported-and-Tested-by: Sedat Dilek <sedat.dilek@gmail.com>

Thanks for testing!

Rafael
