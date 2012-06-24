Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754213Ab2FXTzL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2012 15:55:11 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:37644 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752506Ab2FXTzJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2012 15:55:09 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Vikram Dhillon <opensolarisdev@gmail.com>
Subject: Re: [PATCH 16/21] toshiba_bluetooth: Use struct dev_pm_ops for power management
Date: Sun, 24 Jun 2012 22:00:35 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0-rc3+; KDE/4.6.0; x86_64; ; )
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        platform-driver-x86@vger.kernel.org,
        Eric Piel <eric.piel@tremplin-utc.net>,
        Mattia Dongili <malattia@linux.it>,
        Harald Welte <laforge@gnumonks.org>
References: <201206232306.06602.rjw@sisk.pl> <201206232318.18196.rjw@sisk.pl> <CAK7t_7Vfgqps+iavyQmXhj+CwSoBOEkCyFhTo_mXnC3stQtxDw@mail.gmail.com>
In-Reply-To: <CAK7t_7Vfgqps+iavyQmXhj+CwSoBOEkCyFhTo_mXnC3stQtxDw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201206242200.35607.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, June 24, 2012, Vikram Dhillon wrote:
> On Sat, Jun 23, 2012 at 5:18 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> >
> > Make the toshiba_bluetooth driver define its PM callbacks through
> > a struct dev_pm_ops object rather than by using legacy PM hooks
> > in struct acpi_device_ops.
> >
> > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> > ---
> >  drivers/platform/x86/toshiba_bluetooth.c |   10 ++++++----
> >  1 file changed, 6 insertions(+), 4 deletions(-)
> >
> > Index: linux/drivers/platform/x86/toshiba_bluetooth.c
> > ===================================================================
> > --- linux.orig/drivers/platform/x86/toshiba_bluetooth.c
> > +++ linux/drivers/platform/x86/toshiba_bluetooth.c
> > @@ -34,7 +34,6 @@ MODULE_LICENSE("GPL");
> >  static int toshiba_bt_rfkill_add(struct acpi_device *device);
> >  static int toshiba_bt_rfkill_remove(struct acpi_device *device, int type);
> >  static void toshiba_bt_rfkill_notify(struct acpi_device *device, u32 event);
> > -static int toshiba_bt_resume(struct acpi_device *device);
> >
> >  static const struct acpi_device_id bt_device_ids[] = {
> >        { "TOS6205", 0},
> > @@ -42,6 +41,9 @@ static const struct acpi_device_id bt_de
> >  };
> >  MODULE_DEVICE_TABLE(acpi, bt_device_ids);
> >
> > +static int toshiba_bt_resume(struct device *dev);
> > +static SIMPLE_DEV_PM_OPS(toshiba_bt_pm, NULL, toshiba_bt_resume);
> > +
> >  static struct acpi_driver toshiba_bt_rfkill_driver = {
> >        .name =         "Toshiba BT",
> >        .class =        "Toshiba",
> > @@ -50,9 +52,9 @@ static struct acpi_driver toshiba_bt_rfk
> >                                .add =          toshiba_bt_rfkill_add,
> >                                .remove =       toshiba_bt_rfkill_remove,
> >                                .notify =       toshiba_bt_rfkill_notify,
> > -                               .resume =       toshiba_bt_resume,
> >                        },
> >        .owner =        THIS_MODULE,
> > +       .drv.pm =       &toshiba_bt_pm,
> >  };
> >
> >
> > @@ -88,9 +90,9 @@ static void toshiba_bt_rfkill_notify(str
> >        toshiba_bluetooth_enable(device->handle);
> >  }
> >
> > -static int toshiba_bt_resume(struct acpi_device *device)
> > +static int toshiba_bt_resume(struct device *dev)
> >  {
> > -       return toshiba_bluetooth_enable(device->handle);
> > +       return toshiba_bluetooth_enable(to_acpi_device(dev)->handle);
> >  }
> >
> >  static int toshiba_bt_rfkill_add(struct acpi_device *device)
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> 
> Looks good, will look into the other struct patch (#11) tomorrow.
> 
> Reviewed-by: Vikram Dhillon <opensolarisdev@gmail.com>

Thanks a lot!

Rafael
