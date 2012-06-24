Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754118Ab2FXUIk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2012 16:08:40 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:37706 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751036Ab2FXUIi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2012 16:08:38 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: =?utf-8?q?=C3=89ric_Piel?= <eric.piel@tremplin-utc.net>
Subject: Re: [PATCH 13/21] hp_accel: Use struct dev_pm_ops for power management
Date: Sun, 24 Jun 2012 22:14:03 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0-rc3+; KDE/4.6.0; x86_64; ; )
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        platform-driver-x86@vger.kernel.org,
        Mattia Dongili <malattia@linux.it>,
        Harald Welte <laforge@gnumonks.org>
References: <201206232306.06602.rjw@sisk.pl> <201206232316.20989.rjw@sisk.pl> <4FE771F6.7000206@tremplin-utc.net>
In-Reply-To: <4FE771F6.7000206@tremplin-utc.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201206242214.04106.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, June 24, 2012, Éric Piel wrote:
> On 23-06-12 23:16, Rafael J. Wysocki wrote:
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> >
> > Make the hp_accel driver define its PM callbacks through
> > a struct dev_pm_ops object rather than by using legacy PM hooks
> > in struct acpi_device_ops.
> >
> > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> Hello,
> Looks fine from my point of view.
> 
> Reviewed-by: Éric Piel <eric.piel@tremplin-utc.net>

Thanks a lot!

Rafael


> > ---
> >   drivers/platform/x86/hp_accel.c |   15 ++++++++-------
> >   1 file changed, 8 insertions(+), 7 deletions(-)
> >
> > Index: linux/drivers/platform/x86/hp_accel.c
> > ===================================================================
> > --- linux.orig/drivers/platform/x86/hp_accel.c
> > +++ linux/drivers/platform/x86/hp_accel.c
> > @@ -353,20 +353,22 @@ static int lis3lv02d_remove(struct acpi_
> >
> >
> >   #ifdef CONFIG_PM
> > -static int lis3lv02d_suspend(struct acpi_device *device)
> > +static int lis3lv02d_suspend(struct device *dev)
> >   {
> >   	/* make sure the device is off when we suspend */
> >   	lis3lv02d_poweroff(&lis3_dev);
> >   	return 0;
> >   }
> >
> > -static int lis3lv02d_resume(struct acpi_device *device)
> > +static int lis3lv02d_resume(struct device *dev)
> >   {
> >   	return lis3lv02d_poweron(&lis3_dev);
> >   }
> > +
> > +static SIMPLE_DEV_PM_OPS(hp_accel_pm, lis3lv02d_suspend, lis3lv02d_resume);
> > +#define HP_ACCEL_PM (&hp_accel_pm)
> >   #else
> > -#define lis3lv02d_suspend NULL
> > -#define lis3lv02d_resume NULL
> > +#define HP_ACCEL_PM NULL
> >   #endif
> >
> >   /* For the HP MDPS aka 3D Driveguard */
> > @@ -377,9 +379,8 @@ static struct acpi_driver lis3lv02d_driv
> >   	.ops = {
> >   		.add     = lis3lv02d_add,
> >   		.remove  = lis3lv02d_remove,
> > -		.suspend = lis3lv02d_suspend,
> > -		.resume  = lis3lv02d_resume,
> > -	}
> > +	},
> > +	.drv.pm = HP_ACCEL_PM,
> >   };
> >
> >   static int __init lis3lv02d_init_module(void)
> >
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

