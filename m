Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934545Ab0KQHer (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 02:34:47 -0500
Received: from novprvlin0050.provo.novell.com ([137.65.248.33]:5493 "EHLO
	novprvlin0050.provo.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933237Ab0KQHep (ORCPT
	<rfc822;groupwise-jlee@novell.com:5:2>);
	Wed, 17 Nov 2010 02:34:45 -0500
Message-Id: <4CE42042020000230002406A@novprvlin0050.provo.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.2 
Date: Wed, 17 Nov 2010 00:34:42 -0700
From: "Joey Lee" <jlee@novell.com>
To: <rui.zhang@intel.com>
Cc: <mingo@elte.hu>, <lenb@kernel.org>, <airlied@redhat.com>,
        <linux-acpi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH]  do not select ACPI_VIDEO in poulsbo stub driver
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rui,

於 三，2010-11-17 於 11:16 +0800，Zhang Rui 提到：
> On Wed, 2010-11-17 at 11:04 +0800, Joey Lee wrote:
> > Hi Rui, 
> > 
> > 於 三，2010-11-17 於 08:42 +0800，Zhang Rui 提到：
> > > On Tue, 2010-11-16 at 15:34 +0800, Joey Lee wrote:
> > > > Hi Rui, 
> > > > 
> > > > Sorry about this patch will not work on my MSi poulsbo machine.
> > > > 
> > > > 於 二，2010-11-16 於 14:04 +0800，Zhang Rui 提到：
> > > > > the poulsbo stub driver should not select ACPI video driver.
> > > > > 
> > > > > The reason why i915 driver selects ACPI video driver is that it needs some
> > > > > cooperation between these two drivers during initialization, or else the
> > > > > system may hang.
> > > > > 
> > > > > So if users want ACPI backlight control, please set CONFIG_ACPI_VIDEO manually.
> > > > > 
> > > > > http://marc.info/?l=linux-acpi&m=128952659018533&w=2
> > > > > 
> > > > > CC: Ingo Molnar <mingo@elte.hu>
> > > > > CC: Dave Airlie <airlied@redhat.com>
> > > > > CC: Lee, Chun-Yi <joeyli.kernel@gmail.com>
> > > > > Signed-off-by: Zhang Rui <rui.zhang@intel.com>
> > > > > ---
> > > > >  drivers/gpu/stub/Kconfig   |   11 +----------
> > > > >  drivers/gpu/stub/poulsbo.c |    5 +----
> > > > >  2 files changed, 2 insertions(+), 14 deletions(-)
> > > > > 
> > > > > Index: linux-2.6/drivers/gpu/stub/Kconfig
> > > > > ===================================================================
> > > > > --- linux-2.6.orig/drivers/gpu/stub/Kconfig
> > > > > +++ linux-2.6/drivers/gpu/stub/Kconfig
> > > > > @@ -1,16 +1,7 @@
> > > > >  config STUB_POULSBO
> > > > >  	tristate "Intel GMA500 Stub Driver"
> > > > >  	depends on PCI
> > > > > -	# Poulsbo stub depends on ACPI_VIDEO when ACPI is enabled
> > > > > -	# but for select to work, need to select ACPI_VIDEO's dependencies, ick
> > > > > -	select VIDEO_OUTPUT_CONTROL if ACPI
> > > > > -	select BACKLIGHT_CLASS_DEVICE if ACPI
> > > > > -	select INPUT if ACPI
> > > > > -	select ACPI_VIDEO if ACPI
> > > > >  	help
> > > > >  	  Choose this option if you have a system that has Intel GMA500
> > > > >  	  (Poulsbo) integrated graphics. If M is selected, the module will
> > > > > -	  be called Poulsbo. This driver is a stub driver for Poulsbo that
> > > > > -	  will call poulsbo.ko to enable the acpi backlight control sysfs
> > > > > -	  entry file because there have no poulsbo native driver can support
> > > > > -	  intel opregion.
> > > > > +	  be called Poulsbo.
> > > > > Index: linux-2.6/drivers/gpu/stub/poulsbo.c
> > > > > ===================================================================
> > > > > --- linux-2.6.orig/drivers/gpu/stub/poulsbo.c
> > > > > +++ linux-2.6/drivers/gpu/stub/poulsbo.c
> > > > > @@ -11,8 +11,6 @@
> > > > >  
> > > > >  #include <linux/module.h>
> > > > >  #include <linux/pci.h>
> > > > > -#include <linux/acpi.h>
> > > > > -#include <acpi/video.h>
> > > > >  
> > > > >  #define DRIVER_NAME "poulsbo"
> > > > >  
> > > > > @@ -29,12 +27,11 @@ static DEFINE_PCI_DEVICE_TABLE(pciidlist
> > > > >  
> > > > >  static int poulsbo_probe(struct pci_dev *pdev, const struct pci_device_id *id)
> > > > >  {
> > > > > -	return acpi_video_register();
> > > > > +	return 0;
> > > > >  }
> > > > 
> > > > Sorry, we cann't remove to call acpi_video_register, because the acpi
> > > > video will not generate because there have some poulsbo machine declare
> > > > Intel opregion in DSDT but the i915 driver not support poulsbo.
> > > > 
> > > I'm confused.
> > > It's the i915 driver that supports Intel Opregion.
> > > i.e. for a poulsbo machine with Intel Opregion, loading ACPI video
> > > driver won't help neither.
> > > 
> > 
> > Matthew have a patch:
> > 
> >       * http://git.kernel.org/?p=linux/kernel/git/lenb/linux-acpi-2.6.git;a=commitdiff;h=74a365b3f354fafc537efa5867deb7a9fadbfe27
> > 
> > This patch do:
> > 
> > - ACPI video driver will not register if it check the DSDT have opregion table declare.
> > - i915_opregion will call acpi_video_register after it initialised the DIDL field in opregion.
> > 
> > That means acpi video driver will blocked when have opregion declare in
> > DSDT until i915 drm driver call acpi_video_register. The patch fixed
> > BKO#11259, but introduced a side effect: If there have Intel video chip
> > not supported by Intel drm driver, the acpi_video_register will never
> > called, then some machine have good acpi backlight interface
> > implementation will never have acpi brightness sysfs interface for
> > userland control. e.g. any Poulsbo netbook.
> > 
> > Matthew's comment to talk about the side effect: Intel IGD opregion and
> > GMA500
> > 
> > There have some machines declare opregion in DSDT but they also
> > implement the backlight control by EC in _BCM. Like: MSI poulsbo
> > netbook.
> > Before introduce the above patch to kernel, those machine's acpi
> > backlight control works fine. On current kernel, those machines
> > backlight control broken.
> > 
> > One function workable with old kernel but broken by new kernel, now.
> > 
> Oh, I see what the problem is.
> You're right, this patch doesn't make sense. Sorry for the noise. :)
> 
> thanks,
> rui

No problem, and thank's for your review and take care :-)

Joey Lee

