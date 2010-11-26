Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754134Ab0KZIMQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 03:12:16 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:43742 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753389Ab0KZIMM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 03:12:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=YsysFIn13VmmnJZRlbLWideniQ4v3paWShHFs8Cj2JMcOCY1DaX/e0Fd4rJsfhwqdX
         tm5hvigdACPY1gdwtiu2kDHsdmrk//Xh+TQ8gjBnxpgxzeuCwK8CY9bWm9dBVv7RGfeX
         +PfYmklb5xF5Rx1rd9lTyyOVLYEds9RO544as=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <201011252145.19814.rjw@sisk.pl>
References: <AANLkTimahUpEL3cV6pFhkN8KqrphfVMSOw8xAN2=9jPy@mail.gmail.com>
	<201011252129.02027.rjw@sisk.pl>
	<AANLkTi=QH=SNyfZEaak6pYyCJchSwDp6sdn-yOSz2MRQ@mail.gmail.com>
	<201011252145.19814.rjw@sisk.pl>
Date: Fri, 26 Nov 2010 09:12:11 +0100
Message-ID: <AANLkTimcn_3DamzfWaCk6YEfSCvC78ZJGkw-f+01pj2=@mail.gmail.com>
Subject: Re: [PATCH 0/13] ACPI / PM: Rework power resources management
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>, Matthew Garrett <mjg59@srcf.ucam.org>,
        Len Brown <lenb@kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 25, 2010 at 9:45 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Thursday, November 25, 2010, Sedat Dilek wrote:
>> On Thu, Nov 25, 2010 at 9:29 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> > On Thursday, November 25, 2010, Rafael J. Wysocki wrote:
>> >> On Thursday, November 25, 2010, Sedat Dilek wrote:
>> >> > On Thu, Nov 25, 2010 at 10:41 AM, Sedat Dilek
>> >> > <sedat.dilek@googlemail.com> wrote:
>> >> > > On Thu, Nov 25, 2010 at 10:11 AM, Sedat Dilek
>> >> > > <sedat.dilek@googlemail.com> wrote:
>> >> > >> Hi Rafael,
>> >> > >>
>> >> > [ ... ]
>> >> > >> # grep "error:" build_linux-next_next20101124.dileks.2.log
>> >> > >> /home/sd/src/linux-2.6/linux-2.6.37-rc3/debian/build/source_i386_none/drivers/platform/x86/fujitsu-laptop.c:692:
>> >> > >> error: implicit declaration of function ‘acpi_bus_get_power’
>> >> > [ ... ]
>> >> > >
>> >> > > Guess this is conflicting with your patch
>> >> > > "12-13-ACPI-PM-Drop-acpi_bus_get_power.patch".
>> >> > >
>> >> > > - Sedat -
>> >> > >
>> >> > > P.S.: Note to myself, add the following snippet for testing purposes:
>> >> > >
>> >> > > [ debian/config/i386/none/config.686 ]
>> >> > > ...
>> >> > > ##
>> >> > > ## file: drivers/platform/x86/Kconfig
>> >> > > ##
>> >> > > # CONFIG_FUJITSU_LAPTOP is not set
>> >> > > - EOT -
>> >> > >
>> >> >
>> >> > Applied on top of linux-next (next-20101125) and running.
>> >> >
>> >> >      Tested-by: Sedat Dilek <sedat.dilek@gmail.com>
>> >>
>> >> Great, thanks a lot!
>> >>
>> >> I should have said the patchset is on top of the current Linus' tree.
>> >
>> > Actually it also breaks with the current Linus' tree, but the appended patch
>> > should fix it.
>> >
>> > Thanks,
>> > Rafael
>> >
>> > ---
>> > From: Rafael J. Wysocki <rjw@sisk.pl>
>> > Subject: Platform / x86: Make fujitsu_laptop use acpi_bus_update_power()
>> >
>> > Use the new function acpi_bus_update_power(), which is safer than
>> > acpi_bus_get_power(), for getting device power state in
>> > acpi_fujitsu_add().
>> >
>> > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
>> > ---
>> >  drivers/platform/x86/fujitsu-laptop.c |    2 +-
>> >  1 file changed, 1 insertion(+), 1 deletion(-)
>> >
>> > Index: linux-2.6/drivers/platform/x86/fujitsu-laptop.c
>> > ===================================================================
>> > --- linux-2.6.orig/drivers/platform/x86/fujitsu-laptop.c
>> > +++ linux-2.6/drivers/platform/x86/fujitsu-laptop.c
>> > @@ -689,7 +689,7 @@ static int acpi_fujitsu_add(struct acpi_
>> >        if (error)
>> >                goto err_free_input_dev;
>> >
>> > -       result = acpi_bus_get_power(fujitsu->acpi_handle, &state);
>> > +       result = acpi_bus_update_power(fujitsu->acpi_handle, &state);
>> >        if (result) {
>> >                printk(KERN_ERR "Error reading power state\n");
>> >                goto err_unregister_input_dev;
>> >
>>
>> Sorry, I crapped my own quotes.
>> Missed to catch line #860?
>
> Indeed, sorry.  Updated patch is appended.
>
> Rafael
>
>
> ---
> From: Rafael J. Wysocki <rjw@sisk.pl>
> Subject: Platform / x86: Make fujitsu_laptop use acpi_bus_update_power()
>
> Use the new function acpi_bus_update_power(), which is safer than
> acpi_bus_get_power(), for getting device power state in
> acpi_fujitsu_add().
>
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> ---
>  drivers/platform/x86/fujitsu-laptop.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> Index: linux-2.6/drivers/platform/x86/fujitsu-laptop.c
> ===================================================================
> --- linux-2.6.orig/drivers/platform/x86/fujitsu-laptop.c
> +++ linux-2.6/drivers/platform/x86/fujitsu-laptop.c
> @@ -689,7 +689,7 @@ static int acpi_fujitsu_add(struct acpi_
>        if (error)
>                goto err_free_input_dev;
>
> -       result = acpi_bus_get_power(fujitsu->acpi_handle, &state);
> +       result = acpi_bus_update_power(fujitsu->acpi_handle, &state);
>        if (result) {
>                printk(KERN_ERR "Error reading power state\n");
>                goto err_unregister_input_dev;
> @@ -857,7 +857,7 @@ static int acpi_fujitsu_hotkey_add(struc
>        if (error)
>                goto err_free_input_dev;
>
> -       result = acpi_bus_get_power(fujitsu_hotkey->acpi_handle, &state);
> +       result = acpi_bus_update_power(fujitsu_hotkey->acpi_handle, &state);
>        if (result) {
>                printk(KERN_ERR "Error reading power state\n");
>                goto err_unregister_input_dev;
>

Feel free to add for
"Platform-x86-Make-fujitsu_laptop-use-acpi_bus_update_power.patch":

     Reported-and-Tested-by: Sedat Dilek <sedat.dilek@gmail.com>

- Sedat -

# grep OK setup_linux-next_next20101126.dileks.1.log | grep ACPI-PM
  (+) OK   ACPI-PM/1-13-ACPI-PM-Check-device-state-before-refcounting-power-resources.patch
  (+) OK   ACPI-PM/2-13-ACPI-PM-Do-not-refcount-power-resources-that-can-t-be-turned-on.patch
  (+) OK   ACPI-PM/3-13-ACPI-PM-Prevent-acpi_power_get_inferred_state-from-making-changes.patch
  (+) OK   ACPI-PM/4-13-ACPI-PM-Add-functions-for-manipulating-lists-of-power-resources.patch
  (+) OK   ACPI-PM/5-13-ACPI-PM-Introduce-function-for-refcounting-device-power-resources.patch
  (+) OK   ACPI-PM/6-13-ACPI-PM-Introduce-__acpi_bus_get_power.patch
  (+) OK   ACPI-PM/7-13-ACPI-PM-Add-function-for-device-power-state-initialization.patch
  (+) OK   ACPI-PM/8-13-ACPI-PM-Add-function-for-updating-device-power-state-consistently.patch
  (+) OK   ACPI-PM/9-13-ACPI-PM-Register-acpi_power_driver-early.patch
  (+) OK   ACPI-PM/10-13-ACPI-PM-Register-power-resource-devices-as-soon-as-they-are-needed.patch
  (+) OK   ACPI-PM/11-13-ACPI-Fan-Rework-the-handling-of-power-resources.patch
  (+) OK   ACPI-PM/12-13-ACPI-PM-Drop-acpi_bus_get_power.patch
  (+) OK   ACPI-PM/13-13-ACPI-PM-Drop-acpi_power_nocheck.patch
  (+) OK   ACPI-PM-fix/Platform-x86-Make-fujitsu_laptop-use-acpi_bus_update_power.patch

# modinfo fujitsu-laptop
filename:
/lib/modules/2.6.37-rc3-686/kernel/drivers/platform/x86/fujitsu-laptop.ko
alias:          dmi:*:svnFUJITSU:*:pvr:rvnFUJITSU:rnFJNB19C:*:cvrS7020:*
alias:          dmi:*:svnFUJITSUSIEMENS:*:pvr:rvnFUJITSU:rnFJNB1E6:*:cvrS6420:*
alias:          dmi:*:svnFUJITSUSIEMENS:*:pvr:rvnFUJITSU:rnFJNB1D3:*:cvrS6410:*
license:        GPL
version:        0.6.0
description:    Fujitsu laptop extras support
author:         Jonathan Woithe, Peter Gruber, Tony Vroon
srcversion:     FFA7AB6B6C940453C0946B4
alias:          acpi*:FUJ02E3:*
alias:          pnp:dFUJ02E3*
alias:          acpi*:FUJ02B1:*
alias:          pnp:dFUJ02B1*
alias:          acpi*:FUJ02BF:*
alias:          pnp:dFUJ02bf*
depends:
vermagic:       2.6.37-rc3-686 SMP mod_unload modversions 686
parm:           use_alt_lcd_levels:Use alternative interface for
lcd_levels (needed for Lifebook s6410). (uint)
parm:           disable_brightness_adjust:Disable brightness adjustment . (uint)
